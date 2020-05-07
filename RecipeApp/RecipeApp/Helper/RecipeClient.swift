//
//  RecipeClient.swift
//  RecipeApp
//
//  Created by Akhlaq Ahmad on 05/05/2020.
//  Copyright © 2020 Akhlaq Ahmad. All rights reserved.
//

import Foundation
import SWXMLHash

class RecipeClient {
    
    var recipeTypes = [RecipeType]()
    
    var realmManager = DatabaseManager.shared
    
    func loadRecipeTypes() {
        if let results = realmManager.fetch(RecipeType.self) {
            if results.isEmpty {
                loadRecipeTypesFromBundle()
            } else {
                recipeTypes = Array(results)
            }
        }
    }
    
    func loadRecipes() {
        if let results = realmManager.fetch(Recipe.self), results.isEmpty {
            loadRecipesFromBundle()
        }
    }
    
    func fetchRecipes(of type: String = "") -> [Recipe] {
        var recipes = [Recipe]()
        if type.isEmpty {
            if let results = realmManager.fetch(Recipe.self) {
                recipes = Array(results)
            }
        } else {
            if let results = realmManager.fetch(Recipe.self, predicate: NSPredicate(format: "type == %@", type)) {
                recipes = Array(results)
            }
        }
        return recipes
    }
    
    func addRecipe(_ recipe: Recipe) {
        try? realmManager.create(Recipe.self, completion: { newRecipe in
            newRecipe.name        = recipe.name
            newRecipe.type        = recipe.type
            newRecipe.ingredients = recipe.ingredients
            newRecipe.steps       = recipe.steps
        })
    }
    
    func updateRecipe(_ recipe: Recipe) {
//        try? realmManager.update {
//            
//        }
//        save(object: recipe, completion: { error in
//            debugPrint(error?.localizedDescription ?? "Something went wrong.")
//        })
    }
    
    private func loadRecipeTypesFromBundle() {
        guard let path = Bundle.main.path(forResource: "recipetypes", ofType: "xml") else { return }
        
        
        let xmlContent = try! String(contentsOfFile: path)
        let xml = SWXMLHash.parse(xmlContent)
        
        
        // enumerate child Elements in the parent Element
        for elem in xml["recipetypes"]["recipetype"].all {
            try? realmManager.create(RecipeType.self) { [weak self] recipeType in
                guard let self = self else { return }
                recipeType.name = elem["name"].element!.text
                self.recipeTypes.append(recipeType)
            }
        }
    }
    
    private func loadRecipesFromBundle() {
        guard let path = Bundle.main.path(forResource: "recipes", ofType: "xml") else { return }
        
        
        let xmlContent = try! String(contentsOfFile: path)
        let xml = SWXMLHash.parse(xmlContent)
        
        for elem in xml["recipes"]["recipe"].all {
            
            let type = elem["type"].element!.text
            let name = elem["name"].element!.text
            let ingredients = elem["ingredients"].element!.text
            let steps = elem["steps"].element!.text
            let imageUrl = elem["image_url"].element!.text
            
            try? realmManager.create(Recipe.self) { recipe in
                recipe.name = name
                recipe.type = type
                recipe.ingredients = ingredients
                recipe.steps = steps
                recipe.imageUrl = imageUrl
            }
        }
    }
    
    
}
