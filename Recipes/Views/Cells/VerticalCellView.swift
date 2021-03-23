//
//  RecipeTableViewCell.swift
//  Recipes
//
//  Created by Григорий Бойко on 18.03.2021.
//

import UIKit
import SnapKit
import Kingfisher

class VerticalCellView: UITableViewCell {
    
    private var viewModel: VerticalCellVM?
    private let factory = UIFactory()
    
    private lazy var recipeImage: UIImageView = {
        return factory.createImageView()
    }()
    
    private lazy var nameLabel: UILabel = {
        let lb = factory.createLabel()
        lb.font = factory.getStandardFont(for: .title)
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let lb = factory.createLabel()
        lb.font = factory.getStandardFont(for: .secondary)
        lb.textColor = .darkGray
        lb.numberOfLines = 2
        return lb
    }()
    
    private lazy var difficultyLabel: UILabel = {
        let lb = factory.createLabel()
        lb.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return lb
    }()
    
    
    private lazy var descriptionStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .leading
        sv.spacing = 3
        [nameLabel,
         difficultyLabel,
         descriptionLabel].forEach { sv.addArrangedSubview($0) }
        return sv
    }()
    
    
    func setup(with viewModel: VerticalCellVM){
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.desc
        difficultyLabel.text = "Difficulty: \(String.init(repeating: "⭐️", count: viewModel.diff))"
        let url = URL(string: viewModel.image)
        recipeImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "recipePlaceholder"))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){

        contentView.addSubview(recipeImage)
        contentView.addSubview(descriptionStack)

        recipeImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.height.equalTo(75)
            make.width.equalTo(75)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
            make.top.equalToSuperview().offset(5)

        }
        descriptionStack.snp.makeConstraints { (make) in
            make.left.equalTo(recipeImage.snp.right).offset(15)
            make.right.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
            make.top.equalTo(recipeImage)
        }
    }
}
