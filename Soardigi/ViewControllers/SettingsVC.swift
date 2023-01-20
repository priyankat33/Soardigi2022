//
//  SettingsVC.swift
//  Soardigi
//
//  Created by Developer on 11/01/23.
//

import UIKit

class SettingsVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak var waterMark:UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickTerms(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "StaticContentVC") as! StaticContentVC
        vc.urlString = "http://stgapi.soardigi.in/api/content/terms-and-conditions"
        vc.heading = "Terms & Conitions"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onClickPrivacy(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "StaticContentVC") as! StaticContentVC
        vc.heading = "Privacy Policy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onClickRefund(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "StaticContentVC") as! StaticContentVC
        vc.heading = "Refund Policy"
        vc.urlString = "http://stgapi.soardigi.in/api/content/refund-policy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickContactUs(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "StaticContentVC") as! StaticContentVC
        vc.heading = "Contact Us"
        vc.urlString = "http://stgapi.soardigi.in/api/content/contact-us"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func switchChanged(_ sender: Any) {
            if self.waterMark.isOn{
                
                homeViewModel.setWaterMark(isWaterMark: true, sender: self, onSuccess: {
                    
                }, onFailure: {})
                print("THE SWITCH IS OOOOONNNN")
            }else{
                homeViewModel.setWaterMark(isWaterMark: false, sender: self, onSuccess: {
                    
                }, onFailure: {})
                print("THE SWITCH IS OOOOOFFFFFFF")
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
