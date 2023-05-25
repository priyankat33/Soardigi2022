//
//  ChatVC.swift
//  Soardigi
//
//  Created by Developer on 28/03/23.
//

import UIKit

class ChatVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    var id:String = ""
    var status:String = ""
    @IBOutlet weak fileprivate var tableView:UITableView!
    @IBOutlet weak fileprivate var lbl:UILabel!
    @IBOutlet weak fileprivate var btn:UIButton!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = "\(id)-Request Custom"
        if status == "Open" {
            btn.isHidden = false
        } else {
            btn.isHidden = true
        }
        getChat()
//        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
//            self.updateCounting()
//        })
        
        // Do any additional setup after loading the view.
    }
    
    
     func updateCounting(){
        getChat()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        timer.invalidate()
    }
    
    func getChat() {
        homeViewModel.getChat(id: id, sender: self, onSuccess: {
            self.tableView.reloadData()
            self.scrollToBottom()
        }, onFailure: {
            
        })
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.homeViewModel.chatResponseModel.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    @IBAction func onClickSend(_ sender:UIButton) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SendMessageVC") as! SendMessageVC
        vc.id = id
        vc.callBackSubscription = {
            self.dismiss(animated: true)
            self.getChat()
        }
            self.present(vc, animated: true, completion: nil)
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

extension ChatVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.chatResponseModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           
        let data = homeViewModel.chatResponseModel[indexPath.row]
        if data.from == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
            if data.type == 2 {
//                cell.messageLBL.isHidden = true
                if data.images?.count ?? 0 > 0 {
                    cell.imgView.isHidden = false
                    cell.downloadBtn.isHidden = false
                    cell.downloadBtn.tag = indexPath.row
                    cell.imgView.kf.indicatorType = .activity
                    cell.imgView.kf.setImage(with: URL(string: data.images?[0].url ?? ""), placeholder: nil, options: nil) { result in
                        switch result {
                        case .success(let value):
                            print("Image: \(value.image). Got from: \(value.cacheType)")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }

                } else {
                    cell.imgView.isHidden = true
                    cell.downloadBtn.isHidden = true
                }
                let emptyMessage = data.message ?? ""
                if emptyMessage.isEmpty {
                    cell.messageLBL.isHidden = true
                    cell.msgView.isHidden = true
                   
                    
                } else {
                    cell.messageLBL.isHidden = false
                    cell.messageLBL.text = data.message ?? ""
                    cell.msgView.isHidden = false
                    
                    
                }
                if !(data.message?.isEmpty ?? false) || data.images?.count ?? 0 > 0 {
                    cell.dateView.isHidden = false
                    cell.dateLBL.isHidden = false
                    cell.dateLBL.text = data.date ?? ""
                } else {
                    cell.dateView.isHidden = true
                    cell.dateLBL.isHidden = true
                   }
            } else {
                
                let emptyMessage = data.message ?? ""
                if emptyMessage.isEmpty {
                    cell.messageLBL.isHidden = true
                    cell.msgView.isHidden = true
                } else {
                    cell.messageLBL.isHidden = false
                    cell.messageLBL.text = data.message ?? ""
                    cell.msgView.isHidden = false
                }
              //  cell.messageLBL.isHidden = false
               
                if data.images?.count ?? 0 > 0 {
                    
                    cell.imgView.isHidden = false
                    cell.downloadBtn.isHidden = false
                    
                    cell.downloadBtn.tag = indexPath.row
                    cell.imgView.kf.indicatorType = .activity
                    cell.imgView.kf.setImage(with: URL(string: data.images?[0].url ?? ""), placeholder: nil, options: nil) { result in
                        switch result {
                        case .success(let value):
                            print("Image: \(value.image). Got from: \(value.cacheType)")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                } else {
                    cell.imgView.isHidden = true
                    cell.downloadBtn.isHidden = true
                }
                if !(data.message?.isEmpty ?? false) || data.images?.count ?? 0 > 0 {
                    cell.dateView.isHidden = false
                    cell.dateLBL.isHidden = false
                    cell.dateLBL.text = data.date ?? ""
                } else {
                    cell.dateView.isHidden = true
                    cell.dateLBL.isHidden = true
                   }
               

            }
           return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell1", for: indexPath) as! ChatCell
            cell.sampleBtn.tag = indexPath.row
            if status == "Open" {
                cell.sampleBtn.isUserInteractionEnabled = true
            } else {
                cell.sampleBtn.isUserInteractionEnabled = false
            }
            if data.type == 2 {
                if data.images?.count ?? 0 > 0 {
                    cell.imgViewCustom.isHidden = false
                    cell.sampleBtn.isHidden = false

                } else {
                    cell.imgViewCustom.isHidden = true
                    cell.sampleBtn.isHidden = true
                }
                
                let emptyMessage = data.message ?? ""
                if emptyMessage.isEmpty {
                    cell.messageLBL.isHidden = true
                    cell.msgView.isHidden = true
                    
                    
                } else {
                    cell.messageLBL.isHidden = false
                    cell.msgView.isHidden = false
                    cell.messageLBL.text = data.message ?? ""
                   
                }
               
               
                cell.dateLBL.text = data.date ?? ""
                cell.dateLBL.isHidden = false
                cell.dateView.isHidden = false
            } else {
                let emptyMessage = data.message ?? ""
                if emptyMessage.isEmpty {
                    cell.messageLBL.isHidden = true
                    cell.msgView.isHidden = true
                    cell.dateLBL.isHidden = true
                } else {
                    cell.messageLBL.isHidden = false
                    cell.msgView.isHidden = false
                    cell.dateLBL.isHidden = false
                    cell.dateLBL.text = data.date ?? ""
                    cell.messageLBL.text = data.message ?? ""
                }
//                cell.messageLBL.isHidden = false
                
                cell.imgViewCustom.isHidden = true
                cell.sampleBtn.isHidden = true
//                cell.messageLBL.text = data.message ?? ""
                
            }
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func onClickSampleImage(_ sender:UIButton) {
        let value = sender.tag
        let data = homeViewModel.chatResponseModel[value]
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SampleImageVC") as! SampleImageVC
        if data.images?.count ?? 0 > 0 {
            vc.images = data.images ?? []
            vc.sampleId = id
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onClickDownloadImage(_ sender:UIButton) {
        let value = sender.tag
        let data = homeViewModel.chatResponseModel[value]
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DownloadSampleImageVC") as! DownloadSampleImageVC
       if data.images?.count ?? 0 > 0 {
           vc.imgUrl = data.images?[0].url ?? ""
           vc.sampleId = id
           vc.callback = { (downloadImage) -> Void in
               let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
               vc.image = downloadImage
               
           vc.typeSelected = 0
               self.navigationController?.pushViewController(vc, animated: true)
           }
           vc.selectedId = data.images?[0].id ?? 0
           self.present(vc, animated: true, completion: nil)
       }
      }
}
