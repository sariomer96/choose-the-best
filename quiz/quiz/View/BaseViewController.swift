//
//  BaseViewController.swift
//  quiz
//
//  Created by Omer on 5.01.2024.
//

import Foundation
import UIKit
 class BaseViewController: UIViewController {
 
    
    func presentGameStartViewController(quiz: QuizResponse) {
        let viewController = GameStartViewControllerBuilder.build(quiz: quiz)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
   
    func refresh() {}
        
    
    func alert(title:String,message:String) {
        
         
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            self.refresh()
        }
      
        alert.addAction(ok)
 
        self.present(alert,animated: true)
        
    }
    func alert(title:String,message:String, completion: @escaping (Bool) -> Void ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) {_ in
         
            completion(true)
        }
        alert.addAction(ok)
        self.present(alert,animated: true)
    }
}

extension UIViewController {
    
    // MARK: - Methods
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return self.instantiateFromStoryboardHelper(name)
    }
    
    private class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T else {
                fatalError("Failed to instantiate view controller from storyboard")
            }
            return controller
    }
}

 


