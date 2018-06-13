//
//  ItemsResponse.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/14/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import Foundation

struct WeatherStationsResponse: Codable {
    var weathersStations: [WeatherStations] = []
}

//Weather Stations (Active and inactive)
//https://data.pr.gov/resource/rrrk-eia6.json
//{
//    "active": "Yes",
//    "coord_x_y": {
//        "type": "Point",
//        "coordinates": [
//        -66.6589,
//        18.4414
//        ]
//    },
//    "elevation": "29.6",
//    "station_code": "RQ1PRAC0001",
//    "station_name": "ARECIBO 5.2 ESE",
//    "x": "-66.6589",
//    "y": "18.4414"
//}



