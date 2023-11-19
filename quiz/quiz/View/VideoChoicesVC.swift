//
//  VideoChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import UIKit

class VideoChoicesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextClick(_ sender: Any) {
        performSegue(withIdentifier: "toPublish", sender: nil)
    }
    
     

}
