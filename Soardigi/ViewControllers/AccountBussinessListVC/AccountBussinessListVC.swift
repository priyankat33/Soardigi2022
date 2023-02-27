//
//  AccountBussinessListVC.swift
//  Soardigi
//
//  Created by Developer on 21/01/23.
//

import UIKit

class AccountBussinessListVC: UIViewController {
    @IBOutlet weak fileprivate var tableView: UITableView!
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.getBusineesList(sender: self, onSuccess: {
            self.tableView.reloadData()
        }, onFailure: {
            
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickAdd(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SelectBusinessVC") as! SelectBusinessVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickEdit(_ sender:UIButton) {
        let data = homeViewModel.businessModel[sender.tag]
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CreateBusinessVC") as! CreateBusinessVC
        vc.heading = data.name ?? ""
        vc.emailId = data.email ?? ""
        vc.website = data.website ?? ""
        vc.phoneNumber = data.alt_mobile_no ?? ""
        vc.altPhoneNumber = data.mobile_no ?? ""
        vc.address = data.address ?? ""
        vc.businessId = data.id ?? 0
        vc.id = data.business_category_id ?? 0
        vc.city = data.city ?? ""
        vc.thumbnail  = data.thumbnail ?? ""
        vc.catName = data.businessCategoryModel?.name ?? ""
        vc.catThumb = data.businessCategoryModel?.thumbnail ?? ""
        vc.isFromEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AccountBussinessListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.businessModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCategoryCell", for: indexPath) as! BusinessCategoryCell
        cell.editBtn.tag = indexPath.row
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
        
        let data = homeViewModel.businessModel[indexPath.row]
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CreateBusinessVC") as! CreateBusinessVC
        vc.heading = data.name ?? ""
        vc.emailId = data.email ?? ""
        vc.website = data.website ?? ""
        vc.phoneNumber = data.alt_mobile_no ?? ""
        vc.altPhoneNumber = data.mobile_no ?? ""
        vc.address = data.address ?? ""
        vc.businessId = data.id ?? 0
        vc.id = data.business_category_id ?? 0
        vc.city = data.city ?? ""
        vc.thumbnail  = data.thumbnail ?? ""
        vc.catName = data.businessCategoryModel?.name ?? ""
        vc.catThumb = data.businessCategoryModel?.thumbnail ?? ""
        vc.isFromEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
}
