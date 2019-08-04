//
//  TabbarViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 11.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpTabBar()
        self.tabBar.unselectedItemTintColor = UIColor.lightGray //UIColor(hex: "ffffff")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
    }
    
    func setUpTabBar(){
        print("tab bar load")
        //self.tabBar.items?[0].image = UIImage(named: "featuredIcon")
        self.tabBar.items?[0].title = "Descover"
        
        //self.tabBar.items?[1].image = UIImage(named: "latestIcon")
        self.tabBar.items?[1].title = "Profile"
    }

}

