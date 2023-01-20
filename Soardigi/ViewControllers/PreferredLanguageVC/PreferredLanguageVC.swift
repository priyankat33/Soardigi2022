//
//  PreferredLanguageVC.swift
//  Soardigi
//
//  Created by Developer on 15/01/23.
//

import UIKit

class PreferredLanguageVC: UIViewController {
    fileprivate var selectedLanguage:[SelectedLanguage] = [SelectedLanguage]()
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak var engBTN:CustomButton!
    @IBOutlet weak var hindiBTN:CustomButton!
    @IBOutlet weak var submitBTN:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
            homeViewModel.getLanguageList(sender: self, onSuccess: {
               if self.homeViewModel.languages[0].selected == 1 {
                   self.engBTN.backgroundColor = CustomColor.customYellowColor
               } else {
                   self.engBTN.backgroundColor = UIColor.init(named: "Black_Dark")
               }
               
                if self.homeViewModel.languages[1].selected == 1 {
                    self.hindiBTN.backgroundColor = CustomColor.customYellowColor
                } else {
                    self.hindiBTN.backgroundColor = UIColor.init(named: "Black_Dark")
                }
                
            }, onFailure: {
                
            })
        // Do any) additional setup after loading the view.
    }
    

    @IBAction func onClickEnglish(_ sender: CustomButton) {
        
        sender.backgroundColor = self.homeViewModel.languages[0].selected == 1 ? UIColor.init(named: "Black_Dark") : CustomColor.customYellowColor
        if !sender.isSelected {
            selectedLanguage.append(SelectedLanguage(id: "\(homeViewModel.languages[0].id ?? 0)",language: 1))
        } else {
            if selectedLanguage.count > 0 {
                for (index,i) in selectedLanguage.enumerated() {
                    if i.language == 1 {
                        selectedLanguage.remove(at:index)
                    }
                }
            }
        }
    }
    
    @IBAction func onClickHindi(_ sender: CustomButton) {
        sender.backgroundColor = self.homeViewModel.languages[1].selected == 1 ? UIColor.init(named: "Black_Dark") : CustomColor.customYellowColor
        if !sender.isSelected {
            selectedLanguage.append(SelectedLanguage(id: "\(homeViewModel.languages[1].id ?? 0)",language: 2))
        } else {
            if selectedLanguage.count > 0 {
                for (index,i) in selectedLanguage.enumerated() {
                    if i.language == 2 {
                        selectedLanguage.remove(at:index)
                    }
                }
            }
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
    @IBAction func onClickApply(_ sender: UIButton) {
        if selectedLanguage.count > 0 {
            homeViewModel.saveLanguage(selectedLanguage:selectedLanguage,sender: self, onSuccess: {
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "SelectBusinessVC") as! SelectBusinessVC
                self.navigationController?.pushViewController(vc, animated: true)
            }, onFailure: {
                
            })
        } else {
            showAlertWithSingleAction(sender: self, message: "Please  select atleast one language")
        }
     }
}
