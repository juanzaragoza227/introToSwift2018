//
//  CustomCell.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/13/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit
class WeatherStationsCell: UITableViewCell {
    @IBOutlet weak var ItemNameLabel: UILabel! {
        didSet{
            ItemNameLabel.cellTitleLabelConfiguration()
        }
    }
    @IBOutlet weak var ItemDetailsLabel: UILabel! {
        didSet {
            ItemDetailsLabel.cellSubtitleLabelConfiguration()
        }
    }
    @IBOutlet weak var ItemColoredIdentificationView: UIView!
}
