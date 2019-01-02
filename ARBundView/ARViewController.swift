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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
