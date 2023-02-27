//
//  AddPackageVC.swift
//  Soardigi
//
//  Created by Developer on 06/02/23.
//

import UIKit

class AddPackageVC: UIViewController {
    @IBOutlet weak var bussinessLBL:UILabel!
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak var imageView:CustomImageView!
    @IBOutlet weak var categoryLBL:UILabel!
    @IBOutlet weak var codeTF:CustomTextField!
    var selectedId:Int = 0
    var selectedType:Int = 1
    var bussinessId:Int = 0
    var amount:String = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.getBusineesList(sender: self, onSuccess: {
            if self.homeViewModel.businessModel.count > 0 {
                let data = self.homeViewModel.businessModel[0]
                self.bussinessLBL.text = data.name ?? ""
                self.bussinessId = data.business_category_id ?? 0
                self.categoryLBL.text = data.businessCategoryModel?.name ?? ""
                self.imageView.kf.indicatorType = .activity
                self.imageView.kf.setImage(with: URL(string: data.thumbnail ?? ""), placeholder: nil, options: nil) { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
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
    @IBAction func onClickApply(_ sender:UIButton) {
        let code = codeTF.text ?? ""
        if code.isEmpty {
            showAlertWithSingleAction(sender: self, message: "Please enter promo code")
        } else {
            homeViewModel.applyPackage(business: bussinessId, code:code , plan_id: selectedId, sender: self, onSuccess: {
                self.dismiss(animated: true)
            }, onFailure: {
                
            })
        }
        
    }
}




extension AddPackageVC{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryPickerSegue" {
            let controller = segue.destination as! BusinessCategoryPickerVC
            controller.categoryControllerDelegate = self
            guard let souceView = sender as? UIButton else{return}
            self.showCategories(controller: controller, sourceView:souceView )
        }
    }
    fileprivate func showCategories(controller:BusinessCategoryPickerVC, sourceView:UIButton) {
        if let popoverController = controller.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.delegate = self
            let height:CGFloat = 300
            let width:CGFloat = 300
            controller.preferredContentSize = CGSize(width: width, height: height)
        }
    }
}

extension AddPackageVC:CategoryControllerDelegate {
    func selectedCategory(businessName: String, categoryName: String, id: Int, thumbnail: String) {
        self.bussinessLBL.text = businessName
        self.bussinessId = id 
        self.categoryLBL.text = categoryName
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: URL(string: thumbnail ?? ""), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}
extension AddPackageVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController)-> UIModalPresentationStyle {

        if Platform.isPhone {
            return .none
        }else{
            return .popover
        }
        
    }
}
