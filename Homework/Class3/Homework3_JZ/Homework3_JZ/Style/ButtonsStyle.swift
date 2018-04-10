//
//  ButtonsStyle.swift
//  Homework3_JZ
//
//  Created by Juan Zaragoza on 4/10/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

protocol ButtonStylesAttribute {
    //var cornerRadius: CGFloat { get }
    var backgroundColor: UIColor { get }
    var titleColor: UIColor { get }
    var titleSize: CGFloat { get }
}

struct StandarButton: ButtonStylesAttribute {
    //var cornerRadius: CGFloat = 5.0
    var backgroundColor: UIColor = .black
    var titleColor: UIColor = .white
    var titleSize: CGFloat = 11
}

struct ButtonStyle {
    static let standard = StandarButton()
    // static let highlited
}

extension UIButton {
    func apply(_ attribute: ButtonStylesAttribute, with title: String) {
        //self.layer.cornerRadius =  attribute.cornerRadius
        self.backgroundColor = attribute.backgroundColor
        self.setTitleColor(attribute.titleColor, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: attribute.titleSize)
    }
}
