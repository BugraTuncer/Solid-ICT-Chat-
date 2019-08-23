//
//  LoginController.swift
//  Solid-ICT Project1
//
//  Created by Buğra Tunçer on 8.08.2019.
//  Copyright © 2019 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class LoginController: UIViewController {

    @IBOutlet weak var passwordLabelBottom: UILabel!
    @IBOutlet weak var emailLabelBottom: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        super.viewDidLoad()
        titleLabel.text = "Glad to see you!"
        self.emailText.text = "bugra@tuncer.com"
        self.passwordText.text = "123456"
        passwordLabelBottom.adjustsFontSizeToFitWidth = true
        emailLabelBottom.adjustsFontSizeToFitWidth = true
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      view.addGestureRecognizer(tap)
    }
   @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }

    @IBAction func loginClicked(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        Auth.auth().signIn(withEmail: emailText.text!.lowercased(), password: passwordText.text!) { (data, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
            } else {
                self.emailText.text = ""
                self.passwordText.text = ""
                let myViewController = ChatMenuController(nibName: "ChatMenuController", bundle: nil)
                self.present(myViewController, animated: true, completion: nil)
                SVProgressHUD.dismiss()
                
            }
            
        }
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!.lowercased(), completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    @IBAction func registerClicked(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailText.text!.lowercased(), password: passwordText.text!) { (data, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
            } else {
               
               let DB = Database.database().reference().child("Users").child((data?.user.uid)!)
                let messageDictionary = ["email": data?.user.email,
                                         "uid": data?.user.uid]
                DB.setValue(messageDictionary)
                self.makeAlert(titleInput: "Register Succesfully,Please login.", messageInput: "Succesfully")
            }
        }
        self.emailText.text = ""
        self.passwordText.text = ""
      
    }
    @IBAction func backClicked(_ sender: Any) {
        let myViewController = OnBoardViewController(nibName: "OnBoardViewController", bundle: nil)
        self.present(myViewController, animated: true, completion: nil)
    }
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    

}

//extension UITextField {
//    func setPadding() {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
//        self.leftView = paddingView
//        self.leftViewMode = .always
//    }
//    func setBorderBottom() {
//        self.layer.shadowColor =  UIColor.red.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius  = 0.0
//    }
//}
