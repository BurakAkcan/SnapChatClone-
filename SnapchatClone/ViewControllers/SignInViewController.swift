//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Burak AKCAN on 25.06.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usrNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureReco = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureReco)
    }

    @IBAction func signInClick(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else{ return custumAlert(title: "Error", message: "Please fill in all fields") }
        Auth.auth().signIn(withEmail: email, password: password) { auth, error in
            if error != nil{
                self.custumAlert(title: "Error", message: error?.localizedDescription ?? "unknown error")
            }else{
                self.performSegue(withIdentifier: "toTabbar", sender: nil)
            }
        }
        
    }
    
    @IBAction func signUpClick(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let username = usrNameTextField.text else{ return custumAlert(title: "Error", message: "Please fill in all fields") }
        Auth.auth().createUser(withEmail: email, password: password) { auth, error in
            if error != nil {
                self.custumAlert(title: "Error", message: error?.localizedDescription ?? "unknown error" )
            }else{
                //For save username
                let firestore = Firestore.firestore()
                let userDictionary = ["email":email,"username":username] as [String:Any]
                firestore.collection("UserInfo").addDocument(data: userDictionary) { error in
                    if error != nil {
                        print(error!)
                    }
                }
                
                
                self.performSegue(withIdentifier: "toTabbar", sender: nil)
            }
        }
    }
    
    
    func custumAlert(title:String,message:String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
        present(ac, animated: true)
    }
    
    
}

extension SignInViewController{
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}
