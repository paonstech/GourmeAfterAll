//
//  HomeViewModel.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import Foundation
import SwiftData
import CoreLocation

@Observable
final class HomeViewModel {
    var restaurants: [Restaurant] = []
    var filteredRestaurants: [Restaurant] = []
    var isLoading = false
    var errorMessage: String?
    var showError = false
    
    var searchText = ""
    var maxDistance: Double = 5.0
    
    private let networkManager = NetworkManager.shared
    private let locationManager = LocationManager.shared
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func applyFilters() {
        guard let location = locationManager.currentLocation else {
            filteredRestaurants = []
            return
        }
        
        var filtered = restaurants
        
        if !searchText.isEmpty {
            filtered = filtered.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filtered = filtered.filter { restaurant in
            let distance = calculateDistance(
                from: location.coordinate,
                to: restaurant.coordinate
            )
            return distance <= maxDistance
        }
        
        filteredRestaurants = filtered
    }
    
    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) / 1000.0
    }
    
    @MainActor
    func loadRestaurants() async {
        guard let location = locationManager.currentLocation else {
            locationManager.requestLocation()
            
            try? await Task.sleep(for: .seconds(2))
            
            if locationManager.currentLocation == nil {
                errorMessage = "Konum bilgisi alınamadı. Lütfen konum izinlerini kontrol edin."
                showError = true
                return
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let radiusInMeters = Int(maxDistance * 1000)
            let places = try await networkManager.fetchNearbyRestaurants(
                coordinate: location.coordinate,
                radius: radiusInMeters,
                minRating: 4.0
            )
            
            let fetchedRestaurants = places.map { networkManager.convertToRestaurant($0) }
            
            restaurants = fetchedRestaurants
            applyFilters()
            
            await saveRestaurantsToDatabase()
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    @MainActor
    private func saveRestaurantsToDatabase() async {
        guard let modelContext = modelContext else { return }
        
        for restaurant in restaurants {
            let restaurantId = restaurant.id
            let fetchDescriptor = FetchDescriptor<Restaurant>(
                predicate: #Predicate<Restaurant> { $0.id == restaurantId }
            )
            
            if let existingRestaurants = try? modelContext.fetch(fetchDescriptor),
               existingRestaurants.isEmpty {
                modelContext.insert(restaurant)
            }
        }
        
        try? modelContext.save()
    }
    
    func refreshRestaurants() async {
        await loadRestaurants()
    }
}
