//
//  Item.swift
//  Do This
//
//  Created by Luis M Gonzalez on 6/20/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name = ""
    @objc dynamic var done = false
    @objc dynamic var timeCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
