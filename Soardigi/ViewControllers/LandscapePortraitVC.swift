//
//  LandscapePortraitVC.swift
//  Soardigi
//
//  Created by Developer on 16/05/23.
//

import UIKit

class LandscapePortraitVC: UIViewController {
    var callback : ((Int) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickLandscape(_ sender:UIButton) {
        callback?(1)
        self.dismiss(animated: true)
    }

    @IBAction func onClickPortrait(_ sender:UIButton) {
        callback?(2)
        self.dismiss(animated: true)
    }
}
