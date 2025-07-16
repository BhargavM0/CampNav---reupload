//
//  ContentView.swift
//  CampNav
//
//  Created by Zahir Rivas on 12/27/24
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.navigateToProfile {
                HomePageView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
