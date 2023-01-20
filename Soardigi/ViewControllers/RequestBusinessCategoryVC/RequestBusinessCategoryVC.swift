//
//  RequestBusinessCategoryVC.swift
//  Soardigi
//
//  Created by Developer on 06/11/22.
//

import UIKit

class RequestBusinessCategoryVC: UIViewController {
    @IBOutlet weak fileprivate var businessTF:UITextField!
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickRequest(_ sender:UIButton) {
        if !(businessTF.text!.isEmpty) {
            homeViewModel.saveCategory(categoryName: businessTF.text ?? "", sender: self, onSuccess: {
                self.dismiss(animated: true)
            }, onFailure: {
                
            })
        } else {
            showAlertWithSingleAction(sender: self, message: "Please enter category name")
        }
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
