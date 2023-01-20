//
//  ShowBusinessCategoryDetailVC.swift
//  Soardigi
//
//  Created by Developer on 09/01/23.
//

import UIKit

class ShowBusinessCategoryDetailVC: UIViewController, CategoryControllerDelegate {
    func selectedCategory(businessName: String, categoryName: String, id: Int) {
        
    }
    
    
    var businessName:String = ""
    var categoryName:String = ""
    var businessImage:String = ""
    @IBOutlet weak var bussinessLBL:UILabel!
    @IBOutlet weak var categoryLBL:UILabel!
    @IBOutlet weak var imageView:CustomImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bussinessLBL.text = businessName
        categoryLBL.text = categoryName
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: businessImage), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
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

extension ShowBusinessCategoryDetailVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController)-> UIModalPresentationStyle {

        if Platform.isPhone {
            return .none
        }else{
            return .popover
        }
        
    }
}
