//
//  Utilities.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/14/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

struct Utilities {
    
    static let allColors: [CategoryColorHex] = [.normalRed,
                                                .lightRed,
                                                .pink,
                                                .lightPink,
                                                .purple,
                                                .lightPurple,
                                                .deepPurple,
                                                .lightDeepPurple,
                                                .blue,
                                                .lightBlue,
                                                .cyan,
                                                .lightCyan,
                                                .teal,
                                                .lightTeal,
                                                .green,
                                                .lightGreen,
                                                .lime,
                                                .lightLime,
                                                .yellow,
                                                .lightYellow,
                                                .amber,
                                                .lightAmber,
                                                .orange,
                                                .lightOrange,
                                                .deepOrange,
                                                .lightDeepOrange,
                                                .brown,
                                                .lightBrown,
                                                .blueGray,
                                                .lightBlueGray]
    
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
