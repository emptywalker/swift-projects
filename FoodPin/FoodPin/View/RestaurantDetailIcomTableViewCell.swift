//
//  RestaurantDetailIcomTableViewCell.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/20.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit

class RestaurantDetailIcomTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var shortTextLabel: UILabel! {
        didSet {
            shortTextLabel.numberOfLines = 0
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
