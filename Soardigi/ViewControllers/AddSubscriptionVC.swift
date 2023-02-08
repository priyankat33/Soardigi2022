//
//  AddSubscriptionVC.swift
//  Soardigi
//
//  Created by Developer on 03/02/23.
//

import UIKit

class AddSubscriptionVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak var imageView:CustomImageView!
    @IBOutlet weak fileprivate var tableView:UITableView!
    fileprivate var index:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.getSubscriptions(sender: self, onSuccess: {
            self.tableView.reloadData()
        }, onFailure: {
            
        })
    }
    

}


extension AddSubscriptionVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.getSubscription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTVC", for: indexPath) as! SubscriptionTVC
        let data = homeViewModel.getSubscription[indexPath.row]
        cell.subscriptionLbl.text = data.name ?? ""
        cell.priceLbl.text = "₹ \(data.price ?? "") Or \(data.points ?? 0) Points"
        cell.dateLbl.text = "\(data.no_of_months ?? 0) Month"
        cell.statusLbl.text = "\(data.message ?? "")"
        if indexPath.row == index {
            cell.view.borderColor = .red
        } else {
            cell.view.borderColor = UIColor(named: "White_Dark")!
        }
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        tableView.reloadData()
    }
    
    @IBAction func onClickSelectPlan(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SubscriptionTypeVC") as! SubscriptionTypeVC
        let data = homeViewModel.getSubscription[index]
        vc.selectedId = data.id ?? 0
        vc.amount = data.price ?? "0"
        vc.points = data.points ?? 0
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onClickActivatePackage(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "AddPackageVC") as! AddPackageVC
        let data = homeViewModel.getSubscription[index]
        vc.selectedId = data.id ?? 0
//        vc.amount = data.price ?? "0"
        self.present(vc, animated: true, completion: nil)
    }
}
