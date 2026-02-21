//
//  RestaurantDetailView.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct RestaurantDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let restaurant: Restaurant
    
    @State private var userRating: Double = 0
    @State private var showRatingSheet = false
    @State private var cameraPosition: MapCameraPosition
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _userRating = State(initialValue: restaurant.userRating ?? 0)
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(
                center: restaurant.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                mapSection
                
                infoSection
                
                ratingSection
                
                actionButtons
            }
            .padding()
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showRatingSheet) {
            ratingSheet
        }
    }
    
    private var mapSection: some View {
        Map(position: $cameraPosition) {
            Marker(restaurant.name, coordinate: restaurant.coordinate)
                .tint(.orange)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(restaurant.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", restaurant.rating))
                                .fontWeight(.semibold)
                        }
                        
                        if restaurant.priceLevel > 0 {
                            Text(restaurant.priceLevelString)
                                .foregroundColor(.secondary)
                        }
                    }
                    .font(.subheadline)
                }
                
                Spacer()
                
                Button(action: toggleFavorite) {
                    Image(systemName: restaurant.isFavorite ? "heart.fill" : "heart")
                        .font(.title)
                        .foregroundColor(restaurant.isFavorite ? .red : .gray)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Adres", systemImage: "mappin.circle.fill")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                Text(restaurant.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Senin Değerlendirmen", systemImage: "star.circle.fill")
                .font(.headline)
                .foregroundColor(.orange)
            
            if let userRating = restaurant.userRating {
                HStack {
                    StarRatingView(rating: userRating)
                    Spacer()
                    Button("Değiştir") {
                        showRatingSheet = true
                    }
                    .font(.subheadline)
                    .foregroundColor(.orange)
                }
            } else {
                Button(action: { showRatingSheet = true }) {
                    HStack {
                        Image(systemName: "star")
                        Text("Değerlendir")
                    }
                    .font(.subheadline)
                    .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: openInGoogleMaps) {
                    HStack {
                        Image(systemName: "map.fill")
                        Text("Google Maps")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.26, green: 0.52, blue: 0.96), Color(red: 0.13, green: 0.59, blue: 0.95)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                
                Button(action: openInYandexMaps) {
                    HStack {
                        Image(systemName: "map")
                        Text("Yandex Maps")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.2, blue: 0.2), Color(red: 0.8, green: 0.0, blue: 0.0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
            
            Button(action: openInAppleMaps) {
                HStack {
                    Image(systemName: "location.fill")
                    Text("Apple Haritalar")
                }
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
            
            if let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(restaurant.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&query_place_id=\(restaurant.placeId)") {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("Google'da Gör")
                    }
                    .font(.headline)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                }
            }
        }
    }
    
    private var ratingSheet: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Bu restoranı değerlendir")
                    .font(.title2)
                    .fontWeight(.bold)
                
                InteractiveStarRating(rating: $userRating)
                
                Text(ratingText)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Button("Kaydet") {
                    saveRating()
                    showRatingSheet = false
                }
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
                .padding(.horizontal)
                .disabled(userRating == 0)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("İptal") {
                        showRatingSheet = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private var ratingText: String {
        switch userRating {
        case 5: return "Mükemmel! 🌟"
        case 4: return "Çok İyi! 😊"
        case 3: return "İyi 👍"
        case 2: return "Orta 😐"
        case 1: return "Kötü 👎"
        default: return "Bir değerlendirme seçin"
        }
    }
    
    private func toggleFavorite() {
        restaurant.isFavorite.toggle()
        try? modelContext.save()
        
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.impactOccurred()
    }
    
    private func saveRating() {
        restaurant.userRating = userRating
        restaurant.isVisited = true
        try? modelContext.save()
        
        let haptic = UINotificationFeedbackGenerator()
        haptic.notificationOccurred(.success)
    }
    
    private func openInAppleMaps() {
        let placemark = MKPlacemark(coordinate: restaurant.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurant.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
        ])
    }
    
    private func openInGoogleMaps() {
        let urlString = "comgooglemaps://?daddr=\(restaurant.coordinate.latitude),\(restaurant.coordinate.longitude)&directionsmode=driving"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let webURL = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(restaurant.coordinate.latitude),\(restaurant.coordinate.longitude)")!
            UIApplication.shared.open(webURL)
        }
    }
    
    private func openInYandexMaps() {
        let urlString = "yandexmaps://maps.yandex.ru/?rtext=~\(restaurant.coordinate.latitude),\(restaurant.coordinate.longitude)&rtt=auto"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let webURL = URL(string: "https://yandex.com.tr/maps/?rtext=~\(restaurant.coordinate.latitude),\(restaurant.coordinate.longitude)")!
            UIApplication.shared.open(webURL)
        }
    }
}

struct StarRatingView: View {
    let rating: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .foregroundColor(.orange)
            }
        }
    }
}

struct InteractiveStarRating: View {
    @Binding var rating: Double
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            rating = Double(index)
                        }
                        
                        let haptic = UIImpactFeedbackGenerator(style: .light)
                        haptic.impactOccurred()
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RestaurantDetailView(restaurant: Restaurant.preview)
            .modelContainer(for: Restaurant.self, inMemory: true)
    }
}
