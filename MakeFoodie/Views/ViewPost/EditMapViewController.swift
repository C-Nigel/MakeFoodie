//
//  EditMapViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 1/8/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import MapKit

protocol GetLocationFromEditMap {
    func passLocation(controller: EditMapViewController)
}

class EditMapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, HandleMapSearch {

    @IBOutlet weak var mapView: MKMapView!
    
    var currSelectedLat: Double?
    var currSelectedLng: Double?
    var selectedLocation:MKPlacemark? = nil
    var locationName: String = ""
    var locationAddr: String = ""   // Store selected location formatted address
    var getLocationFromEditMapDelegate: GetLocationFromEditMap! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Show map as previously chosen location
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)   // Width and height of map region (Desired zoom level)
        let regionCoords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: currSelectedLat!, longitude: currSelectedLng!)  // Coordinates of currently selected location
        let region = MKCoordinateRegion(center: regionCoords, span: span)   // Rectangular geographic region centered around a specific latitude and longitude
        mapView.setRegion(region, animated: true)   // Set region
        
        // Place annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = regionCoords
        annotation.title = locationName
        annotation.subtitle = locationAddr
        mapView.addAnnotation(annotation)
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
         mapView.selectAnnotation(mapView.annotations[0], animated: true)
     }
     
     // Change how annotations look
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         // This behaves like the Table View's dequeue re-usable cell.
         var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
         
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
         
         //let rightButton = UIButton(type: .contactAdd)
         
         // Add action after clicking
         rightButton.addTarget(self, action: #selector(setLocation(_:)), for: .touchUpInside)
         
         // Assign the annotation to the pin so that iOS knows where to position it in the map.
         annotationView?.annotation = annotation
         
         // Set button to right of annotation and pop up when clicked
         annotationView?.rightCalloutAccessoryView = rightButton
         annotationView?.canShowCallout = true
         
         return annotationView
     }
    
    // For passing location values from controller
    @objc func setLocation(_ button:UIButton) {
        getLocationFromEditMapDelegate.passLocation(controller: self)
    }
    
    // When user cancel
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // When search button clicked
    @IBAction func searchButtonPressed(_ sender: Any) {
            // Create SearchController
            // Assign search bar results to table view controller
            let searchResultsTable = storyboard!.instantiateViewController(withIdentifier: "EditSearchResultsTable") as! EditSearchResultsTable
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
