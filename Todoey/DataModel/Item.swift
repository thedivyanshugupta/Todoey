//
//  Item.swift
//  Todoey
//
//  Created by Roro on 5/9/22.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
//  LinkingObjects is an auto-updating container type. It represents zero or more objects that are linked to its owning model object through a property relationship.
}
