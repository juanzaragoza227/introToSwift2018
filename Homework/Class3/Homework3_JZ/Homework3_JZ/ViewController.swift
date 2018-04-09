//
//  ViewController.swift
//  Homework3_JZ
//
//  Created by Juan Zaragoza on 4/8/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //declaring some variables and ui objects
    var messages: [Message] = []
    @IBOutlet var messageButtons: [UIButton]!
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    //outlets for the animations
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var messageFromLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLabels(true)
        configureNavigationBar()
        loadMessages()
        configureButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //storing initial positions set in the story board by the constrains this posiotions are dinamic depending on the screen size
        let buttonsStackViewInitialPosition = buttonsStackView.frame.origin.y
        let messageFromLabelInitialPosition = messageFromLabel.frame.origin.y
        //seting the views to outside bounds of y axis
        self.buttonsStackView.frame.origin.y = view.bounds.height
        self.messageFromLabel.frame.origin.y = view.bounds.height
        //animation the vew back to their original positions
        UIView.animate(withDuration: 1, animations: {
            self.buttonsStackView.frame.origin.y -= self.view.bounds.height - buttonsStackViewInitialPosition
            self.messageFromLabel.frame.origin.y -= self.view.bounds.height - messageFromLabelInitialPosition
        }, completion: nil)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Messages"
        //refresh button settings
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .darkGray
        //edit button settings
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func refreshButtonPressed(){
        hideLabels(true)
    }
    @objc private func editButtonPressed(){}
    
    private func loadMessages(){
        //filling up array
        messages = Message.defaultData
    }
    
    private func configureButtons(){
        for button in messageButtons{
            let index = button.tag - 1
            let message = messages[index]
            button.setTitle(message.fromName, for: .normal)
        }
    }
    
    @IBAction func messageButtonPressed(_ sender: UIButton) {
        let index = sender.tag - 1
        let message = messages[index]
        //filling ui labels
        fromNameLabel.text = message.fromName
        bodyLabel.text = message.body
        stateLabel.text = "State: \(message.state.txt)"
        //showing labels
        hideLabels(false)
    }
    //hide labels at viewdidload and show labels when a button is pressed
    private func hideLabels(_ hide: Bool){
        fromNameLabel.isHidden = hide
        bodyLabel.isHidden = hide
        stateLabel.isHidden = hide
    }
}
