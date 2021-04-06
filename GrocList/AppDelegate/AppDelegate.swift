//
//  AppDelegate.swift
//  GrocList
//
//  Created by Shahzaib Iqbal Bhatti on 2/22/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if userLoginStatus {
            let home = MainRouter.createModule()
            let nav = UINavigationController()
            nav.viewControllers = [home]
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            
        } else {
            let home = LoginRouter.createModule()
            let nav = UINavigationController()
            nav.viewControllers = [home]
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
        return true
    }
}
