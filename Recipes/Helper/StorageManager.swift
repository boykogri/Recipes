//
//  StorageManager.swift
//  Recipes
//
//  Created by Григорий Бойко on 22.03.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ recipe: Recipe) {
        try! realm.write {
            realm.add(recipe)
        }
    }
    
    static func deleteObject(_ recipe: Recipe){
        try! realm.write {
            realm.delete(recipe)
        }
    }
    static func getAllRecipes() -> Results<Recipe>{
        realm.objects(Recipe.self)
    }
    
    static func addOrUpdateRecipes(_ recipes: [JSONRecipe]){
        recipes.forEach { (recipe) in
            let realmRecipe = Recipe(recipe: recipe)
            try! realm.write {
                realm.add(realmRecipe, update: .all)
            }
            saveObject(realmRecipe)
        }
    }

    static func getAllRecipes(_ key: String = "name", _ ascending: Bool) -> Results<Recipe>{
        return getAllRecipes().sorted(byKeyPath: key,
                                      ascending: ascending)
    }
    static func getSameRecipes(for recipe: Recipe) -> Results<Recipe>{
        getAllRecipes().filter("difficulty == %@ && uuid != %@",
                               recipe.difficulty, recipe.uuid)
    }
}
