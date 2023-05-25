//
//  CreateCustomListRequestVC.swift
//  Soardigi
//
//  Created by Developer on 26/03/23.
//

import UIKit

class CreateCustomListRequestVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    
    @IBOutlet weak fileprivate var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeViewModel.getCreateCustomListRequest(sender: self, onSuccess: {
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


extension CreateCustomListRequestVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.requestResponseModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateCustomRequestCell", for: indexPath) as! CreateCustomRequestCell
        
        let data = homeViewModel.requestResponseModel[indexPath.row]
        cell.dateLBL.text = "Request Status: \(data.status ?? "")"
        cell.eventLBL.text = "Request Code: \(data.code ?? "")"
            return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = homeViewModel.requestResponseModel[indexPath.row]
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.id = data.code ?? ""
        vc.status = data.status ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
