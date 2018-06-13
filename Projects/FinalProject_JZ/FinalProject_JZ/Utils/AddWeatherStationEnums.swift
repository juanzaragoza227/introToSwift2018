//
//  AddWeatherStationEnums.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 6/9/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import Foundation

enum AddCellType: Int {
    case name
    case latitude
    case longitude
    case elevation
    case status
    
    var txt: String {
        switch self {
        case .name:
            return "Name"
        case .latitude:
            return "Latitude"
        case .longitude:
            return "Longitude"
        case .elevation:
            return "Elevation"
        case .status:
            return "Status"
        }
    }
    
    static var count: Int {
        return AddCellType.status.rawValue + 1
    }
}

enum AddSectionType: Int {
    case details
    
    var txt: String {
        switch self {
        case .details:
            return "Weather Station Details"
        }
    }
}
