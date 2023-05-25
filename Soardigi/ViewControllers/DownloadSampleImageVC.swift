//
//  DownloadSampleImageVC.swift
//  Soardigi
//
//  Created by Developer on 13/04/23.
//

import UIKit

class DownloadSampleImageVC: UIViewController {
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var imageView:UIImageView!
    @IBOutlet weak var collectionViewUpper: UICollectionView!
    var callback: ((_ image: UIImage) -> Void)?
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    var selectedId:Int = 0
    var horizontalIndex:Int = 0
    var imgUrl:String = ""
    var sampleId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: URL(string: imgUrl), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
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

    @IBAction func onClickDownload(_ sender:CustomButton) {
        let frameid = self.homeViewModel.categoryImagesResponseModel1[horizontalIndex].id ?? 0
        showLoader(status: true)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let url = NSURL(string: baseURL + "api/business-frame-message-first/\(selectedId)?frame=\(String(frameid))&watermark=\(waterMarker)") {

            let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in

                if let err = error {
                    print("Error: \(err)")
                    return
                }
                showLoader()
                if let http = response as? HTTPURLResponse {
                    if http.statusCode == 200 {
                        let saveImageModel = SaveImageModel(imageSave: data, frameId: frameid, imageId: "\(self.selectedId)")
                        
                        UserDefaults.standard.saveImageModel?.append(saveImageModel)
                        let downloadedImage = UIImage(data: data!)

                            DispatchQueue.main.async {
                                self.callback?(downloadedImage!)
                                self.dismiss(animated: true)
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
}

extension DownloadSampleImageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
    
            
        
     }
}
