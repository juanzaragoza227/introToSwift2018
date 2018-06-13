//
//  UIViewControllersExtensions.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 6/12/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureNavController(rightButtonTitle: String? = nil, leftButtonTitle: String? = nil, centerTitle: String? = nil) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem?.tintColor = .myRed
        navigationController?.navigationBar.barTintColor = .myBlue        
        navigationItem.title = centerTitle
    }
    
    func configureTabBar(){
        tabBarController?.tabBar.barTintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor.myBlue
    }
}
