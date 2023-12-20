//
//  TopRatedViewCell.swift
//  quiz
//
//  Created by Omer on 14.11.2023.
//

import UIKit
import Cosmos

class TopRatedViewCell: UITableViewCell {
   
    @IBOutlet weak var startViews: CosmosView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var rating = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
