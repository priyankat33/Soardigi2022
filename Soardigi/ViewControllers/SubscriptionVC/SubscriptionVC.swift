//
//  SubscriptionVC.swift
//  Soardigi
//
//  Created by Developer on 31/01/23.
//

import UIKit
import AppInvokeSDK
class SubscriptionVC: UIViewController {
    private let appInvoke = AIHandler()
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
    
    @IBAction func openPaytm(_ sender: UIButton) {
           
            let alert = UIAlertController(title: "Environment", message: "Select the server environment in which you want to open paytm.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Staging", style: .default, handler: {[weak self] (action) in
                self?.hitInitiateTransaction(.staging)
            }))
            alert.addAction(UIAlertAction(title: "Production", style: .default, handler: {[weak self] (action) in
                self?.hitInitiateTransaction(.production)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func hitInitiateTransaction(_ env: AIEnvironment) {
        self.appInvoke.openPaytmSubscription(merchantId: "", orderId: "", txnToken: "", amount: "", callbackUrl: "", delegate: self, environment: env, urlScheme: "")
    }

}
extension SubscriptionVC: AIDelegate {
    func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
        print("🔶 Paytm Callback Response: ", response)
        let alert = UIAlertController(title: "\(status)", message: String(describing: response), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPaymentWebVC(_ controller: UIViewController?) {
        if let vc = controller {
            DispatchQueue.main.async {[weak self] in
                self?.present(vc, animated: true, completion: nil)
            }
        }
        self.dismiss(animated: true)
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
