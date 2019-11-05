//
//  ViewController.swift
//  TouristSites
//
//  Created by littlema on 2019/10/31.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

enum MainViewState: Equatable {
    case normal(isEnd: Bool)
    case empty
    case loading(isLoadMore: Bool)
    case apiError
    case internetError(isInit: Bool)
}

protocol MainViewControllerCoordinatorDelegate: AnyObject {
    func showDetailFrom(_ viewController: UIViewController, viewModel: DetailViewModel)
}

class MainViewController: UIViewController {
    
    weak var coordinator: MainViewControllerCoordinatorDelegate?
    
    let viewModel: MainViewModel
    
    let monitor = NetworkMonitor()
        
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundGray
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerWithNib(identifier: MainTableViewCell.identifier)
        return tableView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        view.addSubview(indicatorView)
        indicatorView.addConstraintCenterXYOf(view)
        indicatorView.startAnimating()
        return view
    }()
        
    lazy var errorDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = .stringGray
        return label
    }()
    
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
        
        setupInternetListening()
    }
    
    private func setupView() {
        title = "台北市熱門景點"
        view.backgroundColor = .backgroundGray
        
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.backBarButtonItem?.title = ""
        
        view.addSubview(tableView)
        tableView.addConstrainSameWith(self.view)
        tableView.tableFooterView = footerView
        
        view.addSubview(indicatorView)
        indicatorView.addConstraintCenterXYOf(self.view)
        
        view.addSubview(errorDescLabel)
        errorDescLabel.addConstraintCenterXYOf(self.view)
    }

    private func setupBinding() {
        
        viewModel.cellViewModels.addObserver { [weak self] (newViewModels, oldViewModels) in
            
            var indexPaths = [IndexPath]()
            for index in oldViewModels.count..<newViewModels.count {
                indexPaths.append(IndexPath(row: index, section: 0))
            }
            self?.tableView.insertRows(at: indexPaths, with: .automatic)
        }
        
        viewModel.state.addObserver { [weak self] state in
            
            DispatchQueue.main.async {
                
                switch state {
                case .normal(let isEnd):
                    self?.showTableView(isEnd: isEnd)
                case .empty:
                    self?.showInfoLabel(text: "尚無資料...")
                case .loading(let isLoadMore):
                    isLoadMore ? nil : self?.showIndicator()
                case .apiError:
                    self?.showInfoLabel(text: "系統發生異常...")
                case .internetError(let isInit):
                    if isInit {
                        self?.showInfoLabel(text: "網路連線異常...")
                    } else {
                        self?.showAlertController(title: "網路無法連線...", message: "請確認網路環境！")
                    }
                }
            }
        }
    }
    
    private func setupInternetListening() {
        monitor.startMonitoring { [weak self] (connection, reachable) in
            if reachable == .yes {
                self?.viewModel.fetchData()
            } else {
                let isInit = self?.viewModel.numberOfCellViewModels == 0
                self?.viewModel.state.value = .internetError(isInit: isInit)
            }
        }
        viewModel.fetchData()
    }
    
    private func showTableView(isEnd: Bool) {
        tableView.isHidden = false
        errorDescLabel.isHidden = true
        indicatorView.isHidden = true
        footerView.isHidden = isEnd
    }
    
    private func showInfoLabel(text: String) {
        tableView.isHidden = true
        errorDescLabel.isHidden = false
        errorDescLabel.text = text
        indicatorView.isHidden = true
    }
    
    private func showIndicator() {
        tableView.isHidden = true
        errorDescLabel.isHidden = true
        indicatorView.isHidden = false
    }
    
    private func showAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfCellViewModels
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath)
        
        guard let touristSiteCell = cell as? MainTableViewCell else { return cell }
        
        let cellViewModel = viewModel.getViewModel(index: indexPath.row)
                        
        touristSiteCell.viewModel = cellViewModel
        
        let detailViewModel = viewModel.getDetailViewModel(index: indexPath.row)
        
        touristSiteCell.tapCollectionViewCellHandler = { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.coordinator?.showDetailFrom(strongSelf, viewModel: detailViewModel)
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
