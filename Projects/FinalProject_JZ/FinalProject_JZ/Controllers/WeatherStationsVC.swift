//
//  FirstViewController.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/13/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

class WeatherStationsVC: UITableViewController {

    let queryService = QueryService()
    let appData = AppData.shared
    
    var weatherStationsList: [WeatherStations] {
        return appData.weatherStationsList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavController(rightButtonTitle: nil, leftButtonTitle: nil, centerTitle: "Weather Stations")
        configureTabBar()
        loadWeatherStations()
        appData.loadFavoritesStations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func loadWeatherStations(){
        queryService.fetchWeatherStations { [weak self] (_, _) in
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherStationsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! WeatherStationsCell
        let weatherStation = weatherStationsList[indexPath.row]
        cell.ItemNameLabel.text = weatherStation.stationName.uppercased()
        cell.ItemDetailsLabel.text = "Lat (\(weatherStation.latitude)), Long (\(weatherStation.longitud))"
        cell.ItemColoredIdentificationView.backgroundColor = weatherStation.active == "Yes" ? UIColor.myBlue : UIColor.lightGray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? WeatherStationsDetailsVC {
            detailVC.weatherStation = weatherStationsList[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @IBAction func refreshWeatherStations(_ sender: UIRefreshControl) {
        loadWeatherStations()
        sender.endRefreshing()
    }
}
