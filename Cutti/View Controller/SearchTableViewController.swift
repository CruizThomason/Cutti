//
//  SearchTableViewController.swift
//  Cutti
//
//  Created by cruizthomason on 4/30/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import UIKit
import MapKit

class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func requestAuthorization() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let clientText = searchBar.text, clientText != "" else { return }
        
        guard let userLocation = currentLocation else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.3623, longitudeDelta: 0.3623)
        
        BarberController.shared.fetchAllNearbyBarbersWith(userLocation: userLocation, span: span) {
            // This is taking out the pizza
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func parsingTheAddress(_ selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(format: "%@%@%@%@%@%@%@", selectedItem.subThoroughfare ?? "", firstSpace, selectedItem.thoroughfare ?? "", comma, selectedItem.locality ?? "", secondSpace, selectedItem.administrativeArea ?? "")
        return addressLine
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BarberController.shared.barbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barberCell", for: indexPath)
        
        let barber = BarberController.shared.barbers[indexPath.row]
        
        cell.textLabel?.text = barber.username
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
