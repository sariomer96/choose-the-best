//
//  ImagePickerTableViewCell.swift
//  quiz
//
//  Created by Omer on 27.11.2023.
//

import UIKit

protocol ImagePickerTableViewCellDelegate: AnyObject {
    func didEndTextChange(text: String?, index: Int)
}

final class ImagePickerTableViewCell: UITableViewCell {
    weak var delegate: ImagePickerTableViewCellDelegate?

    @IBOutlet weak var attachNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField! 
     
     var index = 0
    
    @IBOutlet weak var attachImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


extension ImagePickerTableViewCell: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        delegate?.didEndTextChange(text: textField.text, index: index)
//    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.didEndTextChange(text: textField.text, index: index)
    }
}
