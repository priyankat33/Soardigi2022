//
//  AddSubscriptionVC.swift
//  Soardigi
//
//  Created by Developer on 03/02/23.
//

import UIKit

class AddSubscriptionVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var tableView:UITableView!
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
