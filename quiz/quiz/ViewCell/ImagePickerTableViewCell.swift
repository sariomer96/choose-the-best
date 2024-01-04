//
//  ImagePickerTableViewCell.swift
//  quiz
//
//  Created by Omer on 27.11.2023.
//

import UIKit

class ImagePickerTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var attachNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField! 
        
  
     
     var index = 0
    
    @IBOutlet weak var attachImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
      
        nameTextField.addTarget(self, action: #selector(didChanged), for: .editingChanged)
        
        // Initialization code
    }

    @objc func didChanged() {
      
        ImageChoicesViewModel.shared.editTitleDelegate?.editTitle(index: index, title: nameTextField.text!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
   
    
}
