//
//  Friend.swift
//  AllInOneDemo
//
//  Created by Nirvana on 10/8/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit
import Contacts
//
//func ==(lhs: Friend, rhs: Friend) -> Bool{
//    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.workEmail == rhs.workEmail && lhs.profilePicture == rhs.profilePicture
//}

struct Friend {
    let firstName: String
    let lastName: String
    var workEmail: String
    let profilePicture: UIImage?
    
    init(firstName: String, lastName: String, workEmail: String, profilePicture: UIImage?){
        self.firstName = firstName
        self.lastName = lastName
        self.workEmail = workEmail
        self.profilePicture = profilePicture
    }
    
    init(contact: CNContact){
        firstName = contact.givenName
        lastName = contact.familyName
        workEmail = contact.emailAddresses.first!.value as String
        if let imageData = contact.imageData{
            profilePicture = UIImage(data: imageData)
        } else {
            profilePicture = nil
        }
    }
    
    //default data
    static func defaultContacts() -> [Friend] {
        return [Friend(firstName: "Mickey", lastName: "Mouse", workEmail: "mickey@disney.com", profilePicture: UIImage(named: "MickeyMouse")), Friend(firstName: "Donald", lastName: "Duck", workEmail: "donald@disney.com", profilePicture: UIImage(named: "DonaldDuck")), Friend(firstName: "Kungfu", lastName: "Panda", workEmail: "kungfu@dreamworks.com", profilePicture: UIImage(named: "KungfuPanda")), Friend(firstName: "Dory", lastName: "Dory", workEmail: "dory@pixar.com", profilePicture: UIImage(named: "Dory"))]
    }
}

extension Friend {
    
    var contactValue: CNContact {
        // create an instance of CNMutableContact
        let contact = CNMutableContact()
        //set the name
        contact.givenName = firstName
        contact.familyName = lastName
        //set the email address as CNLabeledValue
        contact.emailAddresses = [CNLabeledValue.init(label: CNLabelWork, value: workEmail as NSString)]
        //set picture
        if let profilePicture = profilePicture {
            let imageData =
                UIImageJPEGRepresentation(profilePicture, 1)
            contact.imageData = imageData
        }
        //return immutable copy
        return contact.copy() as! CNContact
    }
}

