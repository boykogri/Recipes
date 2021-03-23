//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Григорий Бойко on 19.03.2021.
//

import Foundation
import UIKit
import RealmSwift

class RecipesViewModel {
    var recipes = Observable<Results<Recipe>>(
        StorageManager.getAllRecipes()
            .sorted(byKeyPath: "name", ascending: true)
    )
    var isAscending = true
    var ascendingImage = Observable<UIImage>()
    var sortedBy = "name"

    func fetchRecipes(){

        let url = URL(string: "https://test.kode-t.ru/recipes.json")!
        if let jsonData = try? Data(contentsOf: url) {
            guard let recipes = try? JSONDecoder().decode(Recipes.self, from: jsonData) else {return}
            StorageManager.addOrUpdateRecipes(recipes.recipes)
            self.recipes.value = StorageManager.getAllRecipes(sortedBy, isAscending)
        }
    }
    /// Get filtered recipes with current text of search text field or get all recipes if text field is empty
    func searchRecipes(with text: String){
        if text == "" {
            recipes.value = StorageManager.getAllRecipes(sortedBy, isAscending)
            return
        }
        let text = text.lowercased()
        recipes.value = StorageManager.getAllRecipes().filter(
                "%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@ || %K CONTAINS[cd] %@",
                "name", text, "desc", text, "instructions", text)
            .sorted(byKeyPath: sortedBy, ascending: isAscending)
    }

    /// Get view model for detail recipe controller
    func getRecipeDetailVM(for index: Int) -> RecipeDetailViewModel {
        let r = recipes.value?[index]
        let vm = RecipeDetailViewModel()
        vm.recipe = r
        return vm
    }
    
    //MARK: - Methods for cell
    /// Get view model for cell in recipes table
    func getCellVM(for recipe: Recipe) -> VerticalCellVM {
        let vm = VerticalCellVM(name: recipe.name,
                               desc: recipe.desc ?? "",
                               diff: recipe.difficulty,
                               image: recipe.images.first ?? "")
        return vm
    }

    
    //MARK: - Clicked methods
    func ascendingTapped(){
        isAscending.toggle()
        recipes.value = recipes.value?.sorted(byKeyPath: sortedBy, ascending: isAscending)
        ascendingImage.value = isAscending ? #imageLiteral(resourceName: "AZ") : #imageLiteral(resourceName: "ZA")
    }
    func cancelButtonClicked(){
        recipes.value = StorageManager.getAllRecipes(sortedBy, isAscending)
    }
    func scopeBarChanged(_ index: Int){
        sortedBy = index == 0 ? "name" : "lastUpdated"
    }

}
