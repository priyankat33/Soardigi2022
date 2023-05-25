//
//  CustomVC.swift
//  Soardigi
//
//  Created by Developer on 14/03/23.
//

import UIKit

class CustomVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func onClickLibrary(_ sender: UIButton) {
        showAlertWithSingleAction(sender: self, message: "Coming Soon")
    }
    
    @IBAction func onClickCustomImage(_ sender: UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LandscapePortraitVC") as! LandscapePortraitVC
        vc.callback = { id in
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "LandscapeVC") as! LandscapeVC
            vc.type = id == 1 ? false : true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true, completion: nil)
    }
}
