//
//  MapViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 27/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)   // Width and height of map region (Desired zoom level)
        let regionCoords:CLLocationCoordinate2D = CLLocationCoordinate2DMake(1.351616, 103.808053)  // Coordinates of Singapore
        let region = MKCoordinateRegion(center: regionCoords, span: span)   // Rectangular geographic region centered around a specific latitude and longitude
        mapView.setRegion(region, animated: true)   // Set region

    }
    
    // Click cancel button
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Click search button
    @IBAction func searchButtonPressed(_ sender: Any) {
        // Create SearchController
        let searchController = UISearchController(searchResultsController: nil) 
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
