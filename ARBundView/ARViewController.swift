//
//  ARViewController.swift
//  ARBundView
//
//  Created by David Peng on 2019/1/2.
//  Copyright © 2019 David Peng. All rights reserved.
//

import UIKit
import CoreLocation

class ARViewController: UIViewController {

    @IBOutlet weak var sceneLocView: SceneLocationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sceneLocView.run()
        
        showARLabels()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Private functions
    func showARLabels() {
        for build in builds[19...19] {
            let location = CLLocation(coordinate: build.coordinate!, altitude: 0)
            let image = UIImage(named: "pin")!
            
            let annotationNode = LocationAnnotationNode(location: location, image: image)
            
            sceneLocView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
}
