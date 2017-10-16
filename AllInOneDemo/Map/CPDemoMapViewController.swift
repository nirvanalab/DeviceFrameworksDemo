//
//  CPDemoMapViewController.swift
//  AllInOneDemo
//
//  Created by Nirvana on 10/15/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CPDemoMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
    }
    
    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "My annotation!"
        mapView.addAnnotation(annotation)
    }
    
   
}


extension CPDemoMapViewController:CLLocationManagerDelegate,MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse ||
            status == CLAuthorizationStatus.authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
            addAnnotationAtCoordinate(coordinate: location.coordinate)
        }
    }

    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        let mickeyImage = UIImage(named:"MickeyMouse")
        
        annotationView!.image = UIImage(cgImage: (mickeyImage?.cgImage)!, scale: 6, orientation: UIImageOrientation.up)
        
        return annotationView
    }*/
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        // custom pin annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        annotationView!.pinTintColor = UIColor.purple
        
        return annotationView
    }
    
}
