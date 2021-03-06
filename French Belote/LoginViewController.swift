//
//  LoginViewController.swift
//  French Belote
//
//  Created by Stefan Auvergne on 12/5/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!

    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    
    let prefs = UserDefaults.standard
    var authHandle:UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        usernameTF.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        register.isHidden = true
        login.layer.cornerRadius = 10.0
        login.clipsToBounds = true
        login.layer.borderWidth = 1
        login.layer.borderColor = UIColor.black.cgColor
        
        register.layer.cornerRadius = 10.0
        register.clipsToBounds = true
        register.layer.borderWidth = 1
        register.layer.borderColor = UIColor.black.cgColor
        
        if self.prefs.object(forKey: "switch") as? Bool == true{
            rememberMeSwitch.setOn(true, animated: true)
            setAuthListener()
        }
        else {
            rememberMeSwitch.setOn(false, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAuthListener() {
        if authHandle != nil{
            return
        }
        authHandle = FIRAuth.auth()?.addStateDidChangeListener({auth, user in
                if user == nil {
                    print(auth)
                    return
                } else {
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
                    //called only for login
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc =   storyboard.instantiateViewController(withIdentifier: "roomsVC") as! RoomsViewController
                    self.present(vc, animated: true, completion: nil)
                }
            
        }) as? UInt
    }
    
    func dismissKeyboard(){
        usernameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        emailTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func keyboardWasShown(notification: NSNotification){
        //let info: NSDictionary  = notification.userInfo! as NSDictionary
        //let keyboardSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
        //let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        //scrollView.contentInset = contentInsets
        //scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        //Register btn
        if segmentedOutlet.selectedSegmentIndex == 1{
            usernameTF.isHidden = true
            login.isHidden = true
            register.isHidden = false
        }
        if segmentedOutlet.selectedSegmentIndex == 0{
            usernameTF.isHidden = false
            register.isHidden = true
            login.isHidden = false
        }
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
            FIRAuth.auth()?.signIn(withEmail: emailTF.text!, password: passwordTF.text!, completion:{(success) in
                self.prefs.set(self.emailTF.text, forKey: "email")
            self.prefs.set(self.passwordTF.text, forKey:"password")
            self.prefs.set(self.rememberMeSwitch.isOn, forKey:"switch")
                self.setAuthListener()
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
        
        let roomsVC:RoomsViewController = segue.destination as! RoomsViewController
        roomsVC.setUsername(username: usernameTF.text!)
        

        
    }

}
