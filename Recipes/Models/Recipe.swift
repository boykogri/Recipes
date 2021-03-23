//
//  Recipe.swift
//  Recipes
//
//  Created by Григорий Бойко on 18.03.2021.
//

import Foundation
import RealmSwift


class Recipe: Object, Decodable{
    @objc dynamic var uuid: String = ""
    @objc dynamic var name: String = ""
    var images = List<String>()
    @objc dynamic var lastUpdated = Date()
    @objc dynamic var desc: String?
    @objc dynamic var instructions: String = ""
    @objc dynamic var difficulty: Int = 0
    
    convenience init(recipe: JSONRecipe) {
        self.init()
        uuid = recipe.uuid
        name = recipe.name
        
        let imgs = List<String>()
        imgs.append(objectsIn: recipe.images)
        images = imgs
        
        lastUpdated = Date(timeIntervalSince1970: TimeInterval(recipe.lastUpdated))
        desc = recipe.description
        instructions = recipe.instructions
        difficulty = recipe.difficulty
    }
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
struct Recipes: Decodable {
    let recipes: [JSONRecipe]
}
struct JSONRecipe: Decodable {
    let uuid: String
    let name: String
    let images: [String]
    let lastUpdated: Int
    let description: String?
    let instructions: String
    let difficulty: Int
}
