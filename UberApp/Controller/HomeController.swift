//
//  HomeController.swift
//  UberApp
//
//  Created by Scott on 9/28/20.
//

import UIKit
import Firebase
import MapKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    // map view
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    private let inputActivationView = LocationInputActivationView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        checkIfUserIsLoggedIn()
        enableLocationServices()
        //signOut()
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                //nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
            print("User not logged in.")
            
        } else {
            configureUI()
            print("User is logged in")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        configureMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        inputActivationView.delegate = self
        
        // animate search bar in as mapView sets up
        inputActivationView.alpha = 0
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }

}

// MARK: - LocationServices

extension HomeController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied: break
        case .authorizedAlways:
            print("Auth always")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("Auth when in use..")
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
}

extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        print("DEBUG: Handle present location input view")
    }
    
}
