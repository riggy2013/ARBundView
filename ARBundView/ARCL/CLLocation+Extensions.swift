//
//  CLLocation+Extensions.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import Foundation
import CoreLocation

let EARTH_RADIUS = 6371000.0

///Translation in meters between 2 locations
public struct LocationTranslation {
    public var latitudeTranslation: Double
    public var longitudeTranslation: Double
    public var altitudeTranslation: Double

    public init(latitudeTranslation: Double, longitudeTranslation: Double, altitudeTranslation: Double) {
        self.latitudeTranslation = latitudeTranslation
        self.longitudeTranslation = longitudeTranslation
        self.altitudeTranslation = altitudeTranslation
    }
}

public extension CLLocation {
    public convenience init(coordinate: CLLocationCoordinate2D, altitude: CLLocationDistance) {
        self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    }

    ///Translates distance in meters between two locations.
    ///Returns the result as the distance in latitude and distance in longitude.
    public func translation(toLocation location: CLLocation) -> LocationTranslation {
        let inbetweenLocation = CLLocation(latitude: self.coordinate.latitude, longitude: location.coordinate.longitude)

        let distanceLatitude = location.distance(from: inbetweenLocation)

        let latitudeTranslation: Double

        if location.coordinate.latitude > inbetweenLocation.coordinate.latitude {
            latitudeTranslation = distanceLatitude
        } else {
            latitudeTranslation = 0 - distanceLatitude
        }

        let distanceLongitude = self.distance(from: inbetweenLocation)

        let longitudeTranslation: Double

        if self.coordinate.longitude > inbetweenLocation.coordinate.longitude {
            longitudeTranslation = 0 - distanceLongitude
        } else {
            longitudeTranslation = distanceLongitude
        }

        let altitudeTranslation = location.altitude - self.altitude

        return LocationTranslation(
            latitudeTranslation: latitudeTranslation,
            longitudeTranslation: longitudeTranslation,
            altitudeTranslation: altitudeTranslation)
    }

    public func translatedLocation(with translation: LocationTranslation) -> CLLocation {
        let latitudeCoordinate = self.coordinate.coordinateWithBearing(bearing: 0, distanceMeters: translation.latitudeTranslation)

        let longitudeCoordinate = self.coordinate.coordinateWithBearing(bearing: 90, distanceMeters: translation.longitudeTranslation)

        let coordinate = CLLocationCoordinate2D(
            latitude: latitudeCoordinate.latitude,
            longitude: longitudeCoordinate.longitude)

        let altitude = self.altitude + translation.altitudeTranslation

        return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.verticalAccuracy, timestamp: self.timestamp)
    }
    
    public func toMarsGS() -> CLLocation {
        let coordinate = CLLocationCoordinate2D(
            latitude: self.coordinate.WorldGS2MarsGS().latitude,
            longitude: self.coordinate.WorldGS2MarsGS().longitude)
 
        return CLLocation(coordinate: coordinate, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.verticalAccuracy, timestamp: self.timestamp)
    }
}

public extension CLLocationCoordinate2D {
    public func coordinateWithBearing(bearing: Double, distanceMeters: Double) -> CLLocationCoordinate2D {
		// formula by http://www.movable-type.co.uk/scripts/latlong.html
		let lat1 = self.latitude * Double.pi / 180
		let lon1 = self.longitude * Double.pi / 180

		let distance = distanceMeters / EARTH_RADIUS
		let angularBearing = bearing * Double.pi / 180

		var lat2 = lat1 + distance * cos(angularBearing)
		let dLat = lat2 - lat1
		let dPhi = log(tan(lat2 / 2 + Double.pi/4) / tan(lat1 / 2 + Double.pi/4))
		let q = (dPhi != 0) ? dLat/dPhi : cos(lat1)  // E-W line gives dPhi=0
		let dLon = distance * sin(angularBearing) / q

		// check for some daft bugger going past the pole
		if fabs(lat2) > Double.pi/2 {
			lat2 = lat2 > 0 ? Double.pi - lat2 : -(Double.pi - lat2)
		}
		var lon2 = lon1 + dLon + 3 * Double.pi
		while lon2 > 2 * Double.pi {
			lon2 -= 2 * Double.pi
		}
		lon2 -= Double.pi

        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}

public extension CLLocationCoordinate2D {
    public func WorldGS2MarsGS() -> CLLocationCoordinate2D {
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
        let wgLat:Double = self.latitude;
        let wgLon:Double = self.longitude;
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
    
    private func transformLat(_ x: Double, _ y: Double) -> Double {
        var ret: Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
        ret += (20.0 * sin(6.0 * x * Double.pi) + 20.0 * sin(2.0 * x * Double.pi)) * 2.0 / 3.0;
        ret += (20.0 * sin(y * Double.pi) + 40.0 * sin(y / 3.0 * Double.pi)) * 2.0 / 3.0;
        ret += (160.0 * sin(y / 12.0 * Double.pi) + 320 * sin(y * Double.pi / 30.0)) * 2.0 / 3.0;
        return ret;
    }
    
    private func transformLon(_ x: Double, _ y: Double) -> Double {
        var ret: Double = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
        ret += (20.0 * sin(6.0 * x * Double.pi) + 20.0 * sin(2.0 * x * Double.pi)) * 2.0 / 3.0;
        ret += (20.0 * sin(x * Double.pi) + 40.0 * sin(x / 3.0 * Double.pi)) * 2.0 / 3.0;
        ret += (150.0 * sin(x / 12.0 * Double.pi) + 300.0 * sin(x / 30.0 * Double.pi)) * 2.0 / 3.0;
        return ret;
    }
    
}
