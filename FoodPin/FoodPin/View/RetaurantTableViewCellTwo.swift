//
//  RetaurantTableViewCellTwo.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/13.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit

class RestaurantTableViewCellTwo: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView! {
        didSet {
//            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.size.width / 2
//            thumbnailImageView.clipsToBounds = true
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
