//
//  AppDelegate.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        if #available(iOS 13, *) {
            return true
        } else {
            let viewController = CurrenciesRatesViewController()
            viewController.fetchData()
            let navigationController = UINavigationController(rootViewController: viewController)

            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            return true
        }
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role)
    }
}
