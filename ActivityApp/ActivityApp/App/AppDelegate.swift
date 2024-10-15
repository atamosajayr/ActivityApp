//
//  AppDelegate.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/12/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let activityVC = ActivityViewController()
        let navigationController = UINavigationController(rootViewController: activityVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

