//
//  PointHistoryVC.swift
//  Soardigi
//
//  Created by Developer on 04/02/23.
//

import UIKit

class PointHistoryVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var tableView:UITableView!
    @IBOutlet weak fileprivate var totalLbl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.getPointHistory(sender: self, onSuccess: {
            if self.homeViewModel.pointHistory.count > 0 {
                var spendItems = self.homeViewModel.pointHistory.filter({ $0.type == 2 }).map({$0.points ?? 0}).reduce(0, +)
                var earnItems = self.homeViewModel.pointHistory.filter({ $0.type == 1 }).map({$0.points ?? 0}).reduce(0, +)
                let total = earnItems - spendItems
                self.totalLbl.text = total > 0 ? "\(total)" : "0"
            }
            self.tableView.reloadData()
        }, onFailure: {
            
        })
    }
}


extension PointHistoryVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.pointHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointHistoryTVC", for: indexPath) as! PointHistoryTVC
        let data = homeViewModel.pointHistory[indexPath.row]
        cell.subscriptionLbl.text = data.message ?? ""
        cell.dateLbl.text = data.date ?? ""
        if data.type == 2 {
            cell.pointsLbl.text = "-\(data.points ?? 0)pts"
            cell.pointsLbl.textColor = .red
        } else {
            cell.pointsLbl.text = "+\(data.points ?? 0)pts"
            cell.pointsLbl.textColor = .green
        }
        
        
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
