//
//  SubscriptionTypeVC.swift
//  Soardigi
//
//  Created by Developer on 03/02/23.
//

import UIKit
import AppInvokeSDK
class SubscriptionTypeVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    private let appInvoke = AIHandler()
    @IBOutlet weak var bussinessLBL:UILabel!
    @IBOutlet weak var pointBtn:UIButton!
    @IBOutlet weak var onlineBtn:UIButton!
    @IBOutlet weak var categoryLBL:UILabel!
    var selectedId:Int = 0
    var selectedType:Int = 1
    var bussinessId:Int = 0
    var amount:String = "0"
    var points:Int = 0
    var totalPoints:Int = 0
    @IBOutlet weak var imageView:CustomImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
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
        
        homeViewModel.getPointHistory(sender: self, onSuccess: { [self] in
            if self.homeViewModel.pointHistory.count > 0 {
                let spendItems = self.homeViewModel.pointHistory.filter({ $0.type == 2 }).map({$0.points ?? 0}).reduce(0, +)
                let earnItems = self.homeViewModel.pointHistory.filter({ $0.type == 1 }).map({$0.points ?? 0}).reduce(0, +)
                self.totalPoints = earnItems - spendItems
            }
         }, onFailure: {
            
        })
        // Do any additional setup after loading the view.
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        let data = notification.object as? String ?? ""
        if data == "PYTM_103" {
            
                    homeViewModel.applySubscriptionType(business: bussinessId, payMethod: selectedType, plan_id: selectedId, sender: self, onSuccess: {
                        showAlertWithSingleAction1(sender: self, message: "Thanks for Subscription", onSuccess: {
                            self.dismiss(animated: true)
                        })
                    }, onFailure: {
            
                    })
            
            
        } else {
            
            showAlertWithSingleAction1(sender: self, message: "Subscription Failed", onSuccess: {
                self.dismiss(animated: true)
            })
        }
        }
    
    @IBAction func onClickOnline(_ sender:UIButton) {
        pointBtn.setImage(UIImage(named: "unselectrd"), for: .normal)
        onlineBtn.setImage(UIImage(named: "selectrd"), for: .normal)
        selectedType = 1
    }
    
    private func hitInitiateTransaction(_ env: AIEnvironment,merchantId:String = "",orderId:String = "",txnToken:String = "",amount:String = "",callbackUrl:String = "") {
        self.appInvoke.openPaytmSubscription(merchantId: merchantId, orderId: orderId, txnToken: txnToken, amount: amount, callbackUrl: callbackUrl, delegate: self, environment: env, urlScheme: "")
    }
    
    func invokePaytmApp(txnToken: String, orderId: String, mid: String, amount : String) -> Bool {
        if let paytmInvokeURL:URL = URL(string: "paytm://subscriptionpayment?txnToken=(\(txnToken)&orderId=(\(orderId)&mid=(\(mid)&amount=(\(amount)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(paytmInvokeURL)) {
                application.open(paytmInvokeURL, options: [:]) { (finish) in}
                return true
            }
            else{
                //Paytm app Redirect the user to Paytm HTML payment page
                return false
            }
        }
        return false
    }
    
    @IBAction func onClickApply(_ sender:UIButton) {
        
        
        if selectedType == 2 {
            if totalPoints >= points {
                homeViewModel.applySubscriptionType(business: bussinessId, payMethod: selectedType, plan_id: selectedId, sender: self, onSuccess: {
                    showAlertWithSingleAction1(sender: self, message: "Thanks for Subscription", onSuccess: {
                        self.dismiss(animated: true)
                    })
                }, onFailure: {
                    showAlertWithSingleAction1(sender: self, message: "You don't have enough points to subscribe the subscription", onSuccess: {
                        self.dismiss(animated: true)
                    })
                })
            } else {
                showAlertWithSingleAction1(sender: self, message: "You don't have enough points to subscribe the subscription", onSuccess: {
                    self.dismiss(animated: true)
                })
            }
            
        } else {
            self.homeViewModel.initializePayment(business: self.bussinessId, amount: self.amount, sender: self, onSuccess: {
                self.hitInitiateTransaction(.production, merchantId: self.homeViewModel.initializePaymentModel?.mid ?? "", orderId: self.homeViewModel.initializePaymentModel?.orderID ?? "", txnToken: self.homeViewModel.initializePaymentModel?.token ?? "", amount: self.amount, callbackUrl: self.homeViewModel.initializePaymentModel?.callback ?? "")
            }, onFailure: {
                
            })
        }
        
        
        
    }
    
    @IBAction func onClickPoints(_ sender:UIButton) {
        pointBtn.setImage(UIImage(named: "selectrd"), for: .normal)
        onlineBtn.setImage(UIImage(named: "unselectrd"), for: .normal)
        selectedType = 2
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SubscriptionTypeVC:CategoryControllerDelegate {
    func selectedCategory(businessName: String, categoryName: String, id: Int, thumbnail: String) {
        
        self.bussinessLBL.text = businessName
        self.bussinessId = id
        self.categoryLBL.text = categoryName
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: URL(string: thumbnail), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
   
}
extension SubscriptionTypeVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController)-> UIModalPresentationStyle {

        if Platform.isPhone {
            return .none
        }else{
            return .popover
        }
        
    }
}


extension SubscriptionTypeVC: AIDelegate {
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
