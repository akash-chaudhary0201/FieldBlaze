//
//  StartCheckInVC.swift
//  FieldBlaze
//
//  Created by Sakshi on 11/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import CoreLocation

class StartCheckInVC: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabe: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var visitId:String?
    var accountId:String?
    var accountName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        updateDateTimeLabels()
        
        nameLabel.text = accountName!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func proceedAction(_ sender: Any) {
        print("------------------------------------------------")
        let storyboard = UIStoryboard(name: "Visits", bundle: nil)
        if let nextController = storyboard.instantiateViewController(withIdentifier: "CustomerInsightVC") as? CustomerInsightVC{
            nextController.accountId = self.accountId
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
    
    //Function to update date and time:
    private func updateDateTimeLabels() {
        dateLabe.text = GetTimeAndDate.getDate(dateFormat: "dd-mm-yyyy")
        timeLabel.text = GetTimeAndDate.getTime(timeFormat: "hh:mm a")
    }
    
    //---------Functions for location manager:----------------------
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            fetchAddress(from: location)
        }
    }
    
    func fetchAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                return
            }
            var addressString = ""
            if let subLocality = placemark.subLocality {
                addressString += subLocality
            }
            self.addressLabel?.text = addressString
            
//            print("Full Address: \(addressString)")
        }
    }
    
}
