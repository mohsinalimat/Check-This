//
//  Utilities.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/14/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

class Utilities {
    
    static func setUpBlueNavBarFor(_ viewController: UIViewController) {
        let whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if let navBar = viewController.navigationController?.navigationBar {
            navBar.barTintColor = UIColor(hexString: "0096FF")!
            navBar.tintColor = UIColor.white
            navBar.largeTitleTextAttributes = whiteAttribute
            navBar.titleTextAttributes = whiteAttribute
        }
    }
    
}
