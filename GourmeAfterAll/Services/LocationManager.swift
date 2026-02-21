//
//  LocationManager.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import Foundation
import CoreLocation

enum LocationError: LocalizedError {
    case unauthorized
    case unavailable
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Konum izni verilmedi"
        case .unavailable:
            return "Konum servisi kullanılamıyor"
        case .unknown:
            return "Bilinmeyen konum hatası"
        }
    }
}

@Observable
final class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?
    private(set) var authorizationStatus: CLAuthorizationStatus
    private(set) var isLoading = false
    private(set) var error: LocationError?
    
    var locationString: String {
        if let location = currentLocation {
            return String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
        }
        return "Konum alınıyor..."
    }
    
    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocation() {
        isLoading = true
        error = nil
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            error = .unauthorized
            isLoading = false
        @unknown default:
            error = .unknown
            isLoading = false
        }
    }
    
    func startUpdatingLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocation()
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        isLoading = false
        error = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                self.error = .unauthorized
            default:
                self.error = .unavailable
            }
        } else {
            self.error = .unknown
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        } else if authorizationStatus == .denied || authorizationStatus == .restricted {
            error = .unauthorized
            isLoading = false
        }
    }
}
