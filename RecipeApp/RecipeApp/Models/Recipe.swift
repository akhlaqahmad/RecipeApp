//
//  Recipe.swift
//  RecipeApp
//
//  Created by Akhlaq Ahmad on 05/05/2020.
//  Copyright © 2020 Akhlaq Ahmad. All rights reserved.
//

import RealmSwift

class Recipe: Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var ingredients = ""
    @objc dynamic var steps = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var type = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
