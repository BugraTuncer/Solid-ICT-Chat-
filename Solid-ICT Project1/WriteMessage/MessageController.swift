//
//  MessageController.swift
//  Solid-ICT Project1
//
//  Created by Buğra Tunçer on 15.08.2019.
//  Copyright © 2019 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var toEmailText: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageText: UITextView!
    let placeHolder = "Create an e-mail"
    let start = NSRange(location: 0, length: 0)
    var users = [User]()
    override func viewDidLoad() {
        titleLabel.text = "Hey,Send Messsage"
        messageText.delegate=self
        messageText!.layer.borderWidth = 1
        messageText.layer.borderColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0).cgColor
        
        messageText.layer.cornerRadius = 5
        messageText.textColor = UIColor.lightGray
        messageText.font = UIFont(name: "System", size: 17.0)
        messageText.returnKeyType = .done
        messageText.text = placeHolder
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        getUsers()
        super.viewDidLoad()
        
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = textView.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame
    }
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendClicked(_ sender: Any) {
        if validateEmail(candidate: toEmailText.text!) && toEmailText.text != ""{
           
            if(isUserInDatabase(email: toEmailText.text!)){
                if messageText.text == "Create an e-mail" {
                    messageText.text = ""
                }
                let fixedString = toEmailText.text?.replacingOccurrences(of: ".", with: ",") ?? ""
                let messagesDB = Database.database().reference().child(fixedString.lowercased()).child("Messages")
                let key = messagesDB.childByAutoId().key
                let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                         "MessageBody": messageText.text!,"Key" : key]
                messagesDB.child(key!).setValue(messageDictionary) {
                    (error, reference) in
                    
                    if error != nil {
                        print(error!)
                    }
                    else {
                        print("Message saved successfully!")
                    }
                }
                let myViewController = ChatMenuController(nibName: "ChatMenuController", bundle: nil)
                self.present(myViewController, animated: true, completion: nil)
            }else{
                makeAlert(title: "User not found",message: "Try Again")
            }
        }            
        else{
            makeAlert(title: "Invalid e-mail",message: "Try Again")
        }
    }
    func isUserInDatabase(email : String ) -> Bool{
        for user in users {
            if(user.email.lowercased()==email.lowercased()){
                return true
            }
        }
        return false
    }
    // PlaceHolder (TextView)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageText.text == "Create an e-mail" {
            messageText.text = ""
            messageText.textColor = UIColor.black
            messageText.font = UIFont(name: "System", size: 17.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            messageText.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageText.text == "" {
            messageText.text = "Create an e-mail"
            messageText.textColor = UIColor.lightGray
            messageText.font = UIFont(name: "System", size: 17.0)
        }
    }
    func makeAlert(title : String , message : String)
    {
        let alert=UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
    
    func getUsers()
    {
        let DB=Database.database().reference().child("Users")
        DB.observe(.childAdded) { (snapshot) in
            let user = User()
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            user.email = snapshotValue["email"]!
            user.uid = snapshotValue["uid"]!
            self.users.append(user)
        }
    }
}


