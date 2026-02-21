//
//  RestaurantCard.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import SwiftUI

struct RestaurantCard: View {
    let restaurant: Restaurant
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(restaurant.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 14))
                            Text(String(format: "%.1f", restaurant.rating))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        if restaurant.priceLevel > 0 {
                            Text(restaurant.priceLevelString)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: restaurant.isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(restaurant.isFavorite ? .red : .gray)
                }
            }
            
            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(restaurant.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

#Preview {
    RestaurantCard(
        restaurant: Restaurant.preview,
        onFavoriteToggle: {}
    )
    .padding()
}
