//
//  ViewController.swift
//  SafePass_HackGT
//
//  Created by Jacob Lattie on 5/3/19.
//  Copyright © 2019 Jacob Lattie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var accounts: [NSManagedObject] = []
    
    private var identifierFactory = 0
    
    private func getIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Safe Pass"
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        do {
            accounts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addAccount(_ sender: Any) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let accountNameField = alert.textFields?[0],
                let nameToSave = accountNameField.text else {
                    return
            }
            guard let userIDField = alert.textFields?[1],
                let idToSave = userIDField.text else {
                    return
            }
            guard let passwordField = alert.textFields?[2],
                let passToSave = passwordField.text else {
                    return
            }
            print(nameToSave, idToSave, passToSave)
            let uniqueID = self.getIdentifier()
            self.save(uniqueAccountID: uniqueID, name: nameToSave, id: idToSave, pswd: passToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(uniqueAccountID: Int, name: String, id: String, pswd: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Account", in: managedContext)!
        let account = NSManagedObject(entity: entity, insertInto: managedContext)
        account.setValue(name, forKeyPath: "accountName")
        account.setValue(id, forKeyPath: "userID")
        account.setValue(pswd, forKeyPath: "password")
        do {
            try managedContext.save()
            accounts.append(account)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAlert(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Warning",
                                      message: "Delete Account Data?",
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action:UIAlertAction) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            print("Established Delegate")
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(self.accounts[indexPath.row])
            self.accounts.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("tapped here")
        if let accountVC = segue.destination as? AccountViewController {
            if let selectedCell = sender as? UITableViewCell,
                let selectedIndex = tableView.indexPath(for: selectedCell) {
                if let accountLabelText = selectedCell.textLabel?.text {
                    print(accountLabelText)
                    accountVC.account = accounts[selectedIndex.row]
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = account.value(forKeyPath: "accountName") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            print("Delete Cell")
            print(indexPath.row)
            self.deleteAlert(indexPath)
        }
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
