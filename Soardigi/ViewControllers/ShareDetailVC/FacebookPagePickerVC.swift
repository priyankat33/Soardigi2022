//
//  FacebookPagePickerVC.swift
//  Soardigi
//
//  Created by Developer on 06/01/23.
//

import UIKit

protocol PagePickerControllerDelegate:NSObjectProtocol {
   func pagePicker(selectedPage:String,index: String)
  }

class FacebookPagePickerVC: UIViewController {
    var pagePickerControllerDelegate:PagePickerControllerDelegate?
    @IBOutlet weak fileprivate var tableView: UITableView!
    var fbPageData:[FBPageData] = [FBPageData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true

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

extension FacebookPagePickerVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbPageData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "PageCodeCell", for: indexPath) as! PageCodeCell
        cell.countryNameLBL.text = fbPageData[indexPath.row].name ?? ""
            return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let delegate = self.pagePickerControllerDelegate else { return  }
         let obj = fbPageData[indexPath.row]
        delegate.pagePicker(selectedPage: obj.name ?? "", index: obj.id ?? "")
        
            dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 35.0
        
    }
}

extension FacebookPagePickerVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
