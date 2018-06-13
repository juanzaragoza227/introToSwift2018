//
//  MapAnotationHelper.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/27/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit
import MapKit

final class MapAnotationHelper: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let name: String
    let code: String
    
    init(coordinate: CLLocationCoordinate2D, name :String, code: String) {
        self.coordinate = coordinate
        self.name = name
        self.code = code
        super.init()
    }
    
    var title: String? {
        return "\(name)"
    }
    
    var subtitle: String? {
        return "Code: \(code)"
    }
}
