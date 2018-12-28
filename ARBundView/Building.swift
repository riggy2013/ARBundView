//
//  Building.swift
//  BundView
//
//  Created by David Peng on 24/02/2017.
//  Copyright © 2017 David Peng. All rights reserved.
//

import UIKit
import CoreLocation

class Building {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var url: URL
    var searchAddress: String?
    var coordinate: CLLocationCoordinate2D?
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, url: URL) {
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }

        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.url = url
        
        self.coordinate = CLLocationCoordinate2D()
        
    }
}
