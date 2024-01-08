////
////  ProgressController.swift
////  quiz
////
////  Created by Omer on 5.01.2024.
////
//
//import Foundation
//
//import UIKit
//
//final class ProgressController: UIViewController {
//
//    // MARK: - Singleton
//    static let sharedManager = ProgressController()
//    
//    // MARK: - UI Elements
//    lazy var backgroundView: UIView = {
//        let bgView  = UIView()
//        bgView.backgroundColor = .init(white: 1.0, alpha: 0.6)
//        return bgView
//    }()
//    
//    /// `System Regular Progress UI`
//    lazy var activityIndicatorView: UIActivityIndicatorView = {
//        var indicatorView = UIActivityIndicatorView()
//        if #available(iOS 13.0, *) {
//            indicatorView = UIActivityIndicatorView(style: .medium)
//        } else {
//            indicatorView = UIActivityIndicatorView(style: .white)
//        }
//        indicatorView.color = .greyBlue
//        indicatorView.hidesWhenStopped = true
//        return indicatorView
//    }()
//    
//    /// `Purchase Progress UI`
//    lazy var lcwPopupView: LCWPopupView = {
//        let popupView: LCWPopupView = .init(image: .init(image:  imageLiteral(resourceName: "processPaymentIcon"), size: .medium),
//                                            message: .init(title: .regular(text: Localize.General.purchaseIsInProgress.getString(),
//                                                                           font: .poppins(.Bold, size: FontConstants.fontSizeMedium)),
//                                                           description: .regular(text: Localize.General.pleaseWait.getString(),
//                                                                                 font: .poppins(.Regular, size: FontConstants.fontSizeSmall))))
//        popupView.set(backgoundAlpha: 0.6, backgroundColor: .white)
//        popupView.layer.applyShadow()
//        backgroundView.isHidden = true
//        return popupView
//    }()
//    
//    lazy var superAppView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .init(white: 1.0, alpha: 1)
//        return view
//    }()
//    
//    lazy var imageView: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: superAppView.frame.width, height: superAppView.frame.height))
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//
//    
//    // MARK: - Properties
//    private var countDown: Timer? {
//        willSet {
//            countDown?.invalidate()
//        }
//    }
//        
//    // MARK: - Methods
//    func startCountDown() {
//        countDown = Timer.scheduledTimer(timeInterval: 60.10,
//                                         target: self,
//                                         selector: #selector(countDownAction),
//                                         userInfo: nil,
//                                         repeats: false)
//    }
//    
//    func stopCountDown() {
//        countDown?.invalidate()
//    }
//    
//    /// `Show Progress`
//    func showProgress(_ progressType: LoadingType = .systemRegular) {
//        // Show progress only if placeholder animation is not presenting
//        guard UIApplication.shared.keyWindow?.viewWithTag(UIViewController.background) == nil else { return }
//        switch progressType {
//        case .systemRegular:
//            showSystemRegularProgress()
//        case .purchase:
//            showPurchaseProgress()
//        case .superApp:
//            showSuperAppProgress()
//        }
//    }
//
//    /// `Hide Progress`
//    func hideProgress() {
//        if isSystemRegularOnTheScreen {
//            hideSystemRegularProgress()
//        } else if isPurchaseOnTheScreen {
//            hidePurchaseProgress()
//        } else if isSuperAppOnTheScreen {
//            hideSuperAppProgress()
//        }
//    }
//
//    // MARK: - Selectors
//    @objc private func countDownAction() {
//        hideProgress()
//    }
//}
//
