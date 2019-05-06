//
//  AccountViewController.swift
//  SafePass_HackGT
//
//  Created by Jacob Lattie on 5/5/19.
//  Copyright © 2019 Jacob Lattie. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {

    var accounts: [NSManagedObject] = []
    var account: NSManagedObject? = nil
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(account?.value(forKey: "accountName"))
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    private func configureUI() {
        let accountName = account?.value(forKey: "accountName")
        let userID = account?.value(forKey: "userID")
        let password = account?.value(forKey: "password")
        print(accountName, userID, password)
        accountLabel.text = accountName as? String
        userIDLabel.text = userID as? String
        passwordLabel.text = password as? String
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
