//
//  SpinningWheel.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import SwiftUI

struct SpinningWheel: View {
    let restaurants: [Restaurant]
    let onRestaurantSelected: (Restaurant) -> Void
    
    @State private var rotation: Double = 0
    @State private var isSpinning = false
    @State private var selectedRestaurant: Restaurant?
    
    private let colors: [Color] = [
        .orange, .red, Color(red: 1.0, green: 0.6, blue: 0.4),
        Color(red: 0.6, green: 0.4, blue: 0.8), .blue, Color(red: 1.0, green: 0.8, blue: 0.4),
        .pink, .teal
    ]
    
    private var canSpin: Bool {
        restaurants.count >= 2 && !isSpinning
    }
    
    var body: some View {
        GeometryReader { geometry in
            let maxSize = min(geometry.size.width, geometry.size.height)
            let wheelSize = maxSize * 0.8
            
            VStack(spacing: 30) {
                if restaurants.count >= 1 {
                    ZStack(alignment: .topTrailing) {
                        wheelView(size: wheelSize)
                        centerPin(size: wheelSize)
                        
                        if restaurants.count >= 2 {
                            pointerIndicator(size: wheelSize)
                        }
                    }
                    .frame(width: wheelSize, height: wheelSize)
                    
                    if restaurants.count == 1 {
                        singleRestaurantInfo
                    } else if !isSpinning {
                        spinButton
                    }
                } else {
                    emptyStateView
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
    
    private func pointerIndicator(size: CGFloat) -> some View {
        VStack {
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.12, height: size * 0.12)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.red, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size * 0.1, height: size * 0.1)
                    
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size * 0.06, height: size * 0.06)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(45))
                }
            }
            Spacer()
        }
        .frame(width: size, height: size)
        .offset(x: size * 0.08, y: -size * 0.08)
    }
    
    private func wheelView(size: CGFloat) -> some View {
        ZStack {
            ForEach(Array(restaurants.enumerated()), id: \.element.id) { index, restaurant in
                wheelSegment(for: restaurant, at: index, size: size)
            }
        }
        .rotationEffect(.degrees(rotation))
        .animation(.easeOut(duration: 3.0), value: rotation)
    }
    
    private func wheelSegment(for restaurant: Restaurant, at index: Int, size: CGFloat) -> some View {
        let segmentAngle = 360.0 / Double(restaurants.count)
        let midAngle = Double(index) * segmentAngle + segmentAngle / 2
        let strokeWidth = size * 0.25
        let outerRadius = size / 2
        let innerRadius = outerRadius - strokeWidth
        let textRadius = outerRadius - (strokeWidth * 0.25)
        
        let angleInRadians = (midAngle - 90) * .pi / 180
        let xPosition = size / 2 + textRadius * cos(angleInRadians)
        let yPosition = size / 2 + textRadius * sin(angleInRadians)
        
        return ZStack {
            Circle()
                .trim(from: CGFloat(index) / CGFloat(restaurants.count),
                      to: CGFloat(index + 1) / CGFloat(restaurants.count))
                .stroke(colors[index % colors.count], lineWidth: strokeWidth)
                .rotationEffect(.degrees(-90))
            
            restaurantText(name: restaurant.name, strokeWidth: strokeWidth)
                .rotationEffect(.degrees(midAngle))
                .position(x: xPosition, y: yPosition)
        }
    }
    
    private func restaurantText(name: String, strokeWidth: CGFloat) -> some View {
        let fontSize: CGFloat = min(strokeWidth * 0.35, 14)
        
        return Text(name)
            .font(.system(size: fontSize, weight: .bold))
            .foregroundColor(.white)
            .frame(width: strokeWidth * 0.8)
            .lineLimit(2)
            .minimumScaleFactor(0.4)
            .multilineTextAlignment(.center)
            .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)
    }
    
    private func centerPin(size: CGFloat) -> some View {
        let outerSize = size * 0.22
        let innerSize = size * 0.18
        let iconSize = size * 0.075
        
        return ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: outerSize, height: outerSize)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: innerSize, height: innerSize)
            
            Image(systemName: "fork.knife")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(.white)
        }
    }
    
    private var spinButton: some View {
        Button(action: spinWheel) {
            Text("ÇEVİR!")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 200, height: 56)
                .background(
                    canSpin ?
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [.gray, .gray],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(28)
                .shadow(color: canSpin ? .orange.opacity(0.5) : .clear, radius: 10, x: 0, y: 5)
        }
        .disabled(!canSpin)
        .padding(.top, 30)
    }
    
    private var singleRestaurantInfo: some View {
        VStack(spacing: 16) {
            Text("Tek Restoran Mevcut")
                .font(.headline)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurants.first?.name ?? "")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.orange)
                                Text(String(format: "%.1f", restaurants.first?.rating ?? 0))
                                    .font(.subheadline)
                            }
                            
                            if let priceLevel = restaurants.first?.priceLevel, priceLevel > 0 {
                                Text(restaurants.first?.priceLevelString ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Text(restaurants.first?.address ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            
            Text("Daha fazla seçenek için arama kriterlerini değiştirin")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "mappin.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            
            Text("Restoran Bulunamadı")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Yakınınızda restoran aramak için\nkonumunuzu açın")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func spinWheel() {
        guard canSpin else { return }
        
        isSpinning = true
        
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.prepare()
        haptic.impactOccurred()
        
        let baseRotation = 360.0 * 3.0
        let randomOffset = Double.random(in: 0...360)
        let finalRotation = rotation + baseRotation + randomOffset
        
        withAnimation(.easeOut(duration: 3.0)) {
            rotation = finalRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let lightHaptic = UIImpactFeedbackGenerator(style: .light)
            for i in 0..<10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                    lightHaptic.impactOccurred()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let finalHaptic = UINotificationFeedbackGenerator()
            finalHaptic.notificationOccurred(.success)
            
            let normalizedRotation = finalRotation.truncatingRemainder(dividingBy: 360)
            let segmentAngle = 360.0 / Double(restaurants.count)
            let selectedIndex = Int((360 - normalizedRotation + segmentAngle / 2) / segmentAngle) % restaurants.count
            
            selectedRestaurant = restaurants[selectedIndex]
            
            if let selected = selectedRestaurant {
                onRestaurantSelected(selected)
            }
            
            isSpinning = false
        }
    }
}

#Preview {
    SpinningWheel(
        restaurants: [
            Restaurant.preview,
            Restaurant(
                id: "2",
                name: "Pizza Palace",
                rating: 4.2,
                address: "Address 2",
                latitude: 41.0,
                longitude: 29.0,
                placeId: "place2"
            ),
            Restaurant(
                id: "3",
                name: "Burger Joint",
                rating: 4.5,
                address: "Address 3",
                latitude: 41.0,
                longitude: 29.0,
                placeId: "place3"
            ),
            Restaurant(
                id: "4",
                name: "Sushi Bar",
                rating: 4.7,
                address: "Address 4",
                latitude: 41.0,
                longitude: 29.0,
                placeId: "place4"
            )
        ],
        onRestaurantSelected: { _ in }
    )
    .frame(height: 400)
}
