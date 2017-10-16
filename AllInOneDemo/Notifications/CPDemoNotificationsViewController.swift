//
//  CPDemoNotificationsViewController.swift
//  AllInOneDemo
//
//  Created by Nirvana on 10/9/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit
import UserNotifications

class CPDemoNotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var notificatonTableContent = [(String,Bool)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notifyBtn = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsPressed))
        self.navigationItem.rightBarButtonItem = notifyBtn
        
        //request notifications permission
        // Authorization options - badge,alert,sound,carplay
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) {
                (granted, error) in
                if granted {
                    self.loadNotificationData()
                } else {
                    print(error?.localizedDescription ?? "Permission Denied")
                }
        }
    }
    
    
    
    private func loadNotificationData() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
           self.notificatonTableContent.removeAll()
    
            //The authorization status indicating the app’s ability to interact with the user.
            self.notificatonTableContent.append(("Authorization Status",settings.authorizationStatus == .authorized))
            
            //The setting that indicates whether your app’s notifications are displayed in Notification Center.
             self.notificatonTableContent.append(("Show in Notification Center",settings.notificationCenterSetting == .enabled))
            
            //The authorization status for playing sounds for incoming notifications.
            self.notificatonTableContent.append(("Sound Enabled?",settings.soundSetting == .enabled))
            
            //The authorization status for badging your app’s icon.
            self.notificatonTableContent.append(("Badges Enabled?",settings.badgeSetting == .enabled))
            
            //The authorization status for displaying alerts.
            self.notificatonTableContent.append(("Alerts Enabled?",settings.alertSetting == .enabled))
            
            //The setting that indicates whether your app’s notifications appear onscreen when the device is locked.
            self.notificatonTableContent.append(("Show on lock screen?",settings.lockScreenSetting == .enabled))
            
            //The setting that indicates whether your app’s notifications may be displayed in a CarPlay environment.
             self.notificatonTableContent.append(("Show in Car Play?",settings.carPlaySetting == .enabled))
            
            //The type of alert that the app may display when the device is unlocked.
            self.notificatonTableContent.append(("Alert banners?",settings.alertStyle == .banner))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchPendingNotifications() {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            self.notificatonTableContent.removeAll()
            for request in requests {
                var content = request.content.title
                if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    let triggerDate = trigger.nextTriggerDate()
                    let localDate = DateFormatter.localizedString(from: triggerDate!, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
                    content = "Scheduled: \(localDate) \(content)"
                }
                 self.notificatonTableContent.append((content,false))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDeliveredNotifications() {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            self.notificatonTableContent.removeAll()
            for notification in notifications {
                let localDate = DateFormatter.localizedString(from: notification.date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
                self.notificatonTableContent.append(("Delivered: \(localDate) \n \(notification.request.content.title)",false))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func clearNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    @objc func optionsPressed() {
        let alertC = UIAlertController(title: "Notification Options", message: "Please Choose", preferredStyle: .actionSheet)
        let triggerNotificationAction = UIAlertAction(title: "Trigger Notification", style: .default) { (_) in
            self.triggerNotification()
        }
        let pendingNotificationAction = UIAlertAction(title: "Pending Notifications", style: .default) { (_) in
            self.fetchPendingNotifications()
        }
        let deliveredNotificationAction = UIAlertAction(title: "Delivered Notifications", style: .default) { (_) in
            self.fetchDeliveredNotifications()
        }
        let clearNotificationAction = UIAlertAction(title: "Clear Delivered Notifications", style: .default) { (_) in
            self.clearNotifications()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        alertC.addAction(triggerNotificationAction)
        alertC.addAction(pendingNotificationAction)
        alertC.addAction(deliveredNotificationAction)
        alertC.addAction(clearNotificationAction)
        alertC.addAction(cancelAction)
        self.present(alertC, animated: true, completion: nil)
    }
    
    @objc func triggerNotification() {
        
        //unique identifier for notification
        let uuid = UUID().uuidString
        
        //UNMutableNotificationContent contains data associated with the notification
        let content = UNMutableNotificationContent()
        content.title = "Notifications Demo"
        content.subtitle = "Codepath Week 6"
        content.body = "This session is about frameworks and related stuff!"
        
        //A UNTimeIntervalNotificationTrigger needs to know when to fire and if it should repeat
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5, repeats: false)
        
        //Add attachment
        guard let imageURL = Bundle.main.url(forResource: "KungfuPanda", withExtension: "jpg") else {
            return
        }
        let attachment = try! UNNotificationAttachment(identifier:
            uuid, url: imageURL, options: .none)
        content.attachments = [attachment]
        
        //create a notification request
        let request = UNNotificationRequest(
            identifier: uuid, content: content, trigger: trigger)
        
        //call add(_:withCompletionHandler) on the shared user notification center to add your request to the notification queue
        UNUserNotificationCenter.current().add(request) { (error) in
            if (error != nil) {
                print( "Error when adding a notification request")
            }
        }
    }
}

extension CPDemoNotificationsViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificatonTableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for:indexPath as IndexPath)
        let content = self.notificatonTableContent[indexPath.row]
        cell.textLabel?.text = content.0
        cell.textLabel?.numberOfLines = 2
        cell.accessoryType = .none
        if  content.1 == true {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
