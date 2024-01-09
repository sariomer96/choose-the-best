//
//  BaseViewController.swift
//  quiz
//
//  Created by Omer on 5.01.2024.
//

import Foundation
import UIKit
class BaseViewController: UIViewController {
    
    func showAlert(_ title: String, _  message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
             
        }
        alert.addAction(ok)
        self.present(alert,animated: true)
    }
    
    func presentGameStartViewController(quiz: QuizResponse?) {
        let viewController = GameStartViewControllerBuilder.build(quiz: quiz)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController {
    
    // MARK: - Methods
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return self.instantiateFromStoryboardHelper(name)
    }
    
    private class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
}

//// MARK: - BaseViewController+ProgressController
//extension BaseViewController {
//    
//    // MARK: - Methods
//    func showProgress(_ loadingType: LoadingType = .systemRegular) {
//        LoaderUtility.shared.showLoader(loadingType)
//    }
//    
//    func hideProgress() {
//        LoaderUtility.shared.hideLoader()
//    }
//    
//    func setProgress(by isLoading: Bool) {
//        if isLoading {
//            showProgress()
//        } else {
//            hideProgress()
//        }
//    }
//}

