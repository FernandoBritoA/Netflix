//
//  ViewController.swift
//  Netflix
//
//  Created by Fernando Brito on 04/08/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tabBar.tintColor = .label

        // We need to create a navigation-controller for each tab to allow navigation
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())

        // These icons are from SF Symbols
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")

        vc1.title = K.Home.title
        vc2.title = K.Upcoming.title
        vc3.title = K.Search.title
        vc4.title = K.Downloads.title

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        self.selectedIndex = 2
    }
}
