//
//  ViewController.swift
//  Homework5_JZ
//
//  Created by Juan Zaragoza on 4/13/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var colorViewModels: [ColorViewModel] = []
    var segmentName = ["Reds","Blues","Random"]
    
    @IBOutlet weak var segmentControl: UISegmentedControl! {
        didSet{
            segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Color Table"
        view.backgroundColor = UIColor.groupTableViewBackground
        
        //setting titles for the 3 segments
        for segment in 0..<segmentName.count {
            let name = segmentName[segment]
            segmentControl.setTitle(name, forSegmentAt: segment)
        }
        
        colorViewModels = ColorManager.generateColors(desired: 100, segmentSelected: 0)
        tableView.reloadData()
    }
    

    @objc private func segmentControlValueChanged() {
        //print(segmentControl.selectedSegmentIndex)
        colorViewModels = ColorManager.generateColors(desired: 100, segmentSelected: segmentControl.selectedSegmentIndex)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let colorViewModel = colorViewModels[indexPath.row]
        configureTableViewCell(for: cell, with: colorViewModel)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = colorViewModels[indexPath.row]
        item.isSelected = !item.isSelected
        colorViewModels[indexPath.row] = item
        tableView.reloadData()
    }
}

func configureTableViewCell(for cell: UITableViewCell, with item: ColorViewModel) {
    cell.backgroundColor = item.color
    cell.textLabel?.text = item.name
    cell.textLabel?.textColor = .white
    
    if item.isSelected {
        cell.accessoryType = .checkmark
    } else {
        cell.accessoryType = .none
    }
}
