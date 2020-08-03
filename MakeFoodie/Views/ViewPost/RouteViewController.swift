//
//  RouteViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 2/8/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var lm : CLLocationManager?
    
    // Store destination data
    var destLat: Double?
    var destLng: Double?
    var destName: String?
    var destAddr: String?
    
    // Store user location
    var userLoc:CLLocation?
    
    // For getting directions
    var directionRequest = MKDirections.Request()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        lm = CLLocationManager()
        lm?.delegate = self
        lm?.desiredAccuracy = kCLLocationAccuracyBest   // Best accuracy
        lm?.distanceFilter = 0
        lm?.requestWhenInUseAuthorization() // Location permission
        lm?.startUpdatingLocation()
        
        // Set starting transport type as walking
        directionRequest.transportType = .walking
    }
    
    // When user location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        print ("\(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        // Set region
        let region = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        if destLat != nil && destLng != nil {
            let destCoords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: destLat!, longitude: destLng!)
            getDirections(userCoordinate: location.coordinate, destCoordinate: destCoords)
            userLoc = location
        }
    }
    
    // For getting directions from user location to destination
    func getDirections(userCoordinate: CLLocationCoordinate2D, destCoordinate: CLLocationCoordinate2D) {
        // Create placemark for mapItem (User and dest)
        let userPlacemark = MKPlacemark(coordinate: userCoordinate, addressDictionary: nil)
        let destPlacemark = MKPlacemark(coordinate: destCoordinate, addressDictionary: nil)

        let userMapItem = MKMapItem(placemark: userPlacemark)
        let destMapItem = MKMapItem(placemark: destPlacemark)

        // Create annotation for dest location
        if let location = destPlacemark.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = destName
            annotation.subtitle = destAddr
            mapView.addAnnotation(annotation)
        }
        
        // Get direction
        directionRequest.source = userMapItem   // Start at user location
        directionRequest.destination = destMapItem  // To dest location

        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }
            
            // Get the route
            let route = response.routes[0]
            
            // Overlay the route
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)

            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }

    // Asks the delegate for a renderer object to use when drawing specified overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Renderer is used to draw contents of overlay
        let renderer = MKPolylineRenderer(overlay: overlay)

        // Color and width of line
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)    // Light blue color
        renderer.lineWidth = 5.0

        return renderer
    }
    
    // Change how annotations look
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // This behaves like the Table View's dequeue re-usable cell.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        // Do not override user location annotation
        if annotation is MKUserLocation {
            return nil
        }
        
        // If there aren't any reusable views to dequeue, we will have to create a new one.
        if annotationView == nil
        {
            let pinAnnotationView = MKPinAnnotationView(annotation: nil, reuseIdentifier: "pin")
            annotationView = pinAnnotationView
        }

        // Assign the annotation to the pin so that iOS knows where to position it in the map.
        annotationView?.annotation = annotation
        
        // Set button to right of annotation and pop up when clicked
        annotationView?.canShowCallout = true
        
        return annotationView
    }

    // When user click on different travel mode
    @IBAction func travelModePressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            directionRequest.transportType = .walking  // Mode of transport
        case 1:
            directionRequest.transportType = .automobile
        default:
            directionRequest.transportType = .walking
        }
        
        // Remove existing overlay
        let currOverlay = mapView.overlays
        mapView.removeOverlays(currOverlay)
        
        // Set overlay again based on mode of transport
        if userLoc != nil {
            let destCoords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: destLat!, longitude: destLng!)
            getDirections(userCoordinate: userLoc!.coordinate, destCoordinate: destCoords)
        }
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
