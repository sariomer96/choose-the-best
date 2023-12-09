//
//  VideoChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoChoicesVC: UIViewController {

    @IBOutlet var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://www.youtube.com/watch?v=i5CtdgBUkeQ&ab_channel=SagopaKajmer"
        
        let t = url.split(separator: "v=")
         
        let last = t[1]
        let id = last.split(separator: "&")
        print(last)
        print(id[0])
        let l = String(id[0])
        playerView.load(withVideoId: l)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextClick(_ sender: Any) {
        performSegue(withIdentifier: "toPublish", sender: nil)
    }
    
     

}
