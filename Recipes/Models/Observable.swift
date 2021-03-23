//
//  Bindable.swift
//  Recipes
//
//  Created by Григорий Бойко on 18.03.2021.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    convenience init(_ value: T) {
        self.init()
        self.value = value
    }
    var observer: ((T?) -> ())?
    //Метод в котором мы указываем, что делать, когда данные изменились
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
