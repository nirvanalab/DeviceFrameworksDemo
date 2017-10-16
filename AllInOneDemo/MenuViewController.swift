//
//  ViewController.swift
//  AllInOneDemo
//
//  Created by Nirvana on 10/8/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit

enum MenuItems: Int {
    case Contact = 0
    case Notifications
    case Location
    case ImagePicker
    case Maps
    case Total
}

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

}

extension MenuViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return MenuItems.Total.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TopicCell")!
        switch indexPath.row  {
        case MenuItems.Contact.rawValue:
            cell.textLabel?.text = "Contacts & ContactsUI"
            break
        case MenuItems.Notifications.rawValue:
            cell.textLabel?.text = "Notifications"
            break
        case MenuItems.Location.rawValue:
            cell.textLabel?.text = "Location"
            break
        case MenuItems.ImagePicker.rawValue:
            cell.textLabel?.text = "Image Picker"
            break
        case MenuItems.Maps.rawValue:
            cell.textLabel?.text = "Maps"
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if ( indexPath.row == MenuItems.Contact.rawValue ) {
            let contactVC = storyboard.instantiateViewController(withIdentifier: "ContactsVC")
            self.navigationController?.pushViewController(contactVC, animated: true)
        }
        else if (indexPath.row == MenuItems.Notifications.rawValue ) {
            let notificationVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC")
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
        else if (indexPath.row == MenuItems.Location.rawValue ) {
            let locationVC = storyboard.instantiateViewController(withIdentifier: "LocationVC")
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
        else if (indexPath.row == MenuItems.ImagePicker.rawValue ) {
            let imagePickerVC = storyboard.instantiateViewController(withIdentifier: "ImagePickerVC")
            self.navigationController?.pushViewController(imagePickerVC, animated: true)
        }
        else if (indexPath.row == MenuItems.Maps.rawValue ) {
            let mapsVC = storyboard.instantiateViewController(withIdentifier: "MapVC")
            self.navigationController?.pushViewController(mapsVC, animated: true)
        }
    }
    
}
