//
//  AppDelegate.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: Coordinator?

    private func setAppearance() {
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = .systemYellow
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setAppearance()

        window = UIWindow()
        window?.makeKeyAndVisible()

        coordinator = AppCoordinator()
        coordinator?.startCoordinatorFlow()

        return true
    }
}

