//
//  LoginViewController.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/5/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
          
            if error == nil{
                print("worked")
                self.performSegue(withIdentifier: "segueGame", sender: self)
            }else{
                print("error")

            }
            
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        let email = emailTF.text
        let password = passwordTF.text
        
        
        FIRAuth.auth()?.createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
            
            
        }
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
