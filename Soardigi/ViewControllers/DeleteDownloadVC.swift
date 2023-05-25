//
//  DeleteDownloadVC.swift
//  Soardigi
//
//  Created by Developer on 23/05/23.
//

import UIKit

class DeleteDownloadVC: UIViewController {
    var callback : ((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickDelete(_ sender:CustomButton) {
        callback?(true)
        
    }
    
    @IBAction func onClickShare(_ sender:CustomButton) {
        callback?(false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
