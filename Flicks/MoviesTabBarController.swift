//
//  MoviesTabBarController.swift
//  Flicks
//
//  Created by Myadam, Sasikiran on 10/25/16.
//  Copyright © 2016 Myadam, Sasikiran. All rights reserved.
//

import UIKit

class MoviesTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let controllers = viewControllers as? [UINavigationController] {
            for (index, navigationController) in controllers.enumerate() {
                if let moviesController = navigationController.topViewController as? MoviesViewController {
                    if index == 0 {
                        moviesController.endpoint = "now_playing"
                    } else {
                        moviesController.endpoint = "top_rated"
                    }
                }
            }
        }
    }
}
