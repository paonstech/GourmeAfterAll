//
//  NetworkManager.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import Foundation
import CoreLocation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case apiError(String)
    case noResults
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidResponse:
            return "Geçersiz sunucu yanıtı"
        case .invalidData:
            return "Veri işlenemedi"
        case .apiError(let message):
            return "API Hatası: \(message)"
        case .noResults:
            return "Yakınınızda restoran bulunamadı"
        }
    }
}

@Observable
final class NetworkManager {
    static let shared = NetworkManager()
    
    private let apiKey = "AIzaSyDaxEseVQ4VsSjcfFow3u7kjwYzoPmVPME"
    private let baseURL = "https://maps.googleapis.com/maps/api/place"
    
    private init() {}
    
    func fetchNearbyRestaurants(
        coordinate: CLLocationCoordinate2D,
        radius: Int = 3000,
        minRating: Double = 4.0
    ) async throws -> [PlaceResult] {
        let urlString = "\(baseURL)/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&type=restaurant&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let placesResponse = try decoder.decode(PlacesResponse.self, from: data)
        
        guard placesResponse.status == "OK" || placesResponse.status == "ZERO_RESULTS" else {
            throw NetworkError.apiError(placesResponse.errorMessage ?? "Unknown error")
        }
        
        let filteredResults = placesResponse.results.filter { place in
            guard let rating = place.rating else { return false }
            return rating >= minRating
        }
        
        guard !filteredResults.isEmpty else {
            throw NetworkError.noResults
        }
        
        return filteredResults
    }
    
    func getPhotoURL(photoReference: String, maxWidth: Int = 400) -> URL? {
        let urlString = "\(baseURL)/photo?maxwidth=\(maxWidth)&photoreference=\(photoReference)&key=\(apiKey)"
        return URL(string: urlString)
    }
    
    func convertToRestaurant(_ place: PlaceResult) -> Restaurant {
        Restaurant(
            id: place.placeId,
            name: place.name,
            rating: place.rating ?? 0.0,
            address: place.vicinity ?? "Adres bilgisi yok",
            latitude: place.geometry.location.lat,
            longitude: place.geometry.location.lng,
            priceLevel: place.priceLevel ?? 0,
            photoReference: place.photos?.first?.photoReference,
            placeId: place.placeId
        )
    }
}
