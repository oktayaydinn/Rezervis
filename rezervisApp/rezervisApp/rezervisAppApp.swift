//
//  rezervisAppApp.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 7.03.2025.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct rezervisAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    /*
    init() {
        FirebaseApp.configure()
    }
     */
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
