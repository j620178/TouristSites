//
//  ViewController.swift
//  TouristSites
//
//  Created by littlema on 2019/10/31.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Network

enum MainViewState {
    case normal
    case empty
    case loading
    case loadMore
    case apiError
    case internetError
    case initInternetError
}

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
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        let indicatorView = UIActivityIndicatorView(style: .medium)
        view.addSubview(indicatorView)
        indicatorView.addConstraintCenterXYOf(view)
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        return view
    }()
        
    lazy var errorDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = .stringGray
        return label
    }()
    
    let viewModel: MainViewModel
    
    let monitor = NWPathMonitor()
    
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
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.viewModel.fetchData()
            } else {
                if self?.viewModel.numberOfCellViewModels == 0 {
                    self?.viewModel.state.value = .initInternetError
                } else {
                    self?.viewModel.state.value = .internetError
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    func setupView() {
        title = "台北市熱門景點"
        view.backgroundColor = .backgroundGray
        
        view.addSubview(tableView)
        tableView.addConstrainSameWith(self.view)
        tableView.tableFooterView = footerView
        
        view.addSubview(indicatorView)
        indicatorView.addConstraintCenterXYOf(self.view)
        
        view.addSubview(errorDescLabel)
        errorDescLabel.addConstraintCenterXYOf(self.view)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    func setupBinding() {
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
                case .normal:
                    self?.tableView.isHidden = false
                    self?.errorDescLabel.isHidden = true
                    self?.indicatorView.isHidden = true
                case .empty:
                    self?.tableView.isHidden = true
                    self?.errorDescLabel.isHidden = false
                    self?.errorDescLabel.text = "尚無資料"
                    self?.indicatorView.isHidden = true
                case .loading:
                    self?.tableView.isHidden = true
                    self?.indicatorView.isHidden = false
                case .loadMore:
                    break
                case .apiError:
                    self?.tableView.isHidden = true
                    self?.errorDescLabel.isHidden = false
                    self?.errorDescLabel.text = "系統發生異常"
                    self?.indicatorView.isHidden = true
                case .internetError:
                    self?.tableView.isHidden = false
                    self?.errorDescLabel.isHidden = true
                    self?.indicatorView.isHidden = true
                    let alert = UIAlertController(title: "無法連線", message: "請確認網路連線狀態", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self?.present(alert, animated: true, completion: nil)
                case .initInternetError:
                    self?.tableView.isHidden = true
                    self?.errorDescLabel.isHidden = false
                    self?.errorDescLabel.text = "網路連線異常"
                    self?.indicatorView.isHidden = true
                }
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
