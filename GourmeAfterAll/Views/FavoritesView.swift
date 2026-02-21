//
//  FavoritesView.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<Restaurant> { $0.isFavorite },
        sort: \Restaurant.timestamp,
        order: .reverse
    ) private var favoriteRestaurants: [Restaurant]
    
    @State private var viewModel = FavoritesViewModel()
    
    var body: some View {
        ZStack {
            if favoriteRestaurants.isEmpty {
                emptyStateView
            } else {
                restaurantsList
            }
        }
        .navigationTitle("Favorilerim")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }
    
    private var restaurantsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(favoriteRestaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                        FavoriteRestaurantRow(restaurant: restaurant)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.slash")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("Henüz Favori Yok")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Beğendiğiniz restoranları favorilere ekleyerek\nburadan kolayca ulaşabilirsiniz")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

struct FavoriteRestaurantRow: View {
    @Environment(\.modelContext) private var modelContext
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let userRating = restaurant.userRating {
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                            Text(String(format: "%.1f", userRating))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if restaurant.priceLevel > 0 {
                        Text(restaurant.priceLevelString)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(restaurant.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: {
                restaurant.isFavorite.toggle()
                try? modelContext.save()
                
                let haptic = UIImpactFeedbackGenerator(style: .light)
                haptic.impactOccurred()
            }) {
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
            .modelContainer(for: Restaurant.self, inMemory: true)
    }
}
