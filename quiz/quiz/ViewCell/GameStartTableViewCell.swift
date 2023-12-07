//
//  GameStartTableViewCell.swift
//  quiz
//
//  Created by Omer on 27.11.2023.
//

import UIKit

class GameStartTableViewCell: UITableViewCell {

    @IBOutlet weak var win2RateBar: ProgressBar!
    @IBOutlet weak var winRateCircleBar: ProgressBar!
    var count : CGFloat = 0.45
    @IBOutlet weak var attachName: UILabel!
    @IBOutlet weak var attachImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        DispatchQueue.main.async {
      
            self.winRateCircleBar.progress = self.count
            self.win2RateBar.progress = self.count*1.8
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
