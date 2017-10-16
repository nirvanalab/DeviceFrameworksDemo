//
//  CPDemoLocationViewController.swift
//  AllInOneDemo
//
//  Created by Nirvana on 10/14/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class CPDemoLocationViewController: UIViewController {

    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        //The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.allowsBackgroundLocationUpdates = true
        //The accuracy of the location data.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
       
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        
        setupData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         requestUserLocation()
    }
    
    private func requestUserLocation() {

        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager.startUpdatingLocation()
            //to fetch location only once
            //locationManager.requestLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    func addRegion(title:String,coordinate:CLLocationCoordinate2D,radius:CLLocationDistance) {
        
        //setup region
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: title)
        //Starts monitoring the specified region.
        locationManager.startMonitoring(for: region)
        
        // setup annotation
        let officeAnnotation = MKPointAnnotation()
        officeAnnotation.coordinate = coordinate;
        officeAnnotation.title = "\(title)";
        mapView.addAnnotation(officeAnnotation)
        
        // setup circle
        //A circular overlay with a configurable radius and centered on a specific geographic coordinate.
        //let circle = MKCircle.init(center: coordinate, radius: radius)
        //mapView.add(circle)
        
    }
    func setupData() {
        //The CLCircularRegion class defines the location and boundaries for a circular geographic region. You can use instances of this class to define geo fences for a specific location
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            addRegion(title: "Microsoft Office", coordinate: CLLocationCoordinate2DMake(37.4043412,-122.0363792), radius: 300)
            addRegion(title: "Google Office", coordinate: CLLocationCoordinate2DMake(37.4219999,-122.0862462), radius: 300)
            addRegion(title: "Facebook Office", coordinate: CLLocationCoordinate2DMake(37.481796,-122.1578008), radius: 300)
        }
    }
    
    func showStatus(content:String) {
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) {
                (granted, error) in
                if granted {
                    self.triggerNotification(body:content)
                } else {
                    print(error?.localizedDescription ?? "Permission Denied")
                }
        }
        
    }
    
    func triggerNotification(body:String) {
        
        //unique identifier for notification
        let uuid = UUID().uuidString
        
        let content = UNMutableNotificationContent()
        content.title = "Location Demo"
        content.subtitle = ""
        content.body = body
        
        //create a notification request
        let request = UNNotificationRequest(
            identifier: uuid, content: content, trigger: nil)
        
       UNUserNotificationCenter.current().add(request) { (error) in
            if (error != nil) {
                print( "Error when adding a notification request")
            }
        }
    }
}

extension CPDemoLocationViewController:CLLocationManagerDelegate,MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    //Tells the delegate that new location data is available.
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        
        let latestLocation: CLLocation = locations[locations.count - 1]
        longitudeLbl.text = String(format: "%.4f",
                                   latestLocation.coordinate.longitude)
        latitudeLbl.text = String(format: "%.4f",
                                  latestLocation.coordinate.latitude)
        
        print("Location Update \(latestLocation.coordinate.longitude), \(latestLocation.coordinate.latitude)")
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
        print(error)
        
    }
    
    // 1. user enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("Entered \(region.identifier)")
            showStatus(content: "Entered \(region.identifier)")
        }
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            print ("Exit \(region.identifier)")
            showStatus(content: "Exit \(region.identifier)")
            locationManager.stopMonitoring(for: region)
        }
    }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let circleRenderer = MKCircleRenderer(overlay: overlay)
//        circleRenderer.strokeColor = UIColor.red
//        circleRenderer.lineWidth = 1.0
//        return circleRenderer
//    }
    
}
