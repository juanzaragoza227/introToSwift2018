//
//  QueryService.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/19/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import Foundation
import Alamofire

class QueryService {
    typealias SuccessResult = (Bool, String) -> ()
    let baseURL = "https://data.pr.gov/resource/rrrk-eia6.json"
    let addressBaseURL = "https://maps.googleapis.com/maps/api/geocode/json?"
    //latlng=40.714224,-73.961452
    let apiKey = "&key=AIzaSyCyjQhd2LHqrIF2VYSpD5yIrhu_CO7CQus"
    var errorMessage = ""
    var weatherStations = [WeatherStationsResponse]()
    let appData = AppData.shared
}

extension QueryService {
    func fetchWeatherStations(completion: @escaping SuccessResult) {
        Alamofire.request(baseURL).responseJSON { (response) in
            let didUpdate = self.updateResults(response)
            completion(didUpdate, self.errorMessage)
        }
    }
    
    func fetchWeatherStationAddress(_ latitude: String, _ longitude: String, completion: @escaping ( Bool, String, WeatherStationsDetailsResponse?) -> ()) {
        let addressURL = URL(string: "\(addressBaseURL)latlng=\(latitude),\(longitude)\(apiKey)")
        Alamofire.request(addressURL!).responseJSON { (response) in
            guard let data = response.data else {return}
            if let  weatherStationAddress = self.convertData(to: WeatherStationsDetailsResponse.self, data) {
                completion(true, self.errorMessage, weatherStationAddress)
            }else {
                completion(false, self.errorMessage, nil)
            }
        }
    }
}

extension QueryService {
    private func updateResults(_ response: DataResponse<Any>) -> Bool {
        guard let data = response.data else {return false}
        if let weatherStationsResponse = convertData(to: [WeatherStations].self, data) {
            appData.updateList(with: weatherStationsResponse)
            return true
        } else {
            return false
        }
    }
}
    
extension QueryService {
    private func convertData<T: Decodable>(to type: T.Type, _ data: Data) -> T?{
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
