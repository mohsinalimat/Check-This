//
//  Category.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/20/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var colorHexValue = ""
    let items = List<Item>()
}
