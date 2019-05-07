//
//  AccountViewController.swift
//  SafePass_HackGT
//
//  Created by Jacob Lattie on 5/5/19.
//  Copyright © 2019 Jacob Lattie. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

class AccountViewController: UIViewController {

    var accounts: [NSManagedObject] = []
    var account: NSManagedObject? = nil
    var hidden = true
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidden = true
//        print(account?.value(forKey: "accountName"))
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    private func configureUI() {
        let accountName = account?.value(forKey: "accountName")
        let userID = account?.value(forKey: "userID")
        let password = account?.value(forKey: "password")
        accountLabel.text = accountName as? String
        if hidden == true {
            userIDLabel.text = "-------"
            passwordLabel.text = "-------"
        } else {
            userIDLabel.text = userID as? String
            passwordLabel.text = password as? String
        }
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        if self.hidden == true {
                            let userID = self.account?.value(forKey: "userID")
                            let password = self.account?.value(forKey: "password")
                            self.userIDLabel.text = userID as? String
                            self.passwordLabel.text = password as? String
                            self.hidden = false
                        } else {
                            self.hidden = true
                            self.userIDLabel.text = "-------"
                            self.passwordLabel.text = "-------"
                        }
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Try Again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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
