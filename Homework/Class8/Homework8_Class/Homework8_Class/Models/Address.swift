//
//  Address.swift
//  Homework8_KL
//
//  Created by Kevin Lopez on 5/1/18.
//  Copyright © 2018 io.ricoLabs. All rights reserved.
//

import Foundation

struct Address: Codable {
    var addressOne: String = ""
    var addressTwo: String = ""
    var cityTown: String = ""
    var state: String = ""
    var zipCode: String = ""
}

extension Address {
    var isAdressFilledOut: Bool {
        return !addressOne.isEmpty && !cityTown.isEmpty && !state.isEmpty && !zipCode.isEmpty
    }
}
