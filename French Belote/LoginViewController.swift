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
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!

    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener({auth, user in
            //check if remember me is true
            if self.prefs.object(forKey: "switch") as? Bool == true{
                if user != nil{
                    if let temp = self.prefs.object(forKey: "email") as? String{
                        self.emailTF.text = temp
                    }
                    if let temp = self.prefs.object(forKey: "password") as? String{
                        self.passwordTF.text = temp
                    }
                    if let temp = self.prefs.object(forKey: "switch") as? Bool{
                        self.rememberMeSwitch.isOn = temp
                    }
                }
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        if(usernameTF.text?.characters.count) == 0{
            print("Invalid Username")
            let alert = UIAlertController(title: "Invalid Username", message: "Please enter a username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if (passwordTF.text?.characters.count) == 0{
            print("Invalid Password")
            let alert = UIAlertController(title: "Invalid Password", message: "Please enter a password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if (emailTF.text?.characters.count)! == 0{
            print("Invalid Eamil")
            let alert = UIAlertController(title: "Invalid Email", message: "Please enter an email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
            prefs.set(emailTF.text, forKey: "email")
            prefs.set(passwordTF.text, forKey:"password")
            prefs.set(rememberMeSwitch.isOn, forKey:"switch")
            FIRAuth.auth()?.signIn(withEmail: emailTF.text!, password: passwordTF.text!, completion:{(success) in
                self.performSegue(withIdentifier: "segueGame", sender: self)
            })
        }
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        
        if emailTF.text == "" {
            let alertController = UIAlertController(title: "Invalid Email", message: "Please enter an email", preferredStyle: UIAlertControllerStyle.alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if passwordTF.text == "" {
            let alertController = UIAlertController(title: "Invalid Password", message: "Please enter a password", preferredStyle: UIAlertControllerStyle.alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            

        }else{
            
            FIRAuth.auth()?.createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    
                    let alertController = UIAlertController(title: "", message: "You are Registered!", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let gameVC:GameViewController = segue.destination as! GameViewController
        gameVC.setUsername(username: usernameTF.text!)
        
    }

}
