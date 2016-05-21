//
//  FishTableViewCell.swift
//  FishToxicity
//
//  Created by Yaoyu Yang on 11/23/15.
//  Copyright © 2015 Yaoyu Yang. All rights reserved.
//

import UIKit

class FishTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
