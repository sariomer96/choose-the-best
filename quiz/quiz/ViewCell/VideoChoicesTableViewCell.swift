//
//  VideoChoicesTableViewCell.swift
//  quiz
//
//  Created by Omer on 10.12.2023.
//

import UIKit

class VideoChoicesTableViewCell: UITableViewCell {

    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoThumbnailImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
