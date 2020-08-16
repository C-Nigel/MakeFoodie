//
//  MapViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 27/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// Create protocol to implement drop pin zoom in
protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark, address:String)
}

protocol GetLocationFromMap {
    func passLocation(controller: MapViewController)
}

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, HandleMapSearch {

    @IBOutlet weak var mapView: MKMapView!
    
    var lm : CLLocationManager?
    
    var selectedLocation:MKPlacemark? = nil
    var locationAddr: String = ""   // Store selected location formatted address
    var getLocationFromMapDelegate: GetLocationFromMap! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        lm = CLLocationManager()
        lm?.delegate = self
        lm?.desiredAccuracy = kCLLocationAccuracyBest   // Best accuracy
        lm?.distanceFilter = 0
        lm?.requestWhenInUseAuthorization() // Location permission
        lm?.startUpdatingLocation()
                
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)   // Width and height of map region (Desired zoom level)
        let regionCoords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 1.351616, longitude: 103.808053)  // Coordinates of Singapore
        let region = MKCoordinateRegion(center: regionCoords, span: span)   // Rectangular geographic region centered around a specific latitude and longitude
        mapView.setRegion(region, animated: true)   // Set region

    }
    
    func dropPinZoomIn(placemark:MKPlacemark, address:String){
        // Set location
        selectedLocation = placemark
        
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotation.subtitle = address
        locationAddr = address
        mapView.addAnnotation(annotation)
        
        // Set region
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)  // Zoom level
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        // Display annotation
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                for i in 0..<mapView.annotations.count {
                    if mapView.annotations[i] is MKUserLocation {}
                    else {
                        mapView.selectAnnotation(mapView.annotations[i], animated: true)
                    }
                }
            case .notDetermined, .restricted, .denied:
                mapView.selectAnnotation(mapView.annotations[0], animated: true)
            @unknown default:
                break
            }
        }
    }
    
    // Change how annotations look
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // This behaves like the Table View's dequeue re-usable cell.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        // User location annotation
        if annotation is MKUserLocation {
            return nil
        }
        
        // If there aren't any reusable views to dequeue, we will have to create a new one.
        if annotationView == nil
        {
            let pinAnnotationView = MKPinAnnotationView(annotation: nil, reuseIdentifier: "pin")
            annotationView = pinAnnotationView
        }
        
        // Create button on the right to set location
        let rightButton = UIButton(frame: CGRect(x: 100, y: 155, width: 50, height: 50))
        rightButton.setTitleColor(.black, for: .normal)
        rightButton.backgroundColor = .orange
        rightButton.setTitle("Set", for: .normal)
                
        // Add action after clicking
        rightButton.addTarget(self, action: #selector(setLocation(_:)), for: .touchUpInside)
        
        // Assign the annotation to the pin so that iOS knows where to position it in the map.
        annotationView?.annotation = annotation
        
        // Set button to right of annotation and pop up when clicked
        annotationView?.rightCalloutAccessoryView = rightButton
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    @objc func setLocation(_ button:UIButton) {
        // For passing location values from controller
        getLocationFromMapDelegate.passLocation(controller: self)
    }
    
    // Click cancel button
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Click search button
    @IBAction func searchButtonPressed(_ sender: Any) {
        // Create SearchController
        // Assign search bar results to table view controller
        let searchResultsTable = storyboard!.instantiateViewController(withIdentifier: "SearchResultsTable") as! SearchResultsTable
        searchResultsTable.mapView = mapView
        searchResultsTable.handleMapSearchDelegate = self
        let searchController = UISearchController(searchResultsController: searchResultsTable)
        searchController.searchResultsUpdater = searchResultsTable
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter a location..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true
    
        present(searchController, animated: true, completion: nil)  // Display at nav bar
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
