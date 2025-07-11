//
//  CheckInVC.swift
//  FieldBlaze
//
//  Created by Sakshi on 04/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SalesforceSDKCore


class CheckInVC: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var skipBtn: UIButton?
    @IBOutlet var checkInBtn: UIButton?
    @IBOutlet var mapView: MKMapView?
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var punchInTime: String?
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocation()
        if let user = UserAccountManager.shared.currentUserAccount {
            let credentials = user.credentials
            print("Access Token::: \(credentials.accessToken ?? "")")
            Defaults.accessToken = credentials.accessToken
            Defaults.refreshToken = credentials.refreshToken
            Defaults.instanceUrl = credentials.instanceUrl?.absoluteString
            Defaults.userId = credentials.userId
            Defaults.domain = credentials.domain
            if let issuedAtDate = credentials.issuedAt {
                let formatter = ISO8601DateFormatter()
                Defaults.issuedAt = formatter.string(from: issuedAtDate)
            }
            Defaults.organizationId = credentials.organizationId ?? ""
            
        }
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView?.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            fetchAddress(from: location)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView?.setRegion(region, animated: true)
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
            
            if let name = placemark.name {
                addressString += name + ", "
            }
            if let subLocality = placemark.subLocality {
                addressString += subLocality + ", "
            }
            if let locality = placemark.locality {
                addressString += locality + ", "
            }
            if let administrativeArea = placemark.administrativeArea {
                addressString += administrativeArea + ", "
            }
            if let postalCode = placemark.postalCode {
                addressString += postalCode + ", "
            }
            if let country = placemark.country {
                addressString += country
            }
            self.addressLabel?.text = addressString
            
            print("Full Address: \(addressString)")
        }
    }

    func navigateToHome() {
        Defaults.isCheckIn = true
        Utility.gotoTabbar()
        
    }
    
    func setupUI() {
        skipBtn?.layer.cornerRadius = 17.5
        skipBtn?.layer.masksToBounds = true
        checkInBtn?.layer.cornerRadius = 22.5
        checkInBtn?.layer.masksToBounds = true
    }
    
    @IBAction func skipAction() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let selectedVC = storyboard.instantiateViewController(identifier: "HomeVC") as? HomeVC {
            self.navigationController?.pushViewController(selectedVC, animated: true)
        }
    }
    
    @IBAction func checkInAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        punchInTime = dateFormatter.string(from: Date())
        Defaults.punchInTime = punchInTime
        print("Punch-In Time: \(punchInTime ?? "")")
        navigateToHome()
    }
    
}
