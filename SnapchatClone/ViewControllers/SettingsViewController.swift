//
//  SettingsViewController.swift
//  SnapchatClone
//
//  Created by Burak AKCAN on 25.06.2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func logOutClick(_ sender: UIButton) {
        do{
           try Auth.auth().signOut()
            self.performSegue(withIdentifier: "fromSettingsToHome", sender: nil)
        }catch{
            print(error)
        }
        
    }
    
}
