//
//  AppDelegate.swift
//  CampNav
//
//  Created by Zahir Rivas on 12/27/24.
//

import SwiftUI
import Firebase


@main
struct CampNav: App {
    @StateObject var viewModel = AuthViewModel()
    
    init () {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}



