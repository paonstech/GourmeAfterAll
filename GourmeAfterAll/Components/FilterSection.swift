//
//  FilterSection.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import SwiftUI

struct FilterSection: View {
    @Binding var searchText: String
    @Binding var maxDistance: Double
    let onFilterChange: () -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.orange)
                
                TextField("Canınız ne çekiyor? (Kebap, Sushi...)", text: $searchText)
                    .textFieldStyle(.plain)
                    .onChange(of: searchText) { _, _ in
                        onFilterChange()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        onFilterChange()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.orange)
                    Text("Mesafe Filtresi")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(Int(maxDistance)) km")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .foregroundColor(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Maksimum Mesafe")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(maxDistance)) km")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                    
                    Slider(value: $maxDistance, in: 1...20, step: 1)
                        .tint(.orange)
                        .onChange(of: maxDistance) { _, _ in
                            onFilterChange()
                        }
                    
                    HStack {
                        Text("1 km")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("20 km")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6).opacity(0.5))
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    FilterSection(
        searchText: .constant(""),
        maxDistance: .constant(5.0),
        onFilterChange: {}
    )
}