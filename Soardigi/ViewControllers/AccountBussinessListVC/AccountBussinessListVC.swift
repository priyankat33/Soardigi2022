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
}

extension AccountBussinessListVC:UITableViewDelegate,UITableViewDataSource{
    
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
        
       
//        let data = homeViewModel.businessModel[indexPath.row]
//        delegate.selectedCategory(businessName: data.name ?? "", categoryName: data.businessCategoryModel?.name ?? "", id: 0)
//          dismiss(animated: true, completion: nil)
//        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
}
