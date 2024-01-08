//
//  LastUpdateTableViewCell.swift
//  quiz
//
//  Created by Omer on 14.11.2023.
//

import UIKit
import Cosmos

class LastUpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var starView: CosmosView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updateImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    func configureCell(name: String)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
