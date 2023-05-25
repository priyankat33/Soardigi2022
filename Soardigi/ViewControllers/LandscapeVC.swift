//
//  LandscapeVC.swift
//  Soardigi
//
//  Created by Developer on 17/05/23.
//

import UIKit
import ZLImageEditor
class LandscapeVC: UIViewController {
    @IBOutlet weak fileprivate var collectionView:UICollectionView!
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    var type: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFrames(type:type)
    }
    
    func getFrames(type:Bool = false) {
        homeViewModel.getLandscapeFrames(type: type,sender: self, onSuccess: {
            self.collectionView.reloadData()
        }, onFailure: {
            
        })

    }
}


extension LandscapeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: type ? self.view.frame.height/2 : size)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.imageFrameResponseModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
        let data = homeViewModel.imageFrameResponseModel[indexPath.row]
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: URL(string: data.img_url ?? ""), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        cell.titleLbl.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BusinessCategoryCVC
             else{
               return
             }
                
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])

        ZLEditImageViewController.showEditImageVC(parentVC: self, image: cell.imageView.image!) { [weak self] (resImage, editModel) in
            let data = resImage.pngData
            let customImageModel = CustomImageModel(imageSave: data(), frameId: 0, imageId: "")
            
            UserDefaults.standard.customImageModel?.append(customImageModel)
            
            
                UIImageWriteToSavedPhotosAlbum(resImage, nil, nil, nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
                vc.image = resImage
                
                vc.typeSelected = 0
                self?.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }
    }
}
