//
//  TextEntryCell.swift
//  Homework8_KL
//
//  Created by Kevin Lopez on 5/1/18.
//  Copyright © 2018 io.ricoLabs. All rights reserved.
//

import UIKit

protocol TextEntryDelegate: class {
    func didUpdateField(_ text: String, _ cardDetailCellType: CardDetailSectionCellType?, _ addressCellType: AddressSectionCellType?)
}

class CreditCardDetailsTextEntryCell: UITableViewCell {
    weak var delegate: TextEntryDelegate?
    
    var cardDetailCellType: CardDetailSectionCellType? = nil
    var addressCellType: AddressSectionCellType? = nil

    let picker = UIPickerView()
    let statesNames = ["Select State", "Alabama", "California", "Delaware", "Florida", "Georgia", "Hawaii", "Illinois", "Kentucky", "Louisiana", "Minnesota", "New York", "Oklahoma", "Puerto Rico", "Rhode Island", "South Carolina", "Texas", "Utah", "Virginia", "Washington"]
    
    let months = ["Month","01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    let years = ["Year","18", "19", "20", "21", "22", "23"]
    
    var completeDate = ""
    
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate =  self
            picker.delegate = self
            picker.dataSource = self
        }
    }
}

extension CreditCardDetailsTextEntryCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        let expectedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        delegate?.didUpdateField(expectedText, cardDetailCellType, addressCellType)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreditCardDetailsTextEntryCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if cardDetailCellType == CardDetailSectionCellType.expirationDate  {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if cardDetailCellType == CardDetailSectionCellType.expirationDate  {
            if component == 1 {
                return years.count
            }else {
                return months.count
            }
        }
        return statesNames.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if cardDetailCellType == CardDetailSectionCellType.expirationDate  {
            if component == 1 {
                return years[row]
            }else {
                return months[row]
            }
        }
        return statesNames[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if cardDetailCellType == CardDetailSectionCellType.expirationDate  {
            if component == 0 {
                if row == 0 {
                    return
                }
                completeDate  = "\(months[row])"
            }
            if component == 1 {
                if row == 0 {
                    return
                }
                if completeDate.count < 2 || completeDate.count >= 5{
                    completeDate = months[1]
                }
                self.textField.text = "\(completeDate)/\(years[row])"
                completeDate  = "\(completeDate)/\(years[row])"
                endEditing(true)
            }
            delegate?.didUpdateField(completeDate, cardDetailCellType, addressCellType)
        } else {
            if row == 0 {
                return
            }
            self.textField.text = statesNames[row]
            delegate?.didUpdateField(statesNames[row], cardDetailCellType, addressCellType)
            endEditing(true)
        }
    }
}
