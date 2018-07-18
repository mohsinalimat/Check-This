//
//  CategoryColorHex.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/16/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import Foundation

enum CategoryColorHex: String {
    case normalRed = "#d64541"
    case lightRed = "#ef9a9a"
    case pink = "#d2527f"
    case lightPink = "#f48fb1"
    case purple = "#9b59b6"
    case lightPurple = "#ce93d8"
    case deepPurple = "#7e57c2"
    case lightDeepPurple = "#b39ddb"
    case blue = "#2196f3"
    case lightBlue = "#90caf9"
    case cyan = "#00bcd4"
    case lightCyan = "#80deea"
    case teal = "#009688"
    case lightTeal = "#80cbc4"
    case green = "#4caf50"
    case lightGreen = "#aed581"
    case lime = "#3fc380"
    case lightLime = "#e6ee9c"
    case yellow = "#ffeb3b"
    case lightYellow = "#fff59d"
    case amber = "#ffc107"
    case lightAmber = "#ffe082"
    case orange = "#ff9800"
    case lightOrange = "#ffcc80"
    case deepOrange = "#ff5722"
    case lightDeepOrange = "#ffab91"
    case brown = "#cd853f"
    case lightBrown = "#f4a460"
    case blueGray = "#78909c"
    case lightBlueGray = "#cfd8dc"
    
    static func random() -> CategoryColorHex {
        let randomIndex = Int(arc4random_uniform(UInt32(Utilities.allColors.count)))
        return Utilities.allColors[randomIndex]
    }
}
