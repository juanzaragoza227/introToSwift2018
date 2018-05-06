//
//  CrediCardDetailEnums.swift
//  Homework8_Class
//
//  Created by Juan Zaragoza on 5/6/18.
//  Copyright © 2018 io.ricoLabs. All rights reserved.
//

import UIKit

enum CardDetailSectionCellType: Int {
    case firstName
    case lastName
    case cardNumber
    case expirationDate
    case securityCode
    
    var txt: String {
        switch self {
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .cardNumber:
            return "Card Number"
        case .expirationDate:
            return "Expiration Date"
        case .securityCode:
            return "Security Code"
        }
    }
    
    static var count: Int {
        return CardDetailSectionCellType.securityCode.rawValue + 1
    }
}

enum AddressSectionCellType: Int {
    case addressOne
    case addressTwo
    case cityTown
    case state
    case zipCode
    
    var txt: String {
        switch self {
        case .addressOne:
            return "Address One"
        case .addressTwo:
            return "Address Two"
        case .cityTown:
            return "City Town"
        case .state:
            return "State"
        case .zipCode:
            return "Zip Code"
        }
    }
    
    static var count: Int {
        return AddressSectionCellType.zipCode.rawValue + 1
    }
}

enum NewCreditCardSectionType: Int {
    case cardDetails
    case address
    
    var txt: String {
        switch self {
        case .cardDetails:
            return "Card Details"
        case .address:
            return "Address"
        }
    }
}
