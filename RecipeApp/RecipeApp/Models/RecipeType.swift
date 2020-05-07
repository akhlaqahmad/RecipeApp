//
//  Recipe.swift
//  RecipeApp
//
//  Created by Akhlaq Ahmad on 05/05/2020.
//  Copyright © 2020 Akhlaq Ahmad. All rights reserved.
//

import RealmSwift

class RecipeType: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
