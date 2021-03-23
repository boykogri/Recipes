//
//  HorizontalCell.swift
//  Recipes
//
//  Created by Григорий Бойко on 23.03.2021.
//

import UIKit

class HorizontalCell: UICollectionViewCell {
    
    private var viewModel: HorizontalCellVM?
    private let factory = UIFactory()
    
    private lazy var recipeImage: UIImageView = {
        let img = factory.createImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private lazy var nameLabel: UILabel = {
        let lb = factory.createLabel()
        lb.font = factory.getStandardFont(for: .title)
        lb.numberOfLines = 4
        return lb
    }()
    

    func setup(with viewModel: HorizontalCellVM){
        self.viewModel = viewModel
        setupUI()
        nameLabel.text = viewModel.name
        let url = URL(string: viewModel.image)
        recipeImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "recipePlaceholder"))
        
    }
    func setupUI(){
        addSubview(recipeImage)
        addSubview(nameLabel)
        
        recipeImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(100)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(recipeImage.snp.bottom).offset(5)
            make.left.right.equalTo(recipeImage)
        }
        nameLabel.sizeToFit()
    }
    
}
