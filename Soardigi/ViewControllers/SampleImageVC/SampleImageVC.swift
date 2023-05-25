//
//  SampleImageVC.swift
//  Soardigi
//
//  Created by Developer on 11/04/23.
//

import UIKit

class SampleImageVC: UIViewController {
    
    var urlImage:String = ""
    var id:Int = 0
    var sampleId:String = ""
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var count: UILabel!
    var images:[ImageResponseModel] = [ImageResponseModel]()
    fileprivate var sliderResponseModel:[HomeSliderResponseModel] = [HomeSliderResponseModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.count.text = "\(1)/\(images.count)"
        id = images[0].id ?? 0
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func onClickDownload(_ sender:UIButton) {
        let homeViewModel:HomeViewModel = HomeViewModel()
        
        homeViewModel.storeSample(imageId: id, id: sampleId, sender: self, onSuccess: {
            self.dismiss(animated: true)
        }, onFailure: {
            
        })
        
    }

}

extension SampleImageVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"SliderImageCVC" , for: indexPath) as! SliderImageCVC
        let data = images[indexPath.item]
        cell.imageView.kf.indicatorType = .activity

        cell.imageView.kf.setImage(with: URL(string: data.url ?? ""), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }

        print("THE SHOW CELL IS------->\(indexPath.row)")
        let index = indexPath.row
        self.count.text = "\(index+1)/\(images.count)"
        
        id = images[indexPath.row].id ?? 0
    }
}
