//
//  CreateQuizViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit

protocol AlertProtocol:AnyObject {
    func alert(view:UIViewController)
}

final class CreateQuizViewModel:AlertProtocol {
    
    weak var delegate:AlertProtocol?
    
    init() {
        delegate = self
    }
    
    
    func checkIsEmptyFields(title:String, view:UIViewController) -> Bool{
      
        let trimmedString = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.isEmpty   {
            delegate?.alert(view:view)
            return true
        }else{
            return false
        }
    }
    
    
    func alert(view:UIViewController) {
        
   
        let alert = UIAlertController(title: "Field is empty", message: "You should fill the title.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        view.present(alert,animated: true)
     
        
    }
}
