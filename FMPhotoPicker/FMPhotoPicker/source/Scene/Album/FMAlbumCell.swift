//
//  FMAlbumCell.swift
//  FMPhotoPicker
//
//  Created by Jie Tian on 2020/3/26.
//  Copyright © 2020 Tribal Media House. All rights reserved.
//

import UIKit

class FMAlbumCell: UITableViewCell {
    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var numberOfItems: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        
        title.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        numberOfItems.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
    }
}
