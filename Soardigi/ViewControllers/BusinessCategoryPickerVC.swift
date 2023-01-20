//
//  BusinessCategoryPickerVC.swift
//  Soardigi
//
//  Created by Developer on 09/01/23.
//

import UIKit
protocol CategoryControllerDelegate:NSObjectProtocol {
   
    func selectedCategory(businessName:String,categoryName:String,id:Int)
    
    
}
class BusinessCategoryPickerVC: UIViewController {
    var categoryControllerDelegate:CategoryControllerDelegate?
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak var bussinessLBL:UILabel!
    @IBOutlet weak var categoryLBL:UILabel!
    @IBOutlet weak var imageView:CustomImageView!
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        homeViewModel.getBusineesList(sender: self, onSuccess: {
            self.tableView.reloadData()
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

}

extension BusinessCategoryPickerVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.businessModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCategoryCell", for: indexPath) as! BusinessCategoryCell
        let data = homeViewModel.businessModel[indexPath.row]
        cell.bussinessLBL.text = data.name ?? ""
        cell.categoryLBL.text = data.businessCategoryModel?.name ?? ""
        cell.imageViewCat.kf.indicatorType = .activity
        cell.imageViewCat.kf.setImage(with: URL(string: data.thumbnail ?? ""), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
            return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let delegate = self.categoryControllerDelegate else { return  }
        let data = homeViewModel.businessModel[indexPath.row]
        delegate.selectedCategory(businessName: data.name ?? "", categoryName: data.businessCategoryModel?.name ?? "", id: 0)
          dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
}

extension BusinessCategoryPickerVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
