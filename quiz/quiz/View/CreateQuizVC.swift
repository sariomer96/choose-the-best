//
//  CreateQuizVCViewController.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

class CreateQuizVC: BaseViewController {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var quizTitleLabel: UITextField!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    var viewModel = CreateQuizViewModel()

    @IBOutlet weak var categorySelectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        blurView.bounds = self.view.bounds
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.4)
        popUpView.layer.cornerRadius = 10
        recognizer(imageView: coverImageView)
       categorySelectButton.isHidden = true

        viewModel.getCategory { _ in
         self.showSelectCategoryButton()
        }

        viewModel.callbackCategoryFailed = { [weak self] fail in
            guard let self = self else {return}
            self.alert(title: "Category Failed", message: fail)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.didSelectCategory = false
        animateIn(desiredView: blurView)
        animateIn(desiredView: popUpView)

    }

    @IBAction func confirmButtonClicked(_ sender: Any) {
        animateOut(desiredView: blurView)
        animateOut(desiredView: popUpView)
    }
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!

        backgroundView.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center

        UIView.animate(withDuration: 0.3) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        }
    }
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    func showSelectCategoryButton() {

        let  action = viewModel.getDropDownActions()
        categorySelectButton.isHidden = false

            categorySelectButton.menu = UIMenu(children: action)
            categorySelectButton.showsMenuAsPrimaryAction = true
    }
    func recognizer(imageView: UIImageView) {
        imageView.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)

    }
    @objc func chooseImage() {

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)

    }

    func setQuizFields(quiztype: QuizType) {

         let isEmpty = viewModel.checkIsEmptyFields(title: quizTitleLabel.text!, view: self)

        if isEmpty == false, viewModel.isSelectedImage == true, viewModel.didSelectCategory == true {
              CreateQuizFields.shared.quizHeaderImage = coverImageView.image!
              CreateQuizFields.shared.quizTitle = quizTitleLabel.text!

              if quiztype == QuizType.image {

                  let viewC = self.storyboard!.instantiateViewController(withIdentifier: "ImageChoicesVC")
                  as? ImageChoicesVC

                  viewC?.imageChoicesViewModel.setCategoryID(id: viewModel.categoryID)
                  self.navigationController?.pushViewController(viewC ?? ImageChoicesVC(), animated: true)

              } else {

                  let viewC = self.storyboard!.instantiateViewController(withIdentifier: "VideoChoicesVC")
                  as? VideoChoicesVC
                  viewC?.videoChoicesViewModel.setCategoryID(id: viewModel.categoryID)
                  self.navigationController!.pushViewController(viewC ?? VideoChoicesVC(), animated: true)
              }
          } else {
               alert(title: "Empty Fields", message: "Please fill title and select image")

          }
    }

    enum QuizType {
        case image
        case video
    }
    @IBAction func imageQuizclicked(_ sender: Any) {
        setQuizFields(quiztype: QuizType.image)

    }
    @IBAction func videoQuizClick(_ sender: Any) {
        setQuizFields(quiztype: QuizType.video)
    }
}
extension CreateQuizVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        coverImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true)

        viewModel.setSelectImageStatus(status: true)
    }
}
