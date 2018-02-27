//
//  Category.swift
//  Todoey2
//
//  Created by Daniel Raccah on 26/02/18.
//  Copyright © 2018 Daniel Raccah. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
