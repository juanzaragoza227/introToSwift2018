//
//  AddViewController.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 6/3/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: class {
    func didPressSaveButton(didFinishAdding newStation: WeatherStations)
    //func didPressSaveButton(didFinishEditing creditCard: CreditCard)
}
class AddViewController: UIViewController {
    
    var newStation = WeatherStations()
    weak var delegate: AddViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        title = "Add"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .myRed
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
   @objc private func saveButtonPressed(){
        let uuid = UUID().uuidString
        newStation.stationCode = uuid
        newStation.address = ""
        delegate?.didPressSaveButton(didFinishAdding: newStation)
    }
    
    private func updateSaveButton(){
        let isInfoFilledOut = newStation.areFieldsFilledOut
        navigationItem.rightBarButtonItem?.isEnabled = isInfoFilledOut
    }
}
//Mark: Configure number of rows and cell for row
extension AddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddCellType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = AddCellType(rawValue: indexPath.row)!
        return addDetailCellFor(cellType, indexPath)
    }
}
//Mark: Configures sections and tableview behavior
extension AddViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AddSectionType(rawValue: section)?.txt
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resignFirstResponder()
        self.view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textEntryCell", for: indexPath) as! AddCell
        cell.addTextField.text = ""
    }
}
//Mark: Configuring textField for cell
extension AddViewController {
    private func addDetailCellFor(_ cellType: AddCellType, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textEntryCell", for: indexPath) as! AddCell
        cell.addLabel.text = cellType.txt
        cell.delegate = self
        cell.addCellType = cellType

        switch cellType {
        case .name:
            cell.addTextField.becomeFirstResponder()
            cell.addTextField.keyboardType = .default
            cell.addTextField.autocapitalizationType = .allCharacters
            cell.addTextField.inputView = nil
            cell.addTextField.text = newStation.stationName
            break
        case .latitude:
            cell.addTextField.keyboardType = .numbersAndPunctuation
            cell.addTextField.inputView = nil
            cell.addTextField.text = newStation.latitude
            break
        case .longitude:
            cell.addTextField.keyboardType = .numbersAndPunctuation
            cell.addTextField.inputView = nil
            cell.addTextField.text = newStation.longitud
            break
        case .elevation:
            cell.addTextField.keyboardType = .decimalPad
            cell.addTextField.inputView = nil
            cell.addTextField.text = newStation.elevation
            break
        case .status:
            cell.addTextField.inputView = cell.picker
            cell.addTextField.text = newStation.isActive
            break
        }
        return cell
    }
}
//MARK: Updating values while typing
extension AddViewController: TextEntryDelegate {
    func didUpdateField(_ text: String, _ addCellType: AddCellType?) {
        if let type = addCellType {
            newStation = newStation.updateStationDetail(type, text)
        }
        updateSaveButton()
    }
}
//MARK: Keyboard config
extension AddViewController {
    @objc func keyboardWillShow(_ sender: Notification) {
        let height: CGFloat = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height ?? 0
        let duration: TimeInterval = (sender.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let curveOption: UInt = (sender.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.beginFromCurrentState.rawValue|curveOption), animations: {
            let edgeInsets = UIEdgeInsetsMake(0, 0, height, 0)
            self.tableView.contentInset = edgeInsets
            self.tableView.scrollIndicatorInsets = edgeInsets
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let duration: TimeInterval = (sender.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let curveOption: UInt = (sender.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.beginFromCurrentState.rawValue|curveOption), animations: {
            let edgeInsets = UIEdgeInsets.zero
            self.tableView.contentInset = edgeInsets
            self.tableView.scrollIndicatorInsets = edgeInsets
        }, completion: nil)
    }
}
