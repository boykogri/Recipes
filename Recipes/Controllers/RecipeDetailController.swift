//
//  RecipeDetailController.swift
//  Recipes
//
//  Created by Григорий Бойко on 19.03.2021.
//

import UIKit
import Kingfisher

class RecipeDetailController: UIViewController {
    
    private let viewModel: RecipeDetailViewModel
    private let factory = UIFactory()
    
    //MARK: - UI Elements
    private lazy var slider: UIScrollView = {
        let c = UIScrollView()
        c.isPagingEnabled = true
        c.delegate = self
        c.showsHorizontalScrollIndicator = false
        return c
    }()
    
    private lazy var imageView: UIImageView = {
        let imgView = factory.createImageView()
        return imgView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = factory.createStackView(.vertical)
        sv.addArrangedSubview(diffLabel)
        if let descTV = descTextView {
            sv.addArrangedSubview(descTV)
        }
        [instLabel,
         instTextView,
        sameRecipesLabel].forEach { sv.addArrangedSubview($0) }
        return sv
    }()
    
    private var descTextView: UITextView?
    
    private lazy var diffLabel: UILabel = {
        let label = factory.createLabel()
        label.font = factory.getStandardFont(for: .title)
        label.text = "Difficulty: \(String.init(repeating: "⭐️", count: viewModel.recipe.difficulty))"
        return label
    }()
    
    private lazy var instLabel: UILabel = {
        let label = factory.createLabel()
        label.font = factory.getStandardFont(for: .h2)
        label.text = "Instructions"
        return label
    }()
    
    private lazy var sameRecipesLabel: UILabel = {
        let label = factory.createLabel()
        label.font = factory.getStandardFont(for: .h2)
        label.text = "Recipes with the same difficulty"
        return label
    }()
    
    private lazy var instTextView: UITextView = {
        let tv = UITextView()
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        tv.textAlignment = .left
        tv.font = factory.getStandardFont(for: .paragraph)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    private lazy var pager: UIPageControl = {
        let p = UIPageControl()
        p.hidesForSinglePage = true
        p.isUserInteractionEnabled = false
        return p
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HorizontalCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    //MARK: - Init
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let inst = viewModel.recipe.instructions
        instTextView.text = viewModel.prepareText(inst)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupUI()
        bindWithVM()
        viewModel.getSameRecipes()
    }
    private func bindWithVM(){
        viewModel.recipes.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    private func setupUI(){
        view.backgroundColor = .systemBackground
        title = viewModel.recipe.name
        if let desk = viewModel.recipe.desc, desk != "" {
            self.setupDescTV(with: desk)
        }
        setupCarousel()
        setupConstraints()
    }

    private func setupDescTV(with text: String){
        descTextView = UITextView()
        descTextView!.text = text
        descTextView!.textAlignment = .left
        descTextView!.font = factory.getStandardFont(for: .secondary)
        descTextView!.textColor = .darkGray
        descTextView!.isScrollEnabled = false
        descTextView!.isEditable = false
        descTextView!.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    private func setupCarousel(){
        let h = 250
        let width = Int(UIScreen.main.bounds.width)

        let count = viewModel.recipe.images.count

        for i in 0..<count {
            // горизонтальный отступ, кол-во фото*длина
            let offset = i == 0 ? 0 : (i * width)
            let imgView = UIImageView(frame: CGRect(x: offset, y: 0, width: width, height: h))
            imgView.contentMode = .scaleAspectFill
            imgView.image = #imageLiteral(resourceName: "recipePlaceholder")
            let url = URL(string: viewModel.recipe.images[i])
            imgView.kf.setImage(with: url)
            slider.addSubview(imgView)
        }
        pager.numberOfPages = count
        slider.contentSize = CGSize(width: count * width, height: h)
    }
    //MARK: - Constraints
    private func setupConstraints(){
        view.addSubview(slider)
        view.addSubview(scrollView)
        view.addSubview(pager)
        
        scrollView.addSubview(stackView)
        scrollView.addSubview(collectionView)
        
        slider.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(250)
        }
        pager.snp.makeConstraints { (make) in
            make.bottom.equalTo(slider)
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp.bottom).offset(5)
            make.right.left.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-5)
            make.left.equalTo(view).offset(5)
            make.top.equalTo(scrollView).offset(5)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(12)
            make.height.equalTo(200)
            make.centerX.equalTo(view)
            make.width.equalTo(stackView)
        }
        stackView.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: stackView.frame.height + collectionView.frame.height + 17)
        
    }

}
//MARK: - UIScrollViewDelegate
extension RecipeDetailController: UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == slider{
            let x = scrollView.contentOffset.x
            let w = scrollView.bounds.size.width
            pager.currentPage = Int(ceil(x/w))
        }
        
    }

}
//MARK: - UICollectionViewDelegates
extension RecipeDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = viewModel.getRecipeDetailVM(for: indexPath.item)
        let vc = RecipeDetailController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension RecipeDetailController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = viewModel.recipes.value?.count {
            return count
        }else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HorizontalCell
        if let recipe = viewModel.recipes.value?[indexPath.item]{
            cell.setup(with: viewModel.getCellVM(for: recipe))
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2.5 - 10, height: 200)
    }
    
}
