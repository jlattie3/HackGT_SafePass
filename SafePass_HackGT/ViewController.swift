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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
        //1
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
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
            [unowned self] action in
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
            self.save(name: nameToSave, id: idToSave, pswd: passToSave)
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
    
    func save(name: String, id: String, pswd: String) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("tapped here")
        if let accountVC = segue.destination as? AccountViewController { // 1
            // Show existing note
            if let selectedCell = sender as? UITableViewCell,
                let selectedIndex = tableView.indexPath(for: selectedCell) { // 2
//                noteVC.note = self.noteDatabase.note(atIndex: selectedIndex.row) // 3
                if let accountLabelText = selectedCell.textLabel?.text {
                    print(accountLabelText)
                    accountVC.account = accounts[selectedIndex.row]
//                    accountVC.accountLabel?.text = accountLabelText
//                    print(accountVC.accountLabel?.text ?? "ERROR")
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = account.value(forKeyPath: "accountName") as? String
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Segue to the second view controller
//        print("tapped")
//        self.performSegue(withIdentifier: "accountViewSegue", sender: self)
//    }
}
