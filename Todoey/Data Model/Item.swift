//
//  Item.swift
//  Todoey
//
//  Created by Wesley House on 6/26/19.
//  Copyright © 2019 Wesley House. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var dateCreated : Date?
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
