//
//  Login.swift
//  People Management System
//
//  Created by Megan Lin on 3/29/24.
//

import SwiftUI

struct Login: View {
    @Environment(ModelData.self) var modelData
    
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State var showPassword: Bool = false
    
    var isSignInButtonDisabled: Bool {
        [username, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                Text("Login")
                    .font(.custom("Helvetica Neue", size: 40))
                    .bold()
                
                Spacer()

                TextField("NetID",text: $username)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue, lineWidth: 2)
                    }
                    .frame(height: 40)
                    .frame(width: 300)
                    .padding(.horizontal)
                           
                HStack {
                    Group {
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.red, lineWidth: 2)
                    }

                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.red) // how to change image based in a State variable
                    }

                }
                .frame(height: 40)
                .frame(width: 300)
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    // Perform login logic
                    if (username == "admin" && password == "admin") || modelData.DukePeople.values.map({$0.netID}).contains(username)  {
                        isLoggedIn = true
                        saveCredentials(username: username, password: password)
                    } else {
                        // Show error message or handle invalid credentials
                        print("Invalid credentials")
                    }
                } label: {
                    Text("LOGIN")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                    .frame(height: 50)
                    .frame(width: 300)
                    .background(
                        isSignInButtonDisabled ?
                        LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .disabled(isSignInButtonDisabled) // how to disable while some condition is applied
                    .padding()
                            
                Spacer()
            }
                .padding()
        }
    }
    
    private func saveCredentials(username: String, password: String) {
        let authStr = "\(username):\(password)"
        UserDefaults.standard.set(authStr, forKey: "AuthString")
    }
}

#Preview {
    Login(isLoggedIn: .constant(false))
        .environment(ModelData())
}
