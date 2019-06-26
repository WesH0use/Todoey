//
//  Category.swift
//  Todoey
//
//  Created by Wesley House on 6/26/19.
//  Copyright © 2019 Wesley House. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
