//
//  Category.swift
//  Todoey
//
//  Created by Roro on 5/9/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""

    let items = List<Item>()
//  List is the container type in Realm used to define to-many relationships.

    
}
