//
//  WeatherStationDetailViewController.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/24/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit
import MapKit

class WeatherStationsDetailsVC: UIViewController {
    
    let queryService = QueryService()
    let appData = AppData.shared
    let regionRadius: CLLocationDistance = 1000

    var weatherStation: WeatherStations!
    var newFavoriteStation: [WeatherStations] = []
    var stationAddress: String = ""
    var favoriteStation: [WeatherStations] {
        return appData.favoriteList
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stationDetailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        title = "Details"
        newFavoriteStation = favoriteStation
        configureFavoriteButton()

        if !existAsFavorite() || weatherStation.address == "" {
            getWeatherStationAddress()
        }else {
            showWeatherStationsMap()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    private func configureFavoriteButton(){
        let logo = UIImage(named: "favorite.png")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: logo, style: .plain , target: self, action: #selector(favoriteButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = existAsFavorite() ? UIColor.myRed : UIColor.lightGray
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func favoriteButtonPressed() {
        if existAsFavorite() {
            removeFavorite()
            appData.updateFavoriteList(with: newFavoriteStation)
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
        }else {
            weatherStation.address = stationAddress
            newFavoriteStation.append(weatherStation)
            appData.updateFavoriteList(with: newFavoriteStation)
            navigationItem.rightBarButtonItem?.tintColor = UIColor.myRed
        }
    }
}
//Mark: Gets address and configure map and details
extension WeatherStationsDetailsVC {
    private func getWeatherStationAddress(){
        let longitud = weatherStation.longitud
        let latitude = weatherStation.latitude
        
        queryService.fetchWeatherStationAddress(latitude, longitud) { [weak self] (success, error, address) in
            if success {
                if address?.results.count != 0 {
                    self?.stationAddress = (address?.results[0].formattedAddress)!
                }else {
                    self?.stationAddress = ""
                }
            }
            self?.showWeatherStationsMap()
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    private func showWeatherStationsMap(){
        let longitud = Double(weatherStation.longitud)
        let latitude = Double(weatherStation.latitude)
        
        let location = CLLocation(latitude: latitude!, longitude: longitud!)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true) 
        
        let annotationCoordinates = CLLocationCoordinate2D(latitude: latitude!, longitude: longitud!)
        let annotation = MapAnotationHelper(coordinate: annotationCoordinates, name: weatherStation.stationName, code: weatherStation.stationCode)
        
        mapView.addAnnotation(annotation)
        
        setUpDetails()
    }
    
    private func setUpDetails() {
        var address = ""
        if stationAddress != ""  {
            address = "Address: \(stationAddress) \n\n"
        }
        stationDetailsLabel.text = "\(address)Coordinates: Latitude (\(weatherStation.latitude)), longitude (\(weatherStation.longitud)) \n\nElevation: \(weatherStation.elevation) \n\nStatus: \(weatherStation.isActive)"
    }
}
//Mark: Loops to validate and remove station
extension WeatherStationsDetailsVC {
    private func existAsFavorite() -> Bool{
        let stationId = weatherStation.stationCode
        for station in newFavoriteStation {
            if station.stationCode == stationId {
                stationAddress = station.address!
                return true
            }
        }
        return false
    }
    
    private func removeFavorite(){
        let stationId = weatherStation.stationCode
        for i in 0..<newFavoriteStation.count {
            if stationId == newFavoriteStation[i].stationCode  {
                newFavoriteStation.remove(at: i)
                return
            }
        }
    }
}
