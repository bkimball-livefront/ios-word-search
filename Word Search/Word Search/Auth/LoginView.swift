//
//  LoginView.swift
//  Word Search
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    let onSignedIn: () -> Void

    var body: some View {
        VStack {
            Spacer()

            Text("Word Search")
                .font(.title)
                .fontWeight(.bold)

            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.top, 16)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .padding(.top, 8)

            Button("Sign in", action: onSignedIn)
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canSignIn)
                .frame(maxWidth: .infinity)
                .padding(.top, 24)

            Button("Continue as guest", action: onSignedIn)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            Spacer()
        }
        .padding(24)
    }
}

#Preview {
    LoginView(onSignedIn: {})
}
