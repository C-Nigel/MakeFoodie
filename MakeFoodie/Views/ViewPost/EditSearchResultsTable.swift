//
//  EditSearchResultsTable.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 1/8/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import MapKit

class EditSearchResultsTable: UITableViewController, UISearchResultsUpdating {

    @IBOutlet var searchTableView: UITableView!
    
    var matchingResults:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // Update search results for search controller
    func updateSearchResults(for searchController: UISearchController) {
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
            for i in 0 ..< response.mapItems.count {
                if response.mapItems[i].placemark.countryCode == "SG" {
                    self.matchingResults = response.mapItems    // Store matching results that are in singapore
                }
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
        return matchingResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "SearchCell", for: indexPath)
        
        // Get placemark
        let selectedItem = matchingResults[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name // Set as placemark name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)   // Set as placemark address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingResults[indexPath.row].placemark
        
        // Create pin and zoom at selected location
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem, address: parseAddress(selectedItem: selectedItem))
        
        // Return to viewcontroller
        dismiss(animated: true, completion: nil)
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
