//
//  GameStartTableViewCell.swift
//  quiz
//
//  Created by Omer on 27.11.2023.
//

import UIKit

class GameStartTableViewCell: UITableViewCell {

    @IBOutlet weak var attachName: UILabel!
    @IBOutlet weak var attachImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
