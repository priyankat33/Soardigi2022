//
//  SendMessageVC.swift
//  Soardigi
//
//  Created by Developer on 31/03/23.
//

import UIKit

class SendMessageVC: UIViewController {
    @IBOutlet weak fileprivate var textView:CustomTextView!
    var callBackSubscription: (() -> Void)?
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    var id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSend(_ sender:UIButton) {
        
        if textView.text.isEmpty {
            showAlertWithSingleAction(sender: self, message: "Please enter the message")
        } else {
            
            homeViewModel.sendMessage(id: id, message: textView.text ?? "", sender: self, onSuccess: {
                self.callBackSubscription?()
            }, onFailure: {
                
            })
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
