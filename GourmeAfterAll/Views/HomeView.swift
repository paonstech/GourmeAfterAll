//
//  HomeView.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomeViewModel()
    @State private var locationManager = LocationManager.shared
    @State private var authManager = AuthManager.shared
    @State private var showRestaurantDetail = false
    @State private var selectedRestaurant: Restaurant?
    @State private var showLogin = false
    @State private var showProfile = false
    @State private var wheelSpinId = UUID()  // Çark için unique ID
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                ScrollView {
                    VStack(spacing: 20) {
                        locationHeader
                        
                        FilterSection(
                            searchText: $viewModel.searchText,
                            maxDistance: $viewModel.maxDistance,
                            onFilterChange: {
                                viewModel.applyFilters()
                            }
                        )
                        
                        wheelSection
                        
                        if let restaurant = selectedRestaurant {
                            selectedRestaurantCard(restaurant)
                                .id(restaurant.id)  // Her restaurant için unique ID
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
                
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("GourmeAfterAll")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Nerede Yesem?")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if authManager.isAuthenticated {
                        Button(action: { showProfile = true }) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title3)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        if !authManager.isAuthenticated {
                            Button(action: { showLogin = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "person.circle")
                                    Text("Giriş")
                                        .font(.subheadline)
                                }
                                .foregroundColor(.orange)
                            }
                        }
                        
                        NavigationLink(destination: FavoritesView()) {
                            Image(systemName: "heart.circle.fill")
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .alert("Hata", isPresented: $viewModel.showError) {
                Button("Tamam", role: .cancel) {}
                Button("Tekrar Dene") {
                    Task {
                        await viewModel.loadRestaurants()
                    }
                }
            } message: {
                Text(viewModel.errorMessage ?? "Bilinmeyen bir hata oluştu")
            }
            .sheet(isPresented: $showLogin) {
                LoginView()
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }
            .task {
                viewModel.setModelContext(modelContext)
                authManager.setModelContext(modelContext)
                locationManager.requestLocation()
                
                try? await Task.sleep(for: .seconds(1))
                
                await viewModel.loadRestaurants()
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color.orange.opacity(0.08),
                Color.white,
                Color.red.opacity(0.03)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var locationHeader: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                    .foregroundColor(.orange)
                Text("Konumunuz")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(locationManager.locationString)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color(.systemGray6))
                )
        }
        .padding(.horizontal)
    }
    
    private var wheelSection: some View {
        VStack(spacing: 16) {
            let displayRestaurants = viewModel.filteredRestaurants.isEmpty ? viewModel.restaurants : viewModel.filteredRestaurants
            
            if !displayRestaurants.isEmpty {
                Text("Çarkı Çevir, Şansını Dene!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                
                SpinningWheel(restaurants: Array(displayRestaurants.prefix(8))) { restaurant in
                    // Çark çevirme başladığında önceki seçimi temizle
                    selectedRestaurant = nil
                    
                    // Kısa bir gecikme sonrası yeni restaurant'ı göster
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedRestaurant = restaurant
                        }
                        
                        if authManager.isAuthenticated {
                            authManager.addToHistory(restaurant: restaurant)
                        }
                        
                        let haptic = UINotificationFeedbackGenerator()
                        haptic.notificationOccurred(.success)
                    }
                }
                .id(wheelSpinId)
                .frame(height: 440)  // Sabit yükseklik
                .padding(.vertical, 4)
                
                HStack(spacing: 12) {
                    Button(action: {
                        // Tüm state'leri temizle
                        selectedRestaurant = nil
                        wheelSpinId = UUID()
                        viewModel.searchText = ""
                        viewModel.maxDistance = 5.0
                        
                        Task {
                            await viewModel.refreshRestaurants()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: viewModel.isLoading ? "arrow.clockwise" : "arrow.clockwise")
                                .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                                .animation(viewModel.isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: viewModel.isLoading)
                            Text("Yenile")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .stroke(Color.orange, lineWidth: 2)
                                .background(Capsule().fill(Color.white))
                        )
                    }
                    .disabled(viewModel.isLoading)
                    
                    Text("\(displayRestaurants.count) restoran")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color(.systemGray6))
                        )
                }
                .padding(.top, 12)
            } else {
                emptyWheelState
            }
        }
        .padding(.horizontal)
    }
    
    private var emptyWheelState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Filtrelerinize Uygun Restoran Yok")
                .font(.headline)
            
            Text("Arama kriterlerinizi değiştirerek tekrar deneyin")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Filtreleri Sıfırla") {
                viewModel.searchText = ""
                viewModel.maxDistance = 5.0
                viewModel.applyFilters()
            }
            .foregroundColor(.orange)
        }
        .frame(height: 300)
        .padding()
    }
    
    private func selectedRestaurantCard(_ restaurant: Restaurant) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
                Text("Kazanan Restoran!")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            
            RestaurantCard(restaurant: restaurant) {
                // Veritabanındaki restaurant'ı bul ve güncelle
                let restaurantId = restaurant.id
                let fetchDescriptor = FetchDescriptor<Restaurant>(
                    predicate: #Predicate<Restaurant> { $0.id == restaurantId }
                )
                
                if let dbRestaurants = try? modelContext.fetch(fetchDescriptor),
                   let dbRestaurant = dbRestaurants.first {
                    dbRestaurant.isFavorite.toggle()
                    try? modelContext.save()
                } else {
                    // Eğer database'de yoksa, ekle
                    restaurant.isFavorite.toggle()
                    modelContext.insert(restaurant)
                    try? modelContext.save()
                }
                
                let haptic = UIImpactFeedbackGenerator(style: .light)
                haptic.impactOccurred()
            }
            
            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                Text("Detayları Gör")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.1), Color.yellow.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.orange.opacity(0.3), lineWidth: 2)
        )
        .padding(.horizontal)
        .transition(.scale.combined(with: .opacity))
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.orange)
                
                Text("Restoranlar Yükleniyor...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 20)
            )
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Restaurant.self, User.self, RestaurantHistory.self], inMemory: true)
}
