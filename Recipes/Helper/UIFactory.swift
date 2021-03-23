//
//  UIFactory.swift
//  Recipes
//
//  Created by Григорий Бойко on 21.03.2021.
//

import UIKit

class UIFactory {
    
    func getStandardFont(for font: FontCases) -> UIFont{
        switch font {
        case .h1:
            return UIFont.systemFont(ofSize: 24, weight: .medium)
        case .h2:
            return UIFont.systemFont(ofSize: 20, weight: .medium)
        case .title:
            return UIFont.systemFont(ofSize: 17, weight: .medium)
        case .paragraph:
            return UIFont.systemFont(ofSize: 17, weight: .regular)
        case .secondary:
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .form:
            return UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
    }
    func createStackView(_ axis: NSLayoutConstraint.Axis) -> UIStackView{
        let sv = UIStackView()
        sv.axis = axis
        sv.distribution = .fill
        switch axis {
        case .horizontal:
            sv.alignment = .top
        case .vertical:
            sv.alignment = .leading
        }
        sv.alignment = .leading
        sv.spacing = 5
        return sv
    }
    func createLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = .left
        return label
    }
    func createImageView() -> UIImageView{
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
}
enum FontCases {
    case h1, h2, title, paragraph, secondary, form
}
