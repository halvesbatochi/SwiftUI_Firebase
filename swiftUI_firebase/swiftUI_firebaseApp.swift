//
//  swiftUI_firebaseApp.swift
//  swiftUI_firebase
//
//  Created by Henrique Alves Batochi on 16/12/25.
//

import SwiftUI
import Firebase

@main
struct swiftUI_firebaseApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    return true
  }
}
