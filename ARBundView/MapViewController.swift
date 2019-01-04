//
//  MapViewController.swift
//  ARBundView
//
//  Created by David Peng on 2018/12/26.
//  Copyright © 2018 David Peng. All right(s reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        // Do any additional setup after loading the view.
        initMapView()
        loadBuildingAnnotations()
        
        // testing, show current location
        initLocManager()
        
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKPointAnnotation.self) {
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pointReuseIndentifier") as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView.init(annotation: annotation, reuseIdentifier: "pointReuseIndentifier")
            }
            
            annotationView!.canShowCallout = true
//            annotationView!.animatesDrop = true
//            annotationView?.isDraggable = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "mapShowDetail", sender: view)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
        case "mapShowDetail":
            guard let webViewController = segue.destination as? WebViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedAnnotation = sender as? MKAnnotationView else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            for build in builds {
                if build.name == selectedAnnotation.annotation?.title {
                    webViewController.build = build
                    break
                }
            }
        case "mapShowList":
            break
        case "mapShowAR":
            break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    func initMapView() {
        // set initial location in the Bund Shanghai.
        let initialLocation = CLLocationCoordinate2D(latitude: 31.23799032, longitude: 121.48983657)
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
    }
    
    func loadBuildingAnnotations() {
        
        for build in builds {
            if build.searchAddress != nil {
                let annotation = MKPointAnnotation()
                annotation.coordinate = build.coordinate!
                annotation.title = build.name
                self.mapView.addAnnotation(annotation)
                
//                showAnnotation(build: build)
            }
        }
        
        showAnnotation(builds[19])
}


    func showAnnotation(_ build: Building) {
        let address = build.searchAddress!
        
        let initialLocation = CLLocationCoordinate2D(latitude: 31.23799032, longitude: 121.48983657)
//        let region = CLCircularRegion(center: initialLocation, radius: 10000, identifier: "The Bund")

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, /*in: region,*/ completionHandler: { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    print("\(build.name), \(build.searchAddress), No location found.")
                    return
            }
            
            // Use your location
//            let mCoordinate = self.WorldGS2MarsGS(location.coordinate)
            print(build.name, build.searchAddress, location.coordinate)

            geoCoder.cancelGeocode()
        })
    }
    
    func initLocManager() {
        locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = WorldGS2MarsGS(locValue)
        annotation.title = "Current Location"
        self.mapView.addAnnotation(annotation)
        print(locValue)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let locValue: CLLocationCoordinate2D = userLocation.location?.coordinate else { return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "MapView Location"
//        self.mapView.addAnnotation(annotation)
//        print(locValue)
    }


    func WorldGS2MarsGS(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        // a = 6378245.0, 1/f = 298.3
        // b = a * (1 - f)
        // ee = (a^2 - b^2) / a^2;
        let a: Double = 6378245.0;
        let ee: Double = 0.00669342162296594323;
    
//        return coordinate;
        /*    if (outOfChina(coordinate.latitude, coordinate.longitude))
         {
         
         }
         */
        let wgLat:Double = coordinate.latitude;
        let wgLon:Double = coordinate.longitude;
        var dLat:Double = transformLat(wgLon - 105.0, wgLat - 35.0);
        var dLon:Double = transformLon(wgLon - 105.0, wgLat - 35.0);
        let radLat:Double = wgLat / 180.0 * Double.pi;
        var magic:Double = sin(radLat);
        magic = 1 - ee * magic * magic;
        let sqrtMagic:Double = sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * Double.pi);
        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * Double.pi);
    
        return CLLocationCoordinate2DMake(wgLat + dLat, wgLon + dLon);
    }
    
    func transformLat(_ x: Double, _ y: Double) -> Double {
        var ret: Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
        ret += (20.0 * sin(6.0 * x * Double.pi) + 20.0 * sin(2.0 * x * Double.pi)) * 2.0 / 3.0;
        ret += (20.0 * sin(y * Double.pi) + 40.0 * sin(y / 3.0 * Double.pi)) * 2.0 / 3.0;
        ret += (160.0 * sin(y / 12.0 * Double.pi) + 320 * sin(y * Double.pi / 30.0)) * 2.0 / 3.0;
        return ret;
    }
    
    func transformLon(_ x: Double, _ y: Double) -> Double {
        var ret: Double = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
        ret += (20.0 * sin(6.0 * x * Double.pi) + 20.0 * sin(2.0 * x * Double.pi)) * 2.0 / 3.0;
        ret += (20.0 * sin(x * Double.pi) + 40.0 * sin(x / 3.0 * Double.pi)) * 2.0 / 3.0;
        ret += (150.0 * sin(x / 12.0 * Double.pi) + 300.0 * sin(x / 30.0 * Double.pi)) * 2.0 / 3.0;
        return ret;
    }
 
}
