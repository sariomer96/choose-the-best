//
//  ImagePickerTableViewCell.swift
//  quiz
//
//  Created by Omer on 27.11.2023.
//

import UIKit

class ImagePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var attachNameLabel: UILabel!
    
    @IBOutlet weak var attachImageView: UIImageView!
    var view : UIView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    @IBAction func editClicked(_ sender: Any) {
        view?.isHidden = false
    }
    
}
