//
//  ViewController.swift
//  Recipes
//
//  Created by Григорий Бойко on 16.03.2021.
//

import UIKit
import SnapKit
import Kingfisher

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let cellId = "RecipeCell"
    private let viewModel = RecipesViewModel()

    private lazy var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let searchController = UISearchController(searchResultsController: nil)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.recipes.value?.count == 0{
            loadingIndicator.startAnimating()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.viewModel.fetchRecipes()
            self.loadingIndicator.stopAnimating()
        }
        
    }

    override func loadView() {
        super.loadView()
        
        setupUI()
        bindToViewModel()
    }
    
    func bindToViewModel(){
        
        viewModel.recipes.bind { [weak self] (recipes) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.ascendingImage.bind { [weak self] (image) in
            DispatchQueue.main.async {
                self?.navigationItem.rightBarButtonItem?.image = image
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Setup UI
    func setupUI(){
        title = "Recipes"
        setupTableView()
        setupNavigationController()
        setupSearchBar()
        setupIndicator()
    }
    func setupNavigationController(){
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "AZ"), style: .plain, target: self, action: #selector(ascendingTapped))
    }
    func setupTableView(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        tableView.register(VerticalCellView.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Type something to find a recipe"
        searchController.searchBar.scopeButtonTitles = ["Name", "Date"]
        searchController.searchBar.showsScopeBar = true
    }
    func setupIndicator(){

        loadingIndicator.color = .lightGray
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }


    }
    
}
//MARK: - UITableViewDelegate
extension MainController {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vm = viewModel.getRecipeDetailVM(for: indexPath.row)
        let vc = RecipeDetailController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)       
    }
}
//MARK: - UITableViewDataSource
extension MainController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let c = viewModel.recipes.value?.count else { return 0 }
        return c
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! VerticalCellView
        if let recipe = viewModel.recipes.value?[indexPath.row]{
            let vm = viewModel.getCellVM(for: recipe)
            cell.setup(with: vm)
        }
        return cell
    }
}
//MARK: - UISearchBarDelegate
extension MainController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchRecipes(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelButtonClicked()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel.scopeBarChanged(selectedScope)
        viewModel.searchRecipes(with: searchBar.text ?? "" )
    }
}
extension MainController{
    @objc func ascendingTapped(){
        viewModel.ascendingTapped()
    }
}
