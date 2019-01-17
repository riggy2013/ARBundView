//
//  ARViewController.swift
//  ARBundView
//
//  Created by David Peng on 2019/1/2.
//  Copyright © 2019 David Peng. All rights reserved.
//

import UIKit
import CoreLocation
import ARKit

class ARViewController: UIViewController {

    @IBOutlet weak var sceneLocView: SceneLocationView!
    
    var tapRecognizer: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sceneLocView.run()
        
        showARLabels()
        
        initTapRecognizer()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
        case "arShowDetail":
            guard let webViewController = segue.destination as? WebViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedAnnotationNode = sender as? SCNNode else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            for build in builds {
                if build.name == selectedAnnotationNode.name {
                    webViewController.build = build
                    break
                }
            }
        case "arShowList":
            break
        case "arShowMap":
            break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    // MARK: - Private functions
    func showARLabels() {
        for build in builds {
            let location = CLLocation(coordinate: build.coordinate!, altitude: 0)
//            let image = UIImage(named: "pin")!
            
//            let annotationNode = LocationAnnotationNode(location: location, image: image)
            let annotationNode = LocationAnnotationNode(location: location, title: build.name)
            
            sceneLocView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
    
    func initTapRecognizer() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.didTap(withGestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        sceneLocView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneLocView)
        
        let hitResults = sceneLocView.hitTest(location)
        
        guard let node = hitResults.first?.node else { return }
        
//        print(node.parent?.name)
        performSegue(withIdentifier: "arShowDetail", sender: node.parent)

    }
}
