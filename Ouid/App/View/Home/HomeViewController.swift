//
//  HomeViewController.swift
//  Ouid
//
//  Created by Kevin Laminto on 30/5/21.
//

import UIKit
import SwiftUI

class HomeViewController: UITabBarController {
    private struct ViewControllerWrapper {
        let vc: UIViewController
        let icon: UIImage
        let title: String
    }
    
    private let DEFAULT_VIEWS: [ViewControllerWrapper] = [
        .init(vc: EntryTableViewController(style: .insetGrouped), icon: UIImage(systemName: "heart.text.square")!, title: "Entries"),
        .init(vc: UIHostingController(rootView: AnalyticsView()), icon: UIImage(systemName: "waveform.path.ecg")!, title: "Analytics")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = createDefaultViews()
    }

    private func createDefaultViews() -> [UINavigationController] {
        var tag = 0
        var controllers = [UINavigationController]()
        
        for vc in DEFAULT_VIEWS {
            let navVC = UINavigationController(rootViewController: vc.vc)
            navVC.navigationBar.prefersLargeTitles = true
            let tabBarItem = UITabBarItem(title: vc.title, image: vc.icon, tag: tag)
            
            navVC.tabBarItem = tabBarItem
            controllers.append(navVC)
            tag += 1
        }
        
        return controllers
    }
}
