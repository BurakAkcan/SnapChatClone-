//
//  FeedTableViewCell.swift
//  SnapchatClone
//
//  Created by Burak AKCAN on 26.06.2022.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var snapImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
