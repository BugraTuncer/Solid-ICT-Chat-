//
//  TableViewController.swift
//  Solid-ICT Project1
//
//  Created by Buğra Tunçer on 8.08.2019.
//  Copyright © 2019 Buğra Tunçer. All rights reserved.
//
import UIKit
import Firebase
import SwipeCellKit
class ChatMenuController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,SwipeTableViewCellDelegate {
    @IBOutlet weak var messageTableView: UITableView!
    var searchController = UISearchController()
    var resultsConroller = UITableViewController()
    var messageArray = [Message]()
    var filteredArray = [Message]()
    var messageLabelCellWidth = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        messageTableView.separatorStyle = .none
        messageTableView.delegate=self
        messageTableView.dataSource=self
        searchController = UISearchController(searchResultsController: resultsConroller)
        messageTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.backgroundColor = .blue
        searchController.searchBar.barTintColor = UIColor(red: 80, green: 147, blue: 255, alpha: 0)
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        resultsConroller.tableView.delegate = self
        resultsConroller.tableView.dataSource = self
        searchController.searchBar.placeholder = "Search by e-mail"
    }
    // Search Button Function
    func updateSearchResults(for searchController: UISearchController) {
        filteredArray = messageArray.filter({ (Message) -> Bool in
            if Message.sender.lowercased().contains(searchController.searchBar.text!.lowercased()) {
                return true
            } else {
                return false
            }
        })
        resultsConroller.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveMessages()
    }
    // Table View Methods
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = messageArray[indexPath.row].messageBody.size(withAttributes:[.font: UIFont.systemFont(ofSize:17.0)])
    print("size",size)
    if messageArray[indexPath.row].isExpand == true && size.width > messageLabelCellWidth {
        return UITableView.automaticDimension
    }
    return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if messageArray[indexPath.row].isExpand {
            messageArray[indexPath.row].isExpand = false
        } else {
            messageArray[indexPath.row].isExpand = true
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultsConroller.tableView {
            return filteredArray.count
        } else {
            return messageArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! MessageCell
            cell.delegate=self
            messageLabelCellWidth = cell.messageLabel.frame.width
        if tableView == resultsConroller.tableView {
            cell.messageLabel.text = filteredArray[indexPath.row].messageBody
            cell.senderLabel.text = filteredArray[indexPath.row].sender
            cell.avatarImage.image = UIImage(named: "egg")
        } else {
            cell.messageLabel.text = messageArray[indexPath.row].messageBody
            cell.senderLabel.text = messageArray[indexPath.row].sender
            cell.avatarImage.image = UIImage(named: "egg")
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            let message=self.messageArray[indexPath.row]
            let fixedString = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: ",")
            let messageDB = Database.database().reference().child(fixedString!).child("Messages").child(message.key)
            messageDB.removeValue { (error, DatabaseReference) in
                if error != nil {
                    print("Remove unsuccesfully",error!)
                }else {
                    self.messageArray.remove(at: indexPath.row)
                    self.messageTableView.reloadData()
                }
            }
        }
        
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    func visibleRect(for tableView: UITableView) -> CGRect? {
        return tableView.safeAreaLayoutGuide.layoutFrame
    }

    // Button's Methods
    //    @IBAction func menuButtonClicked(_ sender: Any) {
    //        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseIn, animations: {
    //            if  !self.menuisVisible {
    //                self.leadingC.constant = 200
    //                //self.trailingC.constant = -100
    //                self.menuisVisible = true
    //            } else {
    //                self.leadingC.constant = 0
    //                self.trailingC.constant = 0
    //                self.menuisVisible = false
    //            }
    //            self.view.layoutIfNeeded()
    //        })
    //    }
    // Button Function's
    @IBAction func logOutClicked(_ sender: Any) {
        let alert=UIAlertController(title: "Log Out", message: "Are you sure you want to quit?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            let myViewController = LoginController(nibName: "LoginController", bundle: nil)
            self.present(myViewController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func messageClicked(_ sender: Any) {
        let myViewController = MessageController(nibName: "MessageController", bundle: nil)
        self.present(myViewController, animated: true, completion: nil)
        messageArray.removeAll()
    }
    // Firebase getMessages
    func retrieveMessages()
    {
        let fixedString = Auth.auth().currentUser?.email?.lowercased().replacingOccurrences(of: ".", with: ",")
        let messageDB = Database.database().reference().child(fixedString!).child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let key = snapshotValue["Key"]!
            let message = Message()
            message.messageBody = text as String
            message.sender = sender as String
            message.key = key as String
            self.messageArray.append(message)
            self.messageTableView.reloadData()
            
        }
    }
}

