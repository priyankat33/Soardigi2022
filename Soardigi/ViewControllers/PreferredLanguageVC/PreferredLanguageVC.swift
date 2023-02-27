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
                   self.selectedLanguage.append(SelectedLanguage(id: "\(self.homeViewModel.languages[0].id ?? 0)",language: 1))
                   
               } else {
                   self.engBTN.backgroundColor = UIColor.init(named: "Black_Dark")
               }
               
                if self.homeViewModel.languages[1].selected == 1 {
                    self.selectedLanguage.append(SelectedLanguage(id: "\(self.homeViewModel.languages[1].id ?? 0)",language: 2))
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
        if self.homeViewModel.languages[0].selected != 1 {
            selectedLanguage.append(SelectedLanguage(id: "\(homeViewModel.languages[0].id ?? 0)",language: 1))
        } else {
            self.homeViewModel.languages[0].selected = 0
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
        if self.homeViewModel.languages[1].selected != 1 {
            selectedLanguage.append(SelectedLanguage(id: "\(homeViewModel.languages[1].id ?? 0)",language: 2))
        } else {
            self.homeViewModel.languages[1].selected = 0
            if selectedLanguage.count > 0 {
                for (index,i) in selectedLanguage.enumerated() {
                    if i.language == 2 {
                        selectedLanguage.remove(at:index)
                    }
                }
            }
        }
    }
    
    @IBAction func onClickApply(_ sender: UIButton) {
        if selectedLanguage.count > 0 {
            homeViewModel.saveLanguage(selectedLanguage:selectedLanguage,sender: self, onSuccess: {
                self.dismiss(animated: true)
            }, onFailure: {
                
            })
        } else {
            showAlertWithSingleAction(sender: self, message: "Please  select atleast one language")
        }
     }
}
