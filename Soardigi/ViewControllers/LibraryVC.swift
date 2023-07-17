//
//  LibraryVC.swift
//  Soardigi
//
//  Created by Developer on 28/06/23.
//

import UIKit

class LibraryVC: UIViewController {
    @IBOutlet weak fileprivate var collectionView:UICollectionView!
    var saveDownloadImageModel:[SaveDownloadImageModel] = [SaveDownloadImageModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    

    func loadData() {
        
        if let data = UserDefaults.standard.saveDownloadImageModel {
            saveDownloadImageModel = data
           self.collectionView.reloadData()
        }
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

extension LibraryVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 20) / 2
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveDownloadImageModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
       
        let data = saveDownloadImageModel[indexPath.row]
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: URL(string: data.imageURL ?? "" ), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        cell.titleLbl.text = data.id ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = saveDownloadImageModel[indexPath.row]
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DownloadSampleImageVC") as! DownloadSampleImageVC
       
            vc.imgUrl = data.imageURL ?? ""
            vc.sampleId = data.id ??  ""
            vc.selectedId = data.selectedId ?? 0
            
            vc.callback = { (downloadImage) -> Void in
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
                vc.image = downloadImage
                
                vc.typeSelected = 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.present(vc, animated: true, completion: nil)
        
    }
}
