//
//  CreateAccount.swift
//  iPlay Stream
//
//  Created by Buliga Alexandru on 20.03.2021.
//

import Foundation
import  UIKit
import FirebaseAuth

class CreateAccountController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelStack: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    var handle = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabelStack.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle.addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    
    
    
    
    
    
    @IBAction func createAccount(_ sender: Any) {
        
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passField.text!) { authResult, error in
            
            
            if let errorCode = error{
                self.handeAuthErros(errorcode: AuthErrorCode(rawValue: errorCode._code)!)
            }
            else{
                self.performSegue(withIdentifier: "ButtomBar2", sender: nil)
            }
            
        }
    }
    
    
    
    func handeAuthErros(errorcode: AuthErrorCode){
        errorLabelStack.isHidden = false
        
        
        
        print(errorcode)
        
        switch errorcode{
        
        case .invalidEmail:
            print("Invalid email")
            errorLabel.text = "Invalid email"
            break
            
        case .emailAlreadyInUse:
            errorLabel.text = "Email already in use"
            break
            
        case .weakPassword:
            errorLabel.text = "Password is weak."
            break
            
        default:
            print("Error")
            
        }
    }
    
}

