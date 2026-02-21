//
//  User.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: String
    var email: String
    var name: String
    var createdAt: Date
    var isGuest: Bool
    
    init(id: String, email: String, name: String, isGuest: Bool = false) {
        self.id = id
        self.email = email
        self.name = name
        self.createdAt = Date()
        self.isGuest = isGuest
    }
    
    static var guest: User {
        User(id: "guest", email: "guest@gourmeafterall.com", name: "Misafir", isGuest: true)
    }
}

@Model
final class RestaurantHistory {
    @Attribute(.unique) var id: String
    var restaurantId: String
    var restaurantName: String
    var userId: String
    var visitedAt: Date
    var rating: Double?
    var note: String?
    
    init(restaurantId: String, restaurantName: String, userId: String, rating: Double? = nil, note: String? = nil) {
        self.id = UUID().uuidString
        self.restaurantId = restaurantId
        self.restaurantName = restaurantName
        self.userId = userId
        self.visitedAt = Date()
        self.rating = rating
        self.note = note
    }
}