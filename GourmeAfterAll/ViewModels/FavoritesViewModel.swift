//
//  FavoritesViewModel.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import Foundation
import SwiftData

@Observable
final class FavoritesViewModel {
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func toggleFavorite(_ restaurant: Restaurant) {
        restaurant.isFavorite.toggle()
        try? modelContext?.save()
    }
    
    func rateRestaurant(_ restaurant: Restaurant, rating: Double) {
        restaurant.userRating = rating
        restaurant.isVisited = true
        try? modelContext?.save()
    }
    
    func deleteRestaurant(_ restaurant: Restaurant) {
        modelContext?.delete(restaurant)
        try? modelContext?.save()
    }
}
