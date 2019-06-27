//
//  Category.swift
//  Todoey
//
//  Created by Wesley House on 6/26/19.
//  Copyright © 2019 Wesley House. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var randomColor : String = ""
    let items = List<Item>()
}
