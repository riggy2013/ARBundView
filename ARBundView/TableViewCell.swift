//
//  TableViewCell.swift
//  ARBundView
//
//  Created by David Peng on 2018/12/25.
//  Copyright © 2018 David Peng. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var BuildingIcon: UIImageView!
    @IBOutlet weak var BuildingName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
