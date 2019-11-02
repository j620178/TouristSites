//
//  DetailViewController.swift
//  TouristSites
//
//  Created by littlema on 2019/11/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    var stackView: UIStackView = {
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
        return tableView
    }()
    
    var viewModel: DetailCellViewModel {
        didSet {
            title = viewModel.title
        }
    }
    
    var sectionsTitle = ["景點名稱", "景點介紹", "景點資訊", "地點"]

    init(viewModel: DetailCellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        title = viewModel.title
    }
    
    func setupView() {
        view.backgroundColor = .backgroundGray
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: 300),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
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
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath)
        
        guard let detailCell = cell as? DetailTableViewCell else { return cell }
        
        detailCell.titleLabel.text = sectionsTitle[indexPath.row]
        
        switch indexPath.row {
        case 0:
            detailCell.descLabel.text = viewModel.title
        case 1:
            detailCell.descLabel.text = viewModel.desc
        case 2:
            detailCell.descLabel.text = viewModel.info
        default:
            detailCell.descLabel.text = viewModel.address
        }
        
        return detailCell
    }
}
