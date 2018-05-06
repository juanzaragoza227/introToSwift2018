//
//  AddCreditCardViewController.swift
//  Homework8_KL
//
//  Created by Kevin Lopez on 5/1/18.
//  Copyright © 2018 io.ricoLabs. All rights reserved.
//

import UIKit

protocol AddCreditCardDelegate: class {
    func didPressSaveButton(didFinishAdding creditCard: CreditCard)
    func didPressSaveButton(didFinishEditing creditCard: CreditCard)
}

class CreditCardDetailsViewController: UIViewController {
    
    var newCreditCard = CreditCard()
    weak var delegate: AddCreditCardDelegate?
    var cardToEdit: CreditCard?
    
    @IBOutlet weak var tableView: UITableView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cardToEdit != nil {
            title = "Edit Credit Card"
            navigationItem.rightBarButtonItem?.isEnabled = true

        }else {
            title = "Add Credit Card"
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
    }
    
    @objc private func saveButtonPressed() {
        if  cardToEdit != nil {
            self.delegate?.didPressSaveButton(didFinishEditing: newCreditCard)
        }else {
            self.delegate?.didPressSaveButton(didFinishAdding: newCreditCard)
        }
    }
    
    private func updateSaveButton() {
        let isCardFullyFilledOut = newCreditCard.areCardDetailsFilledOut && newCreditCard.address.isAdressFilledOut
        navigationItem.rightBarButtonItem?.isEnabled = isCardFullyFilledOut
    }
}
//MARK: Setting up rows per sectionand filling them
extension CreditCardDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = NewCreditCardSectionType(rawValue: section)!
        
        switch sectionType {
        case .cardDetails:
            return CardDetailSectionCellType.count
        case .address:
            return AddressSectionCellType.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = NewCreditCardSectionType(rawValue: indexPath.section)!
        
        switch sectionType {
        case .cardDetails:
            let cellType = CardDetailSectionCellType(rawValue: indexPath.row)!
            return cardDetailCellFor(cellType, indexPath)
    
        case .address:
            let cellType = AddressSectionCellType(rawValue: indexPath.row)!
            return addressCellFor(cellType, indexPath)
        }
    }
}
//MARK: Number of section, title for sections, dismiss action when scrolling
extension CreditCardDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NewCreditCardSectionType(rawValue: section)?.txt
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resignFirstResponder()
        self.view.endEditing(true)
    }
}
//MARK: Helper to fillup cells
extension CreditCardDetailsViewController {
    private func cardDetailCellFor(_ cellType: CardDetailSectionCellType, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textEntryCell", for: indexPath) as! CreditCardDetailsTextEntryCell
        cell.fieldName.text = cellType.txt
        cell.cardDetailCellType = cellType
        cell.delegate = self
        
        switch cellType {
        case .firstName:
            cell.textField.becomeFirstResponder()
            cell.textField.keyboardType = .default
            cell.textField.inputView = nil
            break
        case .cardNumber:
            cell.textField.keyboardType = .numberPad
            cell.textField.inputView = nil
            break
        case .expirationDate:
            cell.textField.inputView = cell.picker
            break
        case .securityCode:
            cell.textField.keyboardType = .numberPad
            cell.textField.isSecureTextEntry = true
            cell.textField.inputView = nil
            break
        default:
            cell.textField.inputView = nil
            cell.textField.keyboardType = .default
        }
        
        if let card = cardToEdit {
            setCardDetailsToEdit(cellType, cell, card)
        }
        
        return cell
    }
    
    private func addressCellFor(_ cellType: AddressSectionCellType, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textEntryCell", for: indexPath) as! CreditCardDetailsTextEntryCell
        cell.fieldName.text = cellType.txt
        cell.addressCellType = cellType
        cell.delegate = self
        
        switch cellType {
        case .state:
            cell.textField.inputView = cell.picker
            break
        case .zipCode:
            cell.textField.inputView = nil
            cell.textField.keyboardType = .numberPad
            break
        default:
            cell.textField.inputView = nil
            cell.textField.keyboardType = .default
        }
        
        if let card = cardToEdit {
            setAdressDetailsToEdit(cellType, cell, card)
        }
        
        return cell
    }
}
//MARK: Keyboard config
extension CreditCardDetailsViewController {
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
//MARK: Updating values while typing
extension CreditCardDetailsViewController: TextEntryDelegate {
    func didUpdateField(_ text: String, _ cardDetailCellType: CardDetailSectionCellType?, _ addressCellType: AddressSectionCellType?) {

        if let addressType = addressCellType {
           newCreditCard.address = newCreditCard.updateAddressDetail(addressType, text)
        }
        if let cardDetailType = cardDetailCellType {
            newCreditCard = newCreditCard.updateCardDetail(cardDetailType, text)
        }
        updateSaveButton()
    }
}
//MARK: Updating fields and model with card to edit info
extension CreditCardDetailsViewController {
    func setCardDetailsToEdit(_ cellType: CardDetailSectionCellType, _ cell: CreditCardDetailsTextEntryCell, _ card: CreditCard) {
        var text = ""
        switch cellType {
        case .firstName:
            cell.textField.text  = card.firstName
            text = card.firstName
            break
        case .lastName:
            cell.textField.text  = card.lastName
            text = card.lastName
            break
        case .cardNumber:
            cell.textField.text  = card.cardNumber
            text = card.cardNumber
            break
        case .expirationDate:
            cell.textField.text  = card.expirationDate
            text = card.expirationDate
            break
        case .securityCode:
            cell.textField.text  = card.securityCode
            text = card.securityCode
            break
        }
        newCreditCard = newCreditCard.updateCardDetail(cellType, text)

    }
    
    func setAdressDetailsToEdit(_ cellType: AddressSectionCellType, _ cell: CreditCardDetailsTextEntryCell, _ card: CreditCard) {
        var text = ""
        switch cellType {
        case .addressOne:
            cell.textField.text  = card.address.addressOne
            text = card.address.addressOne
            break
        case .addressTwo:
            cell.textField.text  = card.address.addressTwo
            text = card.address.addressTwo
            break
        case .cityTown:
            cell.textField.text  = card.address.cityTown
            text = card.address.cityTown
            break
        case .state:
            cell.textField.text  = card.address.state
            text = card.address.state
            break
        case .zipCode:
            cell.textField.text  = card.address.zipCode
            text = card.address.zipCode
            break
        }
        newCreditCard.address = newCreditCard.updateAddressDetail(cellType, text)
    }
}





















