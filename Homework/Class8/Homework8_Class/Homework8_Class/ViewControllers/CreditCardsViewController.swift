//
//  CreditCardsViewController.swift
//  Homework8_KL
//
//  Created by Kevin Lopez on 5/1/18.
//  Copyright © 2018 io.ricoLabs. All rights reserved.
//

import UIKit

class CreditCardsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var creditCards = [CreditCard]()
    var indexOfeditedCard = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Credit Cards"
        tableView.dataSource = self
        tableView.delegate = self
        loadCreditCards()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCreditCardButtonPressed))
    }
    
    @objc private func addNewCreditCardButtonPressed() {
        if let newCreditCard = self.storyboard?.instantiateViewController(withIdentifier: "newCreditCard") as? CreditCardDetailsViewController {
            newCreditCard.newCreditCard = CreditCard()
            newCreditCard.delegate = self
            navigationController?.pushViewController(newCreditCard, animated: true)
        }
    }
}

extension CreditCardsViewController: AddCreditCardDelegate {
    func didPressSaveButton(didFinishAdding creditCard: CreditCard) {
        navigationController?.popViewController(animated: true)
        creditCards.append(creditCard)
        tableView.reloadData()
        saveCreditCards()
    }
    
    func didPressSaveButton(didFinishEditing creditCard: CreditCard) {
        navigationController?.popViewController(animated:true)
        creditCards[indexOfeditedCard] = creditCard
        tableView.reloadData()
        saveCreditCards()
    }
}

extension CreditCardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditCardSummary", for: indexPath) as! CreditCardSummaryCell
        let creditCard = creditCards[indexPath.row]
        cell.configureWith(creditCard)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension CreditCardsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let creditCard = creditCards[indexPath.row]
        indexOfeditedCard = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        if let editCreditCard = self.storyboard?.instantiateViewController(withIdentifier: "newCreditCard") as? CreditCardDetailsViewController {
            editCreditCard.cardToEdit = creditCard
            editCreditCard.delegate = self
            navigationController?.pushViewController(editCreditCard, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            creditCards.remove(at: indexPath.row)
            tableView.reloadData()
            saveCreditCards()
        }
    }
}

extension CreditCardsViewController {
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Homework8.plist")
    }
    
    func saveCreditCards() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(creditCards)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding creditCards array!")
        }
    }
    
    func loadCreditCards() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                creditCards = try decoder.decode([CreditCard].self, from: data)
            } catch {
                print("Error decoding creditCards array!")
            }
        }
    }
}
