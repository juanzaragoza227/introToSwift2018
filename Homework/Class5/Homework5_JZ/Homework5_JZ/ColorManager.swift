//
//  ColorManager.swift
//  Homework5_JZ
//
//  Created by Juan Zaragoza on 4/15/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

struct ColorManager {
    static let maxRGBValue: UInt32 = 255
    static let maxRGBFloatValue: CGFloat = CGFloat(maxRGBValue)
    static var randomRGBValue: CGFloat {
        get {
            return CGFloat(arc4random_uniform(maxRGBValue) + 1)
        }
    }
}

extension ColorManager {
    
    static func generateColors(desired numberOfColors: Int, segmentSelected: Int) -> [ColorViewModel] {
        
        var randomRedValues: [CGFloat] = []
        var randomBlueValues: [CGFloat] = []
        var randomGreenValues: [CGFloat] = []
        
        var myColors: [ColorViewModel] = []
        var color: UIColor
        var colorName: String
        
        for position in 0..<numberOfColors {
            
            randomRedValues.append(self.randomRGBValue)
            randomBlueValues.append(self.randomRGBValue)
            randomGreenValues.append(self.randomRGBValue)
            
            let redValue = randomRedValues[position]
            let blueValue = randomBlueValues[position]
            let greenValue = randomGreenValues[position]
            
            switch  segmentSelected {
                case 0:
                    color = self.color( redValue, 0, 0)
                    colorName =  self.colorName(redValue, 0, 0)
                case 1:
                    color = self.color( 0, 0, blueValue)
                    colorName =  self.colorName(0, 0, blueValue)
                default:
                    color = self.color( redValue, greenValue, blueValue)
                    colorName =  self.colorName(redValue, redValue, blueValue)
            }
        
            let colorViewModel = ColorViewModel.init(name: colorName, color: color, isSelected: false)
            myColors.append(colorViewModel)
        }
        return myColors
    }
    
    private static func colorName(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> String {
        return String(format: "R: %.0f, G: %.0f, B: %.0f, A: %.0f", red, green, blue, 1)
    }
    
    private static func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/maxRGBFloatValue, green: green/maxRGBFloatValue, blue: blue/maxRGBFloatValue, alpha: 1)
    }
}
