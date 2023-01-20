//
//  CountryPickerVC.swift
//  Soardigi
//
//  Created by Developer on 19/10/22.
//

import UIKit


protocol PickerControllerDelegate:NSObjectProtocol {
   
    func picker(pikcer:CountryPickerVC, didSelectCountry:CountryModel)
    
    
}
class CountryPickerVC: UIViewController {
    @IBOutlet weak fileprivate var countrySearchBar: UISearchBar!
    @IBOutlet  fileprivate var objCountryCodeVM: CountryCodeViewModel!
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak var countryView: UIView!
    var delegate:PickerControllerDelegate?
    var filterdata:[CountryModel] = [CountryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        // Do any additional setup after loading the view.
        self.loadPickerTypeData()
    }
    
    fileprivate func loadPickerTypeData(){
        
            tableView.isHidden = false
            objCountryCodeVM.getcountryNamesByCode {
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        
                    })
                    self.tableView.reloadData()
                }
            }
        }
    
   
    override func viewDidLayoutSubviews() {
        //        super.viewDidLayoutSubviews()
        //        self.preferredContentSize.height = self.tableView.contentSize.height + 10
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

extension CountryPickerVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objCountryCodeVM.numberOfRow()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
            cell.objCountryModel = objCountryCodeVM.cellForItem(at: indexPath)
            return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let delegate = self.delegate else { return  }
        guard let obj = objCountryCodeVM.cellForItem(at: indexPath) else{return}
            delegate.picker(pikcer: self, didSelectCountry: obj)
            dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 35.0
        
    }
}

extension CountryPickerVC:UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}



extension CountryPickerVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count>0{
            objCountryCodeVM.getcountryNamesBySearch(searchText, OnCompletion: {
                self.tableView.reloadData()
            })}else{
            searchBar.resignFirstResponder()
            loadPickerTypeData()
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()
        print("searchBarCancelButtonClicked")
        loadPickerTypeData()
    }
}
