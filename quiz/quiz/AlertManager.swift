//
//  AlertManager.swift
//  quiz
//
//  Created by Omer on 21.11.2023.
//

import Foundation
import UIKit

protocol AlertPr {
    func alert(view:UIViewController,title:String,message:String)
}
struct AlertManager:AlertPr {
    
     static let shared = AlertManager()
     var delegateAlert:AlertPr?
    
    init() {
        delegateAlert = self
    }
    
    func alert(view:UIViewController, title:String,message:String) {
        
         
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
             
        }
        alert.addAction(ok)
        view.present(alert,animated: true)
        
    }
    func alert(view:UIViewController, title:String,message:String, completion: @escaping (Bool) -> Void ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) {_ in
            completion(true)
        }
        alert.addAction(ok)
        view.present(alert,animated: true)
    }
    
}
