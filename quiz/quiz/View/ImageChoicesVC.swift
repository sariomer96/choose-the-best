//
//  ImageChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import UIKit

class ImageChoicesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func nextClick(_ sender: Any) {
        performSegue(withIdentifier: "toPublish", sender: nil)
    }
    
     

}
