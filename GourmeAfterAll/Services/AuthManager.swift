//
//  AuthManager.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import Foundation
import SwiftData

@Observable
final class AuthManager {
    static let shared = AuthManager()
    
    private(set) var currentUser: User?
    private(set) var isAuthenticated = false
    private(set) var isLoading = false
    
    private var modelContext: ModelContext?
    
    private init() {
        loadSavedUser()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func loadSavedUser() {
        if let savedUserId = UserDefaults.standard.string(forKey: "currentUserId") {
            isAuthenticated = true
        }
    }
    
    func login(email: String, password: String) async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        
        isLoading = true
        
        try? await Task.sleep(for: .seconds(1))
        
        guard let modelContext = modelContext else {
            isLoading = false
            throw AuthError.systemError
        }
        
        let fetchDescriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { user in
                user.email == email
            }
        )
        
        if let existingUser = try? modelContext.fetch(fetchDescriptor).first {
            currentUser = existingUser
            isAuthenticated = true
            UserDefaults.standard.set(existingUser.id, forKey: "currentUserId")
        } else {
            throw AuthError.userNotFound
        }
        
        isLoading = false
    }
    
    func register(email: String, password: String, name: String) async throws {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            throw AuthError.invalidInput
        }
        
        guard email.contains("@") else {
            throw AuthError.invalidEmail
        }
        
        isLoading = true
        
        try? await Task.sleep(for: .seconds(1))
        
        guard let modelContext = modelContext else {
            isLoading = false
            throw AuthError.systemError
        }
        
        let fetchDescriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { user in
                user.email == email
            }
        )
        
        if let _ = try? modelContext.fetch(fetchDescriptor).first {
            isLoading = false
            throw AuthError.emailAlreadyExists
        }
        
        let newUser = User(id: UUID().uuidString, email: email, name: name)
        modelContext.insert(newUser)
        try? modelContext.save()
        
        currentUser = newUser
        isAuthenticated = true
        UserDefaults.standard.set(newUser.id, forKey: "currentUserId")
        
        isLoading = false
    }
    
    func continueAsGuest() {
        currentUser = User.guest
        isAuthenticated = true
        UserDefaults.standard.set("guest", forKey: "currentUserId")
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "currentUserId")
    }
    
    func addToHistory(restaurant: Restaurant) {
        guard let modelContext = modelContext, let userId = currentUser?.id else { return }
        
        let history = RestaurantHistory(
            restaurantId: restaurant.id,
            restaurantName: restaurant.name,
            userId: userId
        )
        
        modelContext.insert(history)
        try? modelContext.save()
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case userNotFound
    case emailAlreadyExists
    case invalidEmail
    case invalidInput
    case systemError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Geçersiz kullanıcı adı veya şifre"
        case .userNotFound:
            return "Kullanıcı bulunamadı"
        case .emailAlreadyExists:
            return "Bu e-posta adresi zaten kullanılıyor"
        case .invalidEmail:
            return "Geçerli bir e-posta adresi girin"
        case .invalidInput:
            return "Lütfen tüm alanları doldurun"
        case .systemError:
            return "Bir hata oluştu, lütfen tekrar deneyin"
        }
    }
}