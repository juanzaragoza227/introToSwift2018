//
//  AddCell.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 6/9/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

protocol TextEntryDelegate: class {
    func didUpdateField(_ text: String, _ addCellType: AddCellType?)
}

class AddCell: UITableViewCell {
 
    var addCellType: AddCellType? = nil
    weak var delegate: TextEntryDelegate?
    
    let picker = UIPickerView()
    let statusName = ["Select Status", "Active", "Inactive"]
    let permitedText = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", ".", ""]
    
    @IBOutlet weak var addLabel: UILabel! {
        didSet {
            addLabel.addLabelConfig()
        }
    }
    @IBOutlet weak var addTextField: UITextField!{
        didSet {
            addTextField.delegate = self
            picker.delegate = self
            picker.dataSource = self
        }
    }
}
//Mark: Managing entered text
extension AddCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = addTextField.text else { return false }
        let expectedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if addCellType == AddCellType.latitude || addCellType == AddCellType.longitude {
            if !permitedText.contains(string) {
                return false
            }
        }
        delegate?.didUpdateField(expectedText, addCellType)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//Mark: Managing status picker
extension AddCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusName.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusName[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            return
        }
        self.addTextField.text = statusName[row]
        delegate?.didUpdateField(statusName[row], addCellType)
        endEditing(true)
    }
}
