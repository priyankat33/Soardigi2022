//
//  ChooseLanguageVC.swift
//  Soardigi
//
//  Created by Developer on 01/11/22.
//

import UIKit

class ChooseLanguageVC: UIViewController {
    @IBOutlet weak var engBTN:CustomButton!
    @IBOutlet weak var hindiBTN:CustomButton!
    @IBOutlet weak var submitBTN:UIButton!
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    fileprivate var selectedLanguage:[SelectedLanguage] = [SelectedLanguage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.getBusineesList(sender: self, onSuccess: {
            if self.homeViewModel.businessModel.count > 0 {
                isLogin = true
                if let tabViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabViewController") as? TabViewController {
                    self.present(tabViewController, animated: true, completion: nil)
                }
            } else {
                isLogin = false
                self.homeViewModel.getLanguageList(sender: self, onSuccess: {
                    self.engBTN.isHidden = false
                    self.hindiBTN.isHidden = false
                    self.submitBTN.isHidden = false
                }, onFailure: {
                    
                })
            }
        }, onFailure: {
            
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func onClickEnglish(_ sender: CustomButton) {
        sender.backgroundColor = sender.isSelected ? UIColor.init(named: "Black_Dark") : CustomColor.customYellowColor
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
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onClickHindi(_ sender: CustomButton) {
        sender.backgroundColor = sender.isSelected ? UIColor.init(named: "Black_Dark") : CustomColor.customYellowColor
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
        sender.isSelected = !sender.isSelected
    }
    
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

struct SelectedLanguage {
    var id:String = ""
    var language:Int = 0
}
