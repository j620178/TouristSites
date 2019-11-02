//
//  ViewController.swift
//  TouristSites
//
//  Created by littlema on 2019/10/31.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundGray
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.registerWithNib(identifier: TouristSiteCell.identifier)
        return tableView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupBinding()
        
        viewModel.fetchData()
    }
    
    func setupView() {
        title = "台北市熱門景點"
        view.backgroundColor = .backgroundGray
        
        view.addSubview(tableView)
        tableView.addConstrainSameWith(self.view)
        
        view.addSubview(indicatorView)
        indicatorView.addConstraintCenterXYOf(self.view)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    func setupBinding() {
        viewModel.cellViewModels.addObserver { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.isTableViewHidden.addObserver { [weak self] (isHidden) in
            self?.tableView.isHidden = isHidden
        }
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.indicatorView.startAnimating()
            } else {
                self?.indicatorView.stopAnimating()
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModelsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TouristSiteCell.identifier, for: indexPath)
        
        guard let touristSiteCell = cell as? TouristSiteCell else { return cell }
        
        let cellViewModel = viewModel.getViewModel(index: indexPath.row)
                        
        touristSiteCell.viewModel = cellViewModel
        
        let detailCellViewModel = viewModel.getDetailViewModel(index: indexPath.row)
        
        touristSiteCell.tapCollectionViewCellHandler = { [weak self] _ in
            let nextVC = DetailViewController(viewModel: detailCellViewModel)
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        touristSiteCell.photoCollectionView.reloadData()
        
        return touristSiteCell
    }
    
}

