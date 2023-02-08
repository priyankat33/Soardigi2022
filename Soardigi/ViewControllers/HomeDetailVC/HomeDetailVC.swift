//
//  HomeDetailVC.swift
//  Soardigi
//
//  Created by Developer on 01/01/23.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class HomeDetailVC: UIViewController {
    fileprivate var fbPageData:[FBPageData] = [FBPageData]()
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var collectionView:UICollectionView!
    var id:String = ""
    var isPaid:Int = 0
    var horizontalIndex:Int = 0
    fileprivate var  type:Int = 0
    fileprivate var selectedImageURL:String = ""
    fileprivate var selectedId:String = ""
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var imageView:UIImageView!
    @IBOutlet weak var collectionViewUpper: UICollectionView!
    @IBOutlet weak fileprivate var imgLBl:UILabel!
    @IBOutlet weak fileprivate var videoLBl:UILabel!
    @IBOutlet weak fileprivate var videoBottomLBl:UILabel!
    @IBOutlet weak fileprivate var imgBottomLBl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let w1 = self.imageView.bounds.width
        let h1  = CGFloat(1600)/CGFloat(1600) * w1
        DispatchQueue.main.async {
            self.imageHeightConstraint.constant = h1
        }
            
        
        // Do any additional setup after loading the view.
        homeViewModel.getBusineesHomeFrames(sender: self, onSuccess: {
            
            self.collectionViewUpper.reloadData()
        }, onFailure: {
      })
        loadData()
    }
    
    func loadData(type:Int = 0) {
        homeViewModel.getBusineesHomeImages(type:type,id:id,sender: self, onSuccess: {
            let data = self.homeViewModel.categoryImagesResponseModel[0]
            self.selectedImageURL = type == 0 ? data.image ?? "" : data.videoUrl ?? ""
            self.isPaid = data.is_paid ?? 0
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            self.collectionView.reloadData()
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
    @IBAction func onClickImage(_ sender:UIButton) {
        imgLBl.textColor = .white
        videoLBl.textColor = .lightGray
        videoBottomLBl.isHidden = true
        imgBottomLBl.isHidden = false
        type = 0
        loadData(type: 0)
    }
    
    @IBAction func onClickDownload(_ sender:UIButton) {
        
        if isPaid == 2 {
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "NoSubscriptionVC") as! NoSubscriptionVC
            
            self.present(vc, animated: true, completion: nil)
        } else {
            let frameid = self.homeViewModel.categoryImagesResponseModel1[horizontalIndex].id ?? 0
            showLoader(status: true)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            if let url = NSURL(string: baseURL + "api/business-frame-first/\(selectedId)?frame=\(String(frameid))&watermark=\(0)"){

                let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in

                    if let err = error {
                        print("Error: \(err)")
                        return
                    }
                    showLoader()
                    if let http = response as? HTTPURLResponse {
                        if http.statusCode == 200 {
                            if self.type == 1 {
    //                            let tempFile = TemporaryMediaFile(withData: data!)
    //                                if let asset = tempFile.avAsset {
    //                                    print("THE ASSET IS------>\(asset)")
    ////                                    self.player = AVPlayer(playerItem:
    ////                                    AVPlayerItem(asset: asset)
    //
    //                                    let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
    //                                    DispatchQueue.main.async {
    //                                        let player = AVPlayer(playerItem:AVPlayerItem(asset: asset))
    //                                        let playerViewController = AVPlayerViewController()
    //                                        playerViewController.player = player
    //                                        self.present(playerViewController, animated: true) {
    //                                            playerViewController.player!.play()
    //                                        }
    //                                    }
    //                                }
                            }
                            let downloadedImage = UIImage(data: data!)
                            if  !pageName.isEmpty  && !pageId.isEmpty {
                                if AccessToken.current?.tokenString != nil {
                                    showLoader(status: true)
                                    let graphRequest
                                    = GraphRequest(graphPath: "/me/accounts?fields=access_token,name", parameters: ["access_token":AccessToken.current?.tokenString])
                                    graphRequest.start( completion: { [self] (connection, result, error)-> Void in
                                        if ((error) != nil)
                                        {
                                            print("Error: \(error)")
                                        }
                                        else
                                        {
                    
                                            let array = ((result as! NSDictionary).value(forKey: "data") as! NSArray)
                                            if array.count > 0 {
                                                showLoader()
                                                for tokens in array {
                                                    let tkn = ((tokens as! NSDictionary).value(forKey: "access_token")) as! String
                                                    let id = ((tokens as! NSDictionary).value(forKey: "id")) as! String
                                                    let name = ((tokens as! NSDictionary).value(forKey: "name")) as! String
                                                    fbPageData.append(FBPageData(name: name, id: id, accessToken: tkn))
                                                }
                                                let vc = mainStoryboard.instantiateViewController(withIdentifier: "FacebookShareVC") as! FacebookShareVC
                                                vc.fbPageData = self.fbPageData
                                                vc.createdImage = downloadedImage
                                                vc.typeSelected = type
                                                self.present(vc, animated: false, completion: nil)
                                            } else {
                                                showLoader()
                                                showAlertWithSingleAction(sender: self, message: "No page found")
                                            }
                    
                                        }
                    
                                    })
                                }
                            } else {
                                DispatchQueue.main.async {
                                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
                                    vc.image = downloadedImage
                                    //vc.dataUrl = selectedImageURL
                                vc.typeSelected = self.type
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                   
                            }
    //                        dispatch_async(dispatch_get_main_queue(), {
    //                            //self.testImageView.image = downloadedImage
    //                        })
                        }
                    }
               })
               task.resume()
            }
        }
        
        
        
//        homeViewModel.getImageWithFrames(id: frameid, imageURl: selectedImageURL, waterMark: 0, sender: self, onSuccess: {
//
//        }, onFailure: {
//
//        })
        
        
//        if  !pageName.isEmpty  && !pageId.isEmpty {
//            if AccessToken.current?.tokenString != nil {
//                showLoader(status: true)
//                let graphRequest
//                = GraphRequest(graphPath: "/me/accounts?fields=access_token,name", parameters: ["access_token":AccessToken.current?.tokenString])
//                graphRequest.start( completion: { [self] (connection, result, error)-> Void in
//                    if ((error) != nil)
//                    {
//                        print("Error: \(error)")
//                    }
//                    else
//                    {
//
//                        let array = ((result as! NSDictionary).value(forKey: "data") as! NSArray)
//                        if array.count > 0 {
//                            showLoader()
//                            for tokens in array {
//                                let tkn = ((tokens as! NSDictionary).value(forKey: "access_token")) as! String
//                                let id = ((tokens as! NSDictionary).value(forKey: "id")) as! String
//                                let name = ((tokens as! NSDictionary).value(forKey: "name")) as! String
//                                fbPageData.append(FBPageData(name: name, id: id, accessToken: tkn))
//                            }
//                            let vc = mainStoryboard.instantiateViewController(withIdentifier: "FacebookShareVC") as! FacebookShareVC
//                            vc.fbPageData = self.fbPageData
//                            vc.dataUrl = selectedImageURL
//                            vc.typeSelected = type
//                            self.present(vc, animated: false, completion: nil)
//                        } else {
//                            showLoader()
//                            showAlertWithSingleAction(sender: self, message: "No page found")
//                        }
//
//                    }
//
//                })
//            }
//        } else {
//
//                let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
//                vc.image = self.imageView.image
//                vc.selectedImageURL = selectedImageURL
//                vc.typeSelected = type
//                self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    
    @IBAction func onClickVideo(_ sender:UIButton) {
        imgLBl.textColor = .lightGray
        videoLBl.textColor = .white
        videoBottomLBl.isHidden = false
        imgBottomLBl.isHidden = true
        type = 1
        loadData(type: 1)
    }

}


extension HomeDetailVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewUpper {
            return CGSize(width: collectionViewUpper.bounds.size.width, height: collectionViewUpper.bounds.size.height)
        } else {
            let size = (collectionView.frame.size.width - 20) / 3
            return CGSize(width: size, height: size)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewUpper {
            return homeViewModel.categoryImagesResponseModel1.count
        } else {
            return homeViewModel.categoryImagesResponseModel.count
        }
       
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewUpper {
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CategoryCVC" , for: indexPath) as! CategoryCVC
                let data = self.homeViewModel.categoryImagesResponseModel1[indexPath.item]
                cell.imageView.kf.indicatorType = .activity
                cell.imageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil, options: nil) { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
                return cell
            }
         else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessFrameCVC", for: indexPath) as! BusinessFrameCVC
            let data = homeViewModel.categoryImagesResponseModel[indexPath.row]
             cell.lbl.isHidden = data.is_paid == 1 ? false : true
             cell.playImageView.isHidden = type == 0 ? true : false
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            return cell
        }
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()

        visibleRect.origin = collectionViewUpper.contentOffset
        visibleRect.size = collectionViewUpper.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionViewUpper.indexPathForItem(at: visiblePoint) else { return }
        horizontalIndex = indexPath.row
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let data = homeViewModel.categoryImagesResponseModel[indexPath.row]
        selectedId = data.id ?? ""
        isPaid = data.is_paid ?? 0
        selectedImageURL = type == 0 ? data.image ?? "" : data.videoUrl ?? ""
            imageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                   print("Image: \(value.image)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
        
     }
}

 
import AVKit

class TemporaryMediaFile {
    var url: URL?

    init(withData: Data) {
        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(NSUUID().uuidString).mov"
        let url = directory.appendingPathComponent(fileName)
        do {
            try withData.write(to: url)
            self.url = url
        } catch {
            print("Error creating temporary file: \(error)")
        }
    }

    public var avAsset: AVAsset? {
        if let url = self.url {
            return AVAsset(url: url)
        }

        return nil
    }

    public func deleteFile() {
        if let url = self.url {
            do {
                try FileManager.default.removeItem(at: url)
                self.url = nil
            } catch {
                print("Error deleting temporary file: \(error)")
            }
        }
    }

    deinit {
        self.deleteFile()
    }
}
