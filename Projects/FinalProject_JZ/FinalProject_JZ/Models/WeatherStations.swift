//
//  WeatherStations.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/19/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import Foundation

struct WeatherStations: Codable {
    var active: String = ""
    var elevation: String = ""
    var stationCode: String = ""
    var stationName: String = ""
    var longitud: String = ""
    var latitude: String = ""
    var address: String? = ""

    private enum  CodingKeys: String, CodingKey {
        case active
        case stationCode = "station_code"
        case stationName = "station_name"
        case longitud = "x"
        case latitude = "y"
        case elevation
    }
}

extension WeatherStations {
    var isActive: String {
        return active == "Yes" ? "Active" : "Inactive"
    }
}

extension WeatherStations {
    var areFieldsFilledOut: Bool {
        return !isActive.isEmpty && !elevation.isEmpty && !stationName.isEmpty && !latitude.isEmpty && !longitud.isEmpty
    }
    
    mutating func updateStationDetail(_ type: AddCellType, _ value: String) -> WeatherStations {
        switch type {
        case .status:
            let txt = value == "Active" ? "Yes" : "No"
            self.active = txt
        case .name:
            self.stationName = value
        case .elevation:
            self.elevation = value
        case .latitude:
            self.latitude = value
        case .longitude:
            self.longitud = value
        }
        return self
    }
}
