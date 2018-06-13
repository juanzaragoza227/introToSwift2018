//
//  AppData.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/19/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import Foundation

final class AppData {
    
    static let shared = AppData()
    private init() {}
    
    private var weatherStations: [WeatherStations] = []
    private var favoriteStations: [WeatherStations] = []
}
//MARK: - Public getters
extension AppData {
    var weatherStationsList: [WeatherStations] {
        return weatherStations.sorted(by: {return $0.stationName < $1.stationName})
    }
    
    var favoriteList: [WeatherStations] {
        return favoriteStations
    }
}
//MARK: - Mutating fuctions
extension AppData {
    func updateList(with weatherStationsResponse: [WeatherStations]?) {
        guard let response = weatherStationsResponse else {return}
        self.weatherStations = response
    }
    
    func updateFavoriteList(with favoriteStations: [WeatherStations]?) {
        guard let response = favoriteStations else {return}
        self.favoriteStations = response
        saveFavoritesStations()
    }
}
//MARK: Saving and Loading Favorite Stations
extension AppData {
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("FinalProjectJZ.plist")
    }
    
    func saveFavoritesStations() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(favoriteStations)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            print(favoriteStations)
        } catch {
            print("Error encoding weather stations array!")
        }
    }
    
    func loadFavoritesStations() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                favoriteStations = try decoder.decode([WeatherStations].self, from: data)
                print(favoriteStations)
            } catch {
                print("Error decoding weather stations array!")
            }
        }
    }
}
