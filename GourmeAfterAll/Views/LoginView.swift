//
//  LoginView.swift
//  GourmeAfterAll
//
//  Created by Murat Cagri Ozkan on 22.02.2026.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var authManager = AuthManager.shared
    
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var errorMessage: String?
    @State private var showError = false
    
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
                    VStack(spacing: 30) {
                        logoSection
                        
                        loginForm
                        
                        guestButton
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
            .alert("Hata", isPresented: $showError) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Bir hata oluştu")
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
            .onAppear {
                authManager.setModelContext(modelContext)
            }
        }
    }
    
    private var logoSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("GourmeAfterAll")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Nerede Yesem?")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 40)
    }
    
    private var loginForm: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("E-posta")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("ornek@email.com", text: $email)
                    .textFieldStyle(.plain)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Şifre")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                SecureField("••••••••", text: $password)
                    .textFieldStyle(.plain)
                    .textContentType(.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            
            Button(action: handleLogin) {
                if authManager.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Giriş Yap")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [.orange, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(authManager.isLoading)
            
            Button(action: { showRegister = true }) {
                Text("Hesabınız yok mu? **Kayıt Olun**")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
        }
    }
    
    private var guestButton: some View {
        Button(action: {
            authManager.continueAsGuest()
            dismiss()
        }) {
            HStack {
                Image(systemName: "person.fill.questionmark")
                Text("Misafir Olarak Devam Et")
                    .fontWeight(.medium)
            }
            .foregroundColor(.secondary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private func handleLogin() {
        Task {
            do {
                try await authManager.login(email: email, password: password)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

#Preview {
    LoginView()
        .modelContainer(for: [User.self, Restaurant.self], inMemory: true)
}