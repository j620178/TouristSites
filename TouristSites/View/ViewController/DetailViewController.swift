//
//  DetailViewController.swift
//  TouristSites
//
//  Created by littlema on 2019/11/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
    
    lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.registerWithNib(identifier: DetailTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        title = viewModel.cellViewModels[0].desc
        
        view.backgroundColor = .backgroundGray
        view.addSubview(tableView)
        
        tableView.addConstrainSameWith(view)
        tableView.tableHeaderView = headerView
        
        headerView.addSubview(scrollView)
        scrollView.addConstrainSameWith(headerView)
        scrollView.addSubview(stackView)
        
        stackView.addConstrainSameWith(scrollView)
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
                
        for url in viewModel.photoURLs {
            let imageView = UIImageView()
            stackView.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .backgroundGray
            imageView.loadFrom(url: url)
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath)
        
        guard let detailCell = cell as? DetailTableViewCell else { return cell }
        
        detailCell.cellViewModel = viewModel.cellViewModels[indexPath.row]
        
        return detailCell
    }
}

extension DetailViewController: UITableViewDelegate {}
