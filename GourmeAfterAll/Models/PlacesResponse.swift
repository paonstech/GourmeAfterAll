//
//  PlacesResponse.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import Foundation

struct PlacesResponse: Codable {
    let results: [PlaceResult]
    let status: String
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case results
        case status
        case errorMessage = "error_message"
    }
}

struct PlaceResult: Codable, Identifiable {
    let placeId: String
    let name: String
    let geometry: Geometry
    let rating: Double?
    let priceLevel: Int?
    let vicinity: String?
    let photos: [Photo]?
    let types: [String]?
    
    var id: String { placeId }
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case geometry
        case rating
        case priceLevel = "price_level"
        case vicinity
        case photos
        case types
    }
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

struct Photo: Codable {
    let photoReference: String
    let height: Int
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
        case height
        case width
    }
}
