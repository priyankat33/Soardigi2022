//
//  BrandFeedVC.swift
//  Soardigi
//
//  Created by Developer on 01/02/23.
//

import UIKit
import Kingfisher
class BrandFeedVC: UIViewController {
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    fileprivate func loadData() {
        homeViewModel.getFeeds(sender: self, onSuccess: {
            self.tableView.reloadData()
        }, onFailure: {
            
        })
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

extension BrandFeedVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.feedModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTVC", for: indexPath) as! FeedTVC
        let data = homeViewModel.feedModel[indexPath.row]
        cell.nameLBl.text = data.title ?? ""
        cell.likeLBl.text = "\(data.likes ?? 0) Likes"
        cell.likeBtn.tag = indexPath.row
        cell.readBtn.tag = indexPath.row
        cell.likeImg.image = data.hasLiked ?? false ? UIImage(named: "select") : UIImage(named: "unselect")
        
        if data.type == 1 {
            DispatchQueue.main.async {
                cell.palyerView.load(withVideoId: data.youtube_video_link ?? "" )
            }
            
            cell.palyerView.isHidden = false
            cell.imageViewFeed.isHidden = true
        } else {
            cell.palyerView.isHidden = true
            cell.imageViewFeed.isHidden = false
            cell.imageViewFeed.kf.setImage(with: URL(string: data.thumbnail ?? ""), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
        
        return cell
    }
    
    @IBAction func onClickLike(_ sender:UIButton) {
        let value = sender.tag
        let data = homeViewModel.feedModel[value]
        homeViewModel.likeDislike(business: data.id ?? 0, sender: self, onSuccess: {
            self.loadData()
        }, onFailure: {
            
        })
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
