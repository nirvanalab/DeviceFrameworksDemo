//
//  ContactsViewController.swift
//  AllInOneDemo
//
//  Created by Nirvana on 10/8/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class CPDemoContactsViewController: UIViewController {
    
    var friendsList = Friend.defaultContacts()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contactBtn = UIBarButtonItem(title: "Contacts", style: .plain, target: self, action: #selector(presentContacts(_:)))
        self.navigationItem.rightBarButtonItem = contactBtn
    }
    
    
    @IBAction func presentContacts(_ sender: UIBarButtonItem) {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact =
            NSPredicate(format: "emailAddresses.@count > 0")
        present(contactPicker, animated: true,
                completion: nil)
        
    }
    
    func presentPermissionErrorAlert() {
        DispatchQueue.main.async() {
            let alert =
                UIAlertController(title: "Could Not Save Contact",
                                  message: "How am I supposed to add the contact if " +
                    "you didn't give me permission?",
                                  preferredStyle: .alert)
            let openSettingsAction = UIAlertAction(title: "Settings",
                                                   style: .default, handler: { alert in
                                                    
                                                    UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options:[:], completionHandler: nil)
            })
            let dismissAction = UIAlertAction(title: "OK",
                                              style: .cancel, handler: nil)
            alert.addAction(openSettingsAction)
            alert.addAction(dismissAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }
    
    func saveFriendToContacts(friend: Friend) {
        
        // Create CNMutableContact
        let contact = friend.contactValue.mutableCopy()
            as! CNMutableContact
        // Create save request
        let saveRequest = CNSaveRequest()
        // add contact to request
        saveRequest.add(contact,
                        toContainerWithIdentifier: nil)
        do {
            // Execute request from the contact store
            let contactStore = CNContactStore()
            try contactStore.execute(saveRequest)
            DispatchQueue.main.async {
                let successAlert = UIAlertController(title: "Contacts Saved",
                                                     message: nil, preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK",
                                                     style: .cancel, handler: nil))
                self.present(successAlert, animated: true,     completion: nil)
            }
            
        } catch {
            DispatchQueue.main.async {
                let failureAlert = UIAlertController(
                    title: "Could Not Save Contact",
                    message: "An unknown error occurred.",
                    preferredStyle: .alert)
                failureAlert.addAction(UIAlertAction(title: "OK",
                                                     style: .cancel, handler: nil))
                self.present(failureAlert, animated: true,
                             completion: nil)
            }
            
        }
        
    }
    
}

//MARK: UITableViewDataSource
extension CPDemoContactsViewController: UITableViewDelegate,UITableViewDataSource, CNContactPickerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for:indexPath as IndexPath)
        
        if let cell = cell as? ContactCell {
            let friend = friendsList[indexPath.row]
            cell.friend = friend
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let createContact = UITableViewRowAction(style: .normal,
                                                 title: "Create Contact") { rowAction, indexPath in
                                                    tableView.setEditing(false, animated: true)
                                                    // Add the contact
                                                    //check for permissions
                                                    let contactStore = CNContactStore()
                                                    DispatchQueue.main.async {
                                                        contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (userGrantedAccess, _) in
                                                            guard userGrantedAccess else {
                                                                self.presentPermissionErrorAlert()
                                                                return
                                                            }
                                                            //add contact
                                                            let friend = self.friendsList[indexPath.row]
                                                            self.saveFriendToContacts(friend: friend)
                                                        })
                                                    }
                                                    
                                                    
                                                    
        }
        createContact.backgroundColor = UIColor.blue
        return [createContact]
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsList[indexPath.row]
        let contact = friend.contactValue
        // Instantiate CNContactViewController;thisisfromtheContactsUIframeworkand displays a contact onscreen.
        let contactViewController =
            CNContactViewController(forUnknownContact: contact)
        contactViewController.navigationItem.title = "Profile"
        contactViewController.hidesBottomBarWhenPushed = true
        // Make it only viewable
        contactViewController.allowsEditing = true
        contactViewController.allowsActions = true
        navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        //Do something
        print (contact)
    }
    
    
}
