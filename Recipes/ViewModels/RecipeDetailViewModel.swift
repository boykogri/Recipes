//
//  RecipeDetailViewModel.swift
//  Recipes
//
//  Created by Григорий Бойко on 19.03.2021.
//

import Foundation
import RealmSwift

class RecipeDetailViewModel {
    var recipe: Recipe!
    var recipes = Observable<Results<Recipe>>(
        StorageManager.getAllRecipes()
            .sorted(byKeyPath: "name", ascending: true)
    )
    func prepareText(_ text: String) -> String{
        return text.replacingOccurrences(of: "<br>", with: "\n")
    }
    func getCellVM(for recipe: Recipe) -> HorizontalCellVM {
        let vm = HorizontalCellVM(name: recipe.name,
                               image: recipe.images.first ?? "")
        return vm
    }
    func getSameRecipes(){
        recipes.value = StorageManager.getSameRecipes(for: recipe)
    }
    func getRecipeDetailVM(for index: Int) -> RecipeDetailViewModel {
        let r = recipes.value?[index]
        let vm = RecipeDetailViewModel()
        vm.recipe = r
        return vm
    }
    
}
