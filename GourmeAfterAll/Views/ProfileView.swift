//
//  ProfileView.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var authManager = AuthManager.shared
    
    @Query(sort: \Restaurant.timestamp, order: .reverse) private var allRestaurants: [Restaurant]
    @Query(sort: \RestaurantHistory.visitedAt, order: .reverse) private var history: [RestaurantHistory]
    
    @State private var showLogoutAlert = false
    @State private var selectedTab = 0
    
    var favoriteRestaurants: [Restaurant] {
        allRestaurants.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.orange.opacity(0.1), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader
                        
                        statsSection
                        
                        tabSelector
                        
                        if selectedTab == 0 {
                            favoritesSection
                        } else {
                            historySection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showLogoutAlert = true }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Çıkış Yap", isPresented: $showLogoutAlert) {
                Button("İptal", role: .cancel) {}
                Button("Çıkış Yap", role: .destructive) {
                    authManager.logout()
                }
            } message: {
                Text("Hesabınızdan çıkmak istediğinize emin misiniz?")
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Text(authManager.currentUser?.name.prefix(1).uppercased() ?? "?")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 4) {
                Text(authManager.currentUser?.name ?? "Kullanıcı")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(authManager.currentUser?.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if authManager.currentUser?.isGuest == true {
                    Text("Misafir Hesap")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
    
    private var statsSection: some View {
        HStack(spacing: 16) {
            statCard(
                icon: "heart.fill",
                count: favoriteRestaurants.count,
                title: "Favoriler",
                color: .red
            )
            
            statCard(
                icon: "clock.fill",
                count: history.count,
                title: "Ziyaret",
                color: .orange
            )
            
            statCard(
                icon: "star.fill",
                count: allRestaurants.filter { $0.userRating != nil }.count,
                title: "Değerlendirme",
                color: .yellow
            )
        }
    }
    
    private func statCard(icon: String, count: Int, title: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text("\(count)")
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            tabButton(title: "Favoriler", icon: "heart.fill", index: 0)
            tabButton(title: "Geçmiş", icon: "clock.fill", index: 1)
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func tabButton(title: String, icon: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedTab = index
            }
        }) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .foregroundColor(selectedTab == index ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                selectedTab == index ?
                LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing) :
                LinearGradient(colors: [.clear], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(12)
        }
    }
    
    private var favoritesSection: some View {
        LazyVStack(spacing: 16) {
            if favoriteRestaurants.isEmpty {
                emptyState(
                    icon: "heart.slash",
                    title: "Henüz Favori Yok",
                    message: "Beğendiğiniz restoranları favorilere ekleyin"
                )
            } else {
                ForEach(favoriteRestaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                        FavoriteRestaurantCard(restaurant: restaurant)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var historySection: some View {
        LazyVStack(spacing: 16) {
            if history.isEmpty {
                emptyState(
                    icon: "clock.badge.exclamationmark",
                    title: "Henüz Geçmiş Yok",
                    message: "Ziyaret ettiğiniz restoranlar burada görünecek"
                )
            } else {
                ForEach(history) { item in
                    HistoryCard(history: item)
                }
            }
        }
    }
    
    private func emptyState(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

struct FavoriteRestaurantCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.subheadline)
                    }
                    
                    if restaurant.priceLevel > 0 {
                        Text(restaurant.priceLevelString)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct HistoryCard: View {
    let history: RestaurantHistory
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "clock.fill")
                .font(.system(size: 30))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(history.restaurantName)
                    .font(.headline)
                
                Text(history.visitedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let rating = history.rating {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: [User.self, Restaurant.self, RestaurantHistory.self], inMemory: true)
}