//
//  SearchResultsTable.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 29/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchResultsTable: UITableViewController, UISearchResultsUpdating, CLLocationManagerDelegate {
    
    @IBOutlet var searchTableView: UITableView!
    
    var matchingResults:[MKMapItem] = []
    var matchingResultsSG:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    var lm : CLLocationManager?
    var userLoc: CLLocation?
    var userCoord : CLLocationCoordinate2D?
    var userAddr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lm = CLLocationManager()
        lm?.delegate = self
        lm?.desiredAccuracy = kCLLocationAccuracyBest   // Best accuracy
        lm?.distanceFilter = 0
        
        // Check if location authorized
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                // Set user location and get coordinate
                userLoc = lm?.location
                userCoord = userLoc?.coordinate
            case .notDetermined, .restricted, .denied:
                break
            @unknown default:
                break
            }
        }
    }
    
    // Update search results for search controller
    func updateSearchResults(for searchController: UISearchController) {
         // Clear all previous search results before appending
        self.matchingResultsSG.removeAll()
        
        // If user location is found
        if self.userCoord != nil {
            // Convert to map item
            let userPlacemark = MKPlacemark(coordinate: self.userCoord!)
            let userMapItem = MKMapItem(placemark: userPlacemark)
            userMapItem.name = "Your location"

            self.matchingResultsSG.append(userMapItem)
        }
        
        // Guard unwraps optional values for mapView and searchBarText
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()   // Search request comprise of string and region
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)    // Performs search
        search.start { response, _ in
            guard let response = response else {
                return
            }
            // Store all matching results
            self.matchingResults = response.mapItems
            
            // Store matching results that are in singapore
            for i in 0 ..< self.matchingResults.count {
                if self.matchingResults[i].placemark.countryCode == "SG" {
                    self.matchingResultsSG.append(self.matchingResults[i])
                }
            }
            
            // Check if no matching results
            if self.matchingResultsSG.count == 0 {
                // Display message if cannot find any matching results
                let labelDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)) // Create label
                labelDisplay.text = "No such location found" // Set label text
                labelDisplay.textAlignment = .center
                labelDisplay.sizeToFit()
                
                self.tableView.backgroundView = labelDisplay
                self.tableView.separatorStyle = .none   // Remove the lines from tableview
            }
            else {
                self.tableView.backgroundView = nil  // Remove label if present
                self.tableView.separatorStyle = .singleLine // Set lines to tableview
            }
            
            self.tableView.reloadData() // Reload tableview
        }
    }
    
    // Format address of locations
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // Put a space between street num and street name if not nil
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // Put a comma between street and city/state if not nil
        
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // Check if area name is called Singapore else display it
        let checkArea = (selectedItem.locality == "Singapore") ? "" : selectedItem.locality
        
        // Put a space between if area name is not Singapore and state is Singapore
        let secondSpace = (selectedItem.locality != "Singapore" && selectedItem.administrativeArea != nil) ? " " : ""
        
        // Create formatted address
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // Street num e.g. 268
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // Street name e.g. Orchard Road
            selectedItem.thoroughfare ?? "",
            comma,
            // Area e.g. Serangoon
            checkArea ?? "",
            secondSpace,
            // State - Singapore
            selectedItem.administrativeArea ?? ""
        )

        return addressLine
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingResultsSG.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "SearchCell", for: indexPath)
        
        // Get placemark
        if(indexPath.row > matchingResultsSG.count-1){
            return UITableViewCell()
        }
        else {
            let selectedItem = matchingResultsSG[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name // Set as placemark name

            // Check if selected item is user location
            if selectedItem.name == "Your location" {
                // Convert coordinates to address
                CLGeocoder().reverseGeocodeLocation(userLoc!) { (placemark, error) in
                    if error != nil {
                        print("Error reverse geocoding")
                    }
                    else {
                        let place = placemark! as [CLPlacemark]
                        if place.count > 0 {
                            let place = placemark![0]
                            var addressString : String = "" // Set location address
                            if place.subThoroughfare != nil {
                                addressString = addressString + place.subThoroughfare! + " "
                            }
                            if place.thoroughfare != nil {
                                addressString = addressString + place.thoroughfare! + ", "
                            }
                            if place.locality != nil && place.locality != "Singapore" {
                                addressString = addressString + place.locality! + " "
                            }
                            if place.administrativeArea != nil {
                                addressString = addressString + place.administrativeArea!
                            }

                            cell.detailTextLabel?.text = addressString
                            self.userAddr = addressString
                        }
                    }
                }
            }
            else {
                cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)   // Set as placemark address
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row > matchingResultsSG.count-1){}
        else {
            let selectedItem = matchingResultsSG[indexPath.row].placemark
            // Create pin and zoom at selected location
            if selectedItem.name == "Your location" {
                handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem, address: self.userAddr!)
            }
            else {
                handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem, address: parseAddress(selectedItem: selectedItem))
            }
        }
        
        // Return to viewcontroller
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    /* In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
}
