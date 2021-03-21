//
//  LoginController.swift
//  iPlay Stream
//
//  Created by Buliga Alexandru on 18.03.2021.
//

import Foundation
import  UIKit
import FirebaseAuth

class LoginController: UIViewController {
    @IBOutlet weak var errorLabelStack: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    var userAutoLogin: Bool = false
    var handle = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let getUser = UserDefaults.self
        let userEmail = getUser.standard.string(forKey: "email")
        let userPass = getUser.standard.string(forKey: "password")
        userAutoLogin = getUser.standard.bool(forKey: "autologin")
        errorLabelStack.isHidden = true
        
        print("user: \(String(describing: userPass))")
        if(userEmail != nil && userPass != nil){
            print("autologin")
            logIn(email: userEmail!, psw: userPass!)
        }
        else {print("don't have autologin")}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle.addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    
    @IBAction func sigIn(_ sender: Any) {
        
        logIn(email: emailField.text!, psw:passField.text!)
        
    }
    
    
    
    
    
    @IBAction func createAccount(_ sender: Any) {
        
        self.performSegue(withIdentifier: "createAccountSegue", sender: nil)
    }
    
    
    func logIn(email: String, psw: String){
        Auth.auth().signIn(withEmail: email, password: psw ,completion: { (user, error) in
            
            if error == nil && self.userAutoLogin == false{
                
                let User = UserDefaults.standard
                User.set(self.emailField.text!, forKey: "email")
                User.set(self.passField.text!, forKey: "password")
                User.set(true, forKey: "autologin")
                User.synchronize()
                
                self.performSegue(withIdentifier: "ButtomBar", sender: nil)
                
                
            }
            else if error == nil && self.userAutoLogin == true{
                self.performSegue(withIdentifier: "ButtomBar", sender: nil)
            }
            
            else{
                self.errorLabelStack.isHidden = false
                
                let typeError = AuthErrorCode(rawValue: error!._code)!
                switch typeError {
                case .userNotFound:
                    print("User not found")
                    self.errorLabel.text = "User not found"
                    break
                case .wrongPassword:
                    print("Wrong password")
                    self.errorLabel.text = "Wrong password"
                    break
                    
                case .userDisabled:
                    print("User is disabled")
                    self.errorLabel.text = "User is disabled"
                    break
                    
                default:
                    break
                    
                }
            }
        })
        
    }
}

