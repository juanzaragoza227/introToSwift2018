//
//  SecondViewController.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/13/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {

    @IBOutlet weak var favoritesTableView: UITableView!
    
    let appData = AppData.shared
    var favoriteStationsList: [WeatherStations] {
        return appData.favoriteList
    }
    var weatherStationResponse: [WeatherStations] {
        return appData.weatherStationsList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavController(rightButtonTitle: nil, leftButtonTitle: nil, centerTitle: "Weather Stations")
        configureTabBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .myRed

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        self.favoritesTableView.reloadData()
    }
    
    @objc private func addButtonPressed(){
        if let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddViewController {
            addVC.delegate = self
            navigationController?.pushViewController(addVC, animated: true)
        }
    }
}
//MARK: TableView Delegate - EmptyTableLabel, CellConfiguration, TableViewRearrangeConfiguration.
extension FavoritesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let emptyLabel = UILabel()
        if favoriteStationsList.count == 0 {
            emptyLabel.text = "No Favorites Selected!"
            emptyLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = .none
        }
        return favoriteStationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! FavoritesCell
        let weatherStation = favoriteStationsList[indexPath.row]
        cell.stationName.text = weatherStation.stationName.uppercased()
        cell.stationDetails.text = "Lat (\(weatherStation.latitude)), Long (\(weatherStation.longitud))"
        cell.stationColorIdentifierIfActive.backgroundColor = weatherStation.isActive == "Active" ? UIColor.myBlue : UIColor.lightGray
        return cell
    }
    
   func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var weatherStationList: [WeatherStations] = favoriteStationsList
        let movedObject = weatherStationList[sourceIndexPath.row]
        weatherStationList.remove(at: sourceIndexPath.row)
        weatherStationList.insert(movedObject, at: destinationIndexPath.row)
        appData.updateFavoriteList(with: weatherStationList)
    }
}

//MARK: TableViewDelegate - ActionSheetConfigurationFor(ShowDetails, Rearrange, Delete, Cancel).
extension FavoritesVC: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentActionSheetWith(indexPath)
    }
    
    private func presentActionSheetWith(_ indexPath: IndexPath) {
        let actionSheetController = UIAlertController(title: "Select action for:", message:"\(favoriteStationsList[indexPath.row].stationName)", preferredStyle: .actionSheet)
        
        let pushAction = UIAlertAction(title: "Show Details", style: .default) { [weak self] (_) in self?.pushView(indexPath)}
        let rearrangeAction =  UIAlertAction(title: "Rearrange", style: .default) { [weak self] (_) in self?.rearrange()}
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in self?.delete(indexPath)}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheetController.addAction(pushAction)
        actionSheetController.addAction(rearrangeAction)
        actionSheetController.addAction(deleteAction)
        actionSheetController.addAction(cancelAction)
        
        navigationController?.present(actionSheetController, animated: true, completion: nil)
    }
    
    private func pushView(_ indexPath: IndexPath){
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? WeatherStationsDetailsVC {
            detailVC.weatherStation = favoriteStationsList[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    private func rearrange(){
        favoritesTableView.isEditing = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .myRed
    }
    
    @objc private func doneButtonPressed(){
        favoritesTableView.isEditing = false
         navigationItem.leftBarButtonItem = .none
    }
    
    private func delete(_ indexPath: IndexPath){
        var weatherStationList: [WeatherStations] = favoriteStationsList
        weatherStationList.remove(at: indexPath.row)
        appData.updateFavoriteList(with: weatherStationList)
        favoritesTableView.reloadData()
    }
}

extension FavoritesVC: AddViewControllerDelegate {
    func didPressSaveButton(didFinishAdding newStation: WeatherStations) {
        navigationController?.popViewController(animated: true)
        var weatherStationList: [WeatherStations] = favoriteStationsList
        weatherStationList.append(newStation)
        appData.updateFavoriteList(with: weatherStationList)
        favoritesTableView.reloadData()
    }
}
