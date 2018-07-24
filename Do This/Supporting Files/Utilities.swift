//
//  Utilities.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/14/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit

struct Utilities {
    
    // The colorOptions array of hex values represent the 6x5 matrix of the
    // colored buttons in the ColorPickerViewController.
    static let colorOptions = ["#d64541", "#d2527f", "#9b59b6", "#7e57c2", "#2196f3",
                               "#ef9a9a", "#f48fb1", "#ce93d8", "#b39ddb", "#90caf9",
                               "#00bcd4", "#009688", "#4caf50", "#3fc380", "#ffeb3b",
                               "#80deea", "#80cbc4", "#aed581", "#e6ee9c", "#fff59d",
                               "#ffc107", "#ff9800", "#ff5722", "#cd853f", "#78909c",
                               "#ffe082", "#ffcc80", "#ffab91", "#f4a460", "#cfd8dc"]

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
