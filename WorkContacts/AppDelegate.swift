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
        
        #if DEBUG
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else {
          return true
        }
        #endif

        setAppearance()

        window = UIWindow()
        window?.makeKeyAndVisible()

        coordinator = AppCoordinator()
        coordinator?.startCoordinatorFlow()

        return true
    }
}

