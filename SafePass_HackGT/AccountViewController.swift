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

class AccountViewController: UIViewController, UITextFieldDelegate {

    var accounts: [NSManagedObject] = []
    var account: NSManagedObject? = nil
    var copyTimer: Timer?
    var hidden = true
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var userIDText: UITextField!
    @IBOutlet weak var pswdText: UITextField!
    
    
    @objc func userIDTarget(textField: UITextField) {
        print("uID copied", userIDText.text)
        UIPasteboard.general.string = userIDText.text
        let alert = UIAlertController(title: "",
                                      message: "User ID copied to clipboard!",
                                      preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func pswdTarget(textField: UITextField) {
        print("pswd copied", pswdText.text)
        UIPasteboard.general.string = pswdText.text
        let alert = UIAlertController(title: "",
                                      message: "Password copied to clipboard!",
                                      preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidden = true
        // Do any additional setup after loading the view.
        userIDText.delegate = self
        userIDText.addTarget(self, action: #selector(userIDTarget), for: .touchDown)
        pswdText.delegate = self
        pswdText.addTarget(self, action: #selector(pswdTarget), for: .touchDown)

        configureUI()
    }
    
    private func configureUI() {
        let accountName = account?.value(forKey: "accountName")
        let userID = account?.value(forKey: "userID")
        let password = account?.value(forKey: "password")
        accountLabel.text = accountName as? String
        userIDText.text = userID as? String
        pswdText.text = password as? String
        userIDText.isUserInteractionEnabled = false
        userIDText.isSecureTextEntry = true
        userIDText.tintColor = .clear
        pswdText.isUserInteractionEnabled = false
        pswdText.isSecureTextEntry = true
        pswdText.tintColor = .clear
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
                            self.userIDText.isUserInteractionEnabled = true
                            self.pswdText.isUserInteractionEnabled = true
                            self.userIDText.isSecureTextEntry = false
                            self.pswdText.isSecureTextEntry = false
                            self.hidden = false
                        } else {
                            self.userIDText.isUserInteractionEnabled = false
                            self.pswdText.isUserInteractionEnabled = false
                            self.userIDText.isSecureTextEntry = true
                            self.pswdText.isSecureTextEntry = true
                            self.hidden = true
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
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


