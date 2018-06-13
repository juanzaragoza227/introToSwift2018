//
//  FavoritesCell.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/29/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit
class FavoritesCell: UITableViewCell {
    @IBOutlet weak var stationName: UILabel! {
        didSet {
            stationName.cellTitleLabelConfiguration()
        }
    }
    @IBOutlet weak var stationDetails: UILabel!{
        didSet {
            stationDetails.cellSubtitleLabelConfiguration()
        }
    }
    @IBOutlet weak var stationColorIdentifierIfActive: UIView!
}


