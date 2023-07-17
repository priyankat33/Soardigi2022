//
//  DownloadVC.swift
//  Soardigi
//
//  Created by Developer on 04/03/23.
//

import UIKit
import AVFoundation
import Kingfisher
enum DownLoadType {
    case image
    case video
    case custom
}
class DownloadVC: UIViewController {
    @IBOutlet weak fileprivate var collectionView:UICollectionView!
    @IBOutlet weak fileprivate var view1:UIView!
    @IBOutlet weak fileprivate var view2:UIView!
    @IBOutlet weak fileprivate var view3:UIView!
    var downLoadType:DownLoadType = .image
    var saveImageModel:[SaveImageModel] = [SaveImageModel]()
    var customImageModel:[CustomImageModel] = [CustomImageModel]()
    var saveVideoModel:[SaveVideoModel] = [SaveVideoModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func loadData() {
        
        if let data = UserDefaults.standard.saveImageModel {
            saveImageModel = data
            downLoadType = .image
            self.collectionView.reloadData()
        }
    }
    
    func loadCustomData() {
        
        if let data = UserDefaults.standard.customImageModel {
            customImageModel = data
            downLoadType = .custom
            self.collectionView.reloadData()
        }
    }
    
    func loadVideoData() {
        if let data = UserDefaults.standard.saveVideoModel {
            saveVideoModel = data
            downLoadType = .video
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func onClickImage(_ sender:UIButton) {
        view1.isHidden = false
        view2.isHidden = true
        view3.isHidden = true
        loadData()
    }
    
    @IBAction func onClickVideo(_ sender:UIButton) {
        view1.isHidden = true
        view2.isHidden = false
        view3.isHidden = true
        loadVideoData()
    }
    
    @IBAction func onClickCustom(_ sender:UIButton) {
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = false
        loadCustomData()
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


extension DownloadVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 20) / 3
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch downLoadType {
        case .image:
            return saveImageModel.count
        case .video:
            return saveVideoModel.count
        case .custom:
            return customImageModel.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
       
        switch downLoadType {
        case .image:
            let data = saveImageModel[indexPath.row]
            if let downloadedImage = UIImage(data: data.imageSave!){
                cell.imageView.image = downloadedImage
            }
            cell.titleLbl.isHidden = true
        case .video:
            print("")
            let data = saveVideoModel[indexPath.row]
            let url = data.videoSave!
            
            cell.imageView.image = URL(fileURLWithPath: url).generateThumbnail()
            cell.titleLbl.isHidden = true
        case .custom:
            let data = customImageModel[indexPath.row]
            if let downloadedImage = UIImage(data: data.imageSave!){
                cell.imageView.image = downloadedImage
            }
            cell.titleLbl.isHidden = true
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DeleteDownloadVC") as! DeleteDownloadVC
//        let data = homeViewModel.getSubscription[index]
//        vc.selectedId = data.id ?? 0
//        vc.amount = data.price ?? "0"
//        vc.points = data.points ?? 0
        vc.callback = { value in
            
            if value {
                self.dismiss(animated: true, completion: {
                    switch self.downLoadType {
                    case .image:
                        UserDefaults.standard.saveImageModel?.remove(at: indexPath.item)
                        self.loadData()
                    case .video:
                        print("")
                    case .custom:
                        UserDefaults.standard.customImageModel?.remove(at: indexPath.item)
                        self.loadCustomData()
                    }
                    
                })
                
            } else {
                self.dismiss(animated: true, completion: {
                   
                    switch self.downLoadType {
                    case .image:
                      print("")
                        let data = self.saveImageModel[indexPath.item]
                        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
                        let downloadedImage = UIImage(data: data.imageSave!)
                        vc.image = downloadedImage
                        //vc.dataUrl = selectedImageURL
                    vc.typeSelected = 0
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .video:
                        print("")
                    case .custom:
                        let data = self.customImageModel[indexPath.item]
                        let downloadedImage = UIImage(data: data.imageSave!)
                        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
                        vc.image = downloadedImage
                        //vc.dataUrl = selectedImageURL
                        vc.typeSelected = 0
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                })
                
            }
            
         }
        self.present(vc, animated: true, completion: nil)
    }
}

extension URL {
    func generateThumbnail() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            // Swift 5.3
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)

            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)

            return nil
        }
    }
}
