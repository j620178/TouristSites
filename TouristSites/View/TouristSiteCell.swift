//
//  TouristSiteCell.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct TouristSiteCellViewModel {
    let title: String
    let desc: String
    let photoURL: [String]
}

class TouristSiteCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descTextView: UITextView!
    
    @IBOutlet weak var photoCollectionView: UICollectionView! {
        didSet {
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: 180, height: 120)
            photoCollectionView.collectionViewLayout = layout
            let nib = UINib(nibName: TouristSitePhotoCell.identifier, bundle: nil)
            photoCollectionView.register(nib, forCellWithReuseIdentifier: TouristSitePhotoCell.identifier)
        }
    }
    
    var viewModel: TouristSiteCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell() {
        descTextView.textContainer.lineFragmentPadding = 0
    }
    
}

extension TouristSiteCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoURL.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TouristSitePhotoCell.identifier,
            for: indexPath)
        return cell
    }

}

extension TouristSiteCell: UICollectionViewDelegate {}
