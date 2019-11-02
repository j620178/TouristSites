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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerWithNib(identifier: TouristSiteCell.identifier)
        return tableView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        title = "台北市熱門景點"
        view.backgroundColor = .backgroundGray
        
        view.addSubview(tableView)
        tableView.addConstrainSameWith(self.view)
        
        view.addSubview(indicatorView)
        indicatorView.addConstraintCenterXYOf(self.view)
    }

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TouristSiteCell.identifier, for: indexPath)
        
        guard let touristSiteCell = cell as? TouristSiteCell else { return cell }
        
        return touristSiteCell
    }
    
}

extension MainViewController: UITableViewDelegate {}

