//
//  UILabelExtension.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 6/13/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

extension UILabel {
    func cellTitleLabelConfiguration(){
        self.textColor = .black
        self.font = self.font.withSize(16)
    }
    
    func cellSubtitleLabelConfiguration(){
        self.textColor = .gray
        self.font = self.font.withSize(14)
    }
    
    func addLabelConfig(){
        self.textColor = .gray
        self.font = self.font.withSize(14)
    }
}
