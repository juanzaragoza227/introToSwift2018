//
//  CreditCardSummaryCell.swift
//  Homework8_KL
//
//  Created by Kevin Lopez on 5/1/18.
//  Copyright © 2018 io.ricoLabs. All rights reserved.
//

import UIKit

class CreditCardSummaryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardInfoLabel: UILabel!
    
    func configureWith(_ creditCardModel: CreditCard) {
        nameLabel.text = creditCardModel.firstName + " \(creditCardModel.lastName)"
        
        let creditCardLastFour =  creditCardModel.cardNumber.suffix(4)
        cardInfoLabel.text = "***\(creditCardLastFour)\(creditCardModel.securityCode), expires \(creditCardModel.expirationDate)"
    }
}
