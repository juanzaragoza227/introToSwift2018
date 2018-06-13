//
//  WeatherStationsDetailResponse.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/19/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import Foundation

struct WeatherStationsDetailsResponse: Codable {
    let results: [Result]
}

struct Result: Codable {
    let formattedAddress: String
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
    }
}
//https://maps.googleapis.com/maps/api/geocode/json?latlng=xx.xxxx,-xx.xxxx&key=AIzaSyCyjQhd2LHqrIF2VYSpD5yIrhu_CO7CQus
