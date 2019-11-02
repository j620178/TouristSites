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
        tableView.delegate = self
        tableView.registerWithNib(identifier: TouristSiteCell.identifier)
        return tableView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        let indicatorView = UIActivityIndicatorView(style: .medium)
        view.addSubview(indicatorView)
        indicatorView.addConstraintCenterXYOf(view)
        indicatorView.startAnimating()
        return view
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
        
        tableView.tableFooterView = footerView
    }

    func setupBinding() {
        viewModel.cellViewModels.addObserver { [weak self] (newViewModels, oldViewModels) in
            var indexPaths = [IndexPath]()
            for index in oldViewModels.count..<newViewModels.count {
                indexPaths.append(IndexPath(row: index, section: 0))
            }
            self?.tableView.insertRows(at: indexPaths, with: .automatic)
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
        return viewModel.numberOfCellViewModels
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

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
            
            cell.alpha = 1
        })
        
        animator.startAnimation()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - UIScreen.main.bounds.height) {
 
            self.viewModel.fetchData()
        }
    }
    
}
