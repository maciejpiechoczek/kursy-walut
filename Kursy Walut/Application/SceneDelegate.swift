//
//  SceneDelegate.swift
//  Kursy Walut
//
//  Created by Maciej Piechoczek on 07/02/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let viewController = CurrenciesRatesViewController()
        viewController.fetchData()
        let navigationController = UINavigationController(rootViewController: viewController)

        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
