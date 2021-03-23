//
//  CellViewModel.swift
//  Recipes
//
//  Created by Григорий Бойко on 20.03.2021.
//

import Foundation

class VerticalCellVM {
    let name: String
    let desc: String
    let diff: Int
    let image: String
    
    init(name: String, desc: String, diff: Int, image: String) {
        self.name = name
        self.desc = desc
        self.diff = diff
        self.image = image
    }
}
