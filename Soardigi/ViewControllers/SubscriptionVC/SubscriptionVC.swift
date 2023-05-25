//
//  SubscriptionVC.swift
//  Soardigi
//
//  Created by Developer on 31/01/23.
//

import UIKit

class SubscriptionVC: UIViewController {
    
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.getUserSubscriptions(sender: self, onSuccess: {
            self.tableView.reloadData()
        }, onFailure: {
            
        })
    }
}



extension SubscriptionVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.userSubscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTVC", for: indexPath) as! SubscriptionTVC
        let data = homeViewModel.userSubscriptions[indexPath.row]
        cell.nameLbl.text = data.business_name ?? ""
        cell.subscriptionLbl.text = data.name ?? ""
        cell.priceLbl.text = "₹ \(data.price ?? "")/\(data.no_of_months ?? 0) Month"
        cell.dateLbl.text = "\(data.start_date ?? "") to \(data.end_date ?? "")"
        cell.statusLbl.text = "\(data.status_message ?? "") | \(data.p_message ?? "")"
        
        return cell
    }
    
    @IBAction func onClickLike(_ sender:UIButton) {
        let value = sender.tag
    }
    
    @IBAction func onClickReadMore(_ sender:UIButton) {
        let value = sender.tag
        
        let data = homeViewModel.feedModel[value]
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "StaticContentVC") as! StaticContentVC
        vc.urlString = data.url ?? ""
        vc.heading = data.title ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
