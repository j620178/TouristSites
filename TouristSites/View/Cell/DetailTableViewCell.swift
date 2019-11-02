//
//  DetailTableViewCell.swift
//  TouristSites
//
//  Created by littlema on 2019/11/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct DetailCellViewModel {
    let title: String
    //let info: String?
    let desc: String?
//    let address: String
//    let photoURLs: [String]
}

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var cellViewModel: DetailCellViewModel? {
        didSet {
            titleLabel.text = cellViewModel?.title
            descLabel.text = cellViewModel?.desc
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
