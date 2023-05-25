//
//  CreateCustomRequestVC.swift
//  Soardigi
//
//  Created by Developer on 26/03/23.
//

import UIKit

class CreateCustomRequestVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var tableView:UITableView!
    @IBOutlet weak fileprivate var textView:CustomTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeViewModel.getCreateCustomRequest(sender: self, onSuccess: {
            self.tableView.reloadData()
        }, onFailure: {
            
        })
    }
    
    @IBAction func onClickRequest(_ sender:CustomButton) {
        if textView.text.isEmpty {
            showAlertWithSingleAction(sender: self, message: "Please enter Request")
        } else {
            
            self.homeViewModel.createCustomRequest(sender: self, onSuccess: {
                self.tableView.reloadData()
            }, onFailure: {
                
            })
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CreateCustomRequestVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.eventResponseModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateCustomRequestCell", for: indexPath) as! CreateCustomRequestCell
        
        let data = homeViewModel.eventResponseModel[indexPath.row]
        cell.dateLBL.text = data.date ?? ""
        cell.eventLBL.text = data.name ?? ""
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
