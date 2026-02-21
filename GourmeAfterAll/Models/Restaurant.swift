//
//  Restaurant.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class Restaurant {
    @Attribute(.unique) var id: String
    var name: String
    var rating: Double
    var address: String
    var latitude: Double
    var longitude: Double
    var priceLevel: Int
    var userRating: Double?
    var isFavorite: Bool
    var isVisited: Bool
    var photoReference: String?
    var placeId: String
    var timestamp: Date
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(
        id: String,
        name: String,
        rating: Double,
        address: String,
        latitude: Double,
        longitude: Double,
        priceLevel: Int = 0,
        photoReference: String? = nil,
        placeId: String,
        userRating: Double? = nil,
        isFavorite: Bool = false,
        isVisited: Bool = false
    ) {
        self.id = id
        self.name = name
        self.rating = rating
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.priceLevel = priceLevel
        self.photoReference = photoReference
        self.placeId = placeId
        self.userRating = userRating
        self.isFavorite = isFavorite
        self.isVisited = isVisited
        self.timestamp = Date()
    }
    
    var priceLevelString: String {
        String(repeating: "₺", count: max(1, priceLevel))
    }
}

extension Restaurant {
    static var preview: Restaurant {
        Restaurant(
            id: "preview123",
            name: "Güzel Restoran",
            rating: 4.5,
            address: "İstiklal Caddesi No:123, Beyoğlu",
            latitude: 41.0082,
            longitude: 28.9784,
            priceLevel: 2,
            placeId: "ChIJpreview123"
        )
    }
}
