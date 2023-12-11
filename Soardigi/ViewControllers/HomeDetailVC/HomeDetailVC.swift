//
//  HomeDetailVC.swift
//  Soardigi
//
//  Created by Developer on 01/01/23.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import mobileffmpeg
import Alamofire
import Photos
class HomeDetailVC: UIViewController {
    var isFromEvent:Bool = false
    fileprivate var fbPageData:[FBPageData] = [FBPageData]()
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak fileprivate var collectionView:UICollectionView!
    @IBOutlet weak fileprivate var headLbl:UILabel!
    
    var id:String = ""
    var subCatId:String = ""
    var headingName:String = ""
    var isPaid:Int = 0
    var horizontalIndex:Int = 0
    fileprivate var  type:Int = 0
    fileprivate var selectedImageURL:String = ""
    var selectedId:String = ""
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var imageView:UIImageView!
    @IBOutlet weak var collectionViewUpper: UICollectionView!
    @IBOutlet weak fileprivate var imgLBl:UILabel!
    @IBOutlet weak fileprivate var videoLBl:UILabel!
    @IBOutlet weak fileprivate var videoBottomLBl:UILabel!
    @IBOutlet weak fileprivate var imgBottomLBl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        headLbl.text = headingName
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
            if !self.subCatId.isEmpty {
                let index =  self.homeViewModel.categoryImagesResponseModel.firstIndex{$0.id == self.subCatId}
                if let value = index {
                    let data =  self.homeViewModel.categoryImagesResponseModel[value]
                    self.selectedImageURL = type == 0 ? data.image ?? "" : data.videoUrl ?? ""
                    self.isPaid = data.is_paid ?? 0
                    self.selectedId = data.id ?? ""
                    self.imageView.kf.indicatorType = .activity
                    self.imageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil, options: nil) { result in
                        switch result {
                        case .success(let value):
                            print("Image: \(value.image). Got from: \(value.cacheType)")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                }
            } else {
                if self.homeViewModel.categoryImagesResponseModel.count > 0 {
                    let data =  self.homeViewModel.categoryImagesResponseModel[0]
                    self.selectedImageURL = type == 0 ? data.image ?? "" : data.videoUrl ?? ""
                    self.isPaid = data.is_paid ?? 0
                    self.selectedId = data.id ?? ""
                    self.imageView.kf.indicatorType = .activity
                    self.imageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil, options: nil) { result in
                        switch result {
                        case .success(let value):
                            print("Image: \(value.image). Got from: \(value.cacheType)")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
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
        imgLBl.textColor = UIColor(named: "White_Dark")
        videoLBl.textColor = .lightGray
        videoBottomLBl.isHidden = true
        imgBottomLBl.isHidden = false
        type = 0
        loadData(type: 0)
    }
    
    @IBAction func onClickDownload(_ sender:UIButton) {

        
        if isPaid == 1 {
            if self.type == 1 {

            }
            let frameid = self.homeViewModel.categoryImagesResponseModel1[horizontalIndex].id ?? 0
            showLoader(status: true)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            if let url = NSURL(string: baseURL + "api/business-frame-first/\(selectedId)?frame=\(String(frameid))&watermark=\(waterMarker)"){
                
                let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in
                    
                    if let err = error {
                        print("Error: \(err)")
                        return
                    }
                    showLoader()
                    if let http = response as? HTTPURLResponse {
                        if http.statusCode == 200 {
                            if self.type == 1 {
                                
                            }
                            
                            
                            let saveImageModel = SaveImageModel(imageSave: data, frameId: frameid, imageId: self.id)
                            
                            UserDefaults.standard.saveImageModel?.append(saveImageModel)
                            let downloadedImage = UIImage(data: data!)
                            if let imageDownload = downloadedImage{
                                UIImageWriteToSavedPhotosAlbum(imageDownload, nil, nil, nil)
                            }
                            if  !pageName.isEmpty  && !pageId.isEmpty {
                                if let accessToken = AccessToken.current?.tokenString  {
                                    showLoader(status: true)
                                    let graphRequest
                                    = GraphRequest(graphPath: "/me/accounts?fields=access_token,name", parameters: ["access_token":accessToken])
                                    graphRequest.start( completion: { [self] (connection, result, error)-> Void in
                                        if ((error) != nil)
                                        {
                                            print("Error: \(String(describing: error))")
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
                        }
                    }
                })
                task.resume()
            }
        } else {
            
            DispatchQueue.global(qos: .background).async {
                if let  movieDestinationUrl = URL(string: self.selectedImageURL){
                    let frameURL = self.homeViewModel.categoryImagesResponseModel1[self.horizontalIndex].image ?? ""
                    let url = URL(string:frameURL)
                        if let data = try? Data(contentsOf: url!)
                        {
                            if let image: UIImage = UIImage(data: data) {
                                self.newVideoCode(path: movieDestinationUrl, frameImage: image)
                            }
                            
                        }
                    
                }
            }
        }
    }
    
    func newVideoCode(path: URL, frameImage:UIImage) {
        
        //let path = Bundle.main.path(forResource: "sample_video", ofType:"mp4")
//        let fileURL = NSURL(fileURLWithPath: path!)
        let fileURL = path

        let composition = AVMutableComposition()
//        let vidAsset = AVURLAsset(url: fileURL as URL, options: nil)
        let vidAsset = AVURLAsset(url: path, options: nil)

        // get video track
        let vtrack =  vidAsset.tracks(withMediaType: AVMediaType.video)
        let videoTrack: AVAssetTrack = vtrack[0]
        let vid_timerange = CMTimeRangeMake(start: CMTime.zero, duration: vidAsset.duration)

        let tr: CMTimeRange = CMTimeRange(start: CMTime.zero, duration: CMTime(seconds: 10.0, preferredTimescale: 600))
        composition.insertEmptyTimeRange(tr)

        let trackID:CMPersistentTrackID = CMPersistentTrackID(kCMPersistentTrackID_Invalid)

        if let compositionvideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: trackID) {

            do {
                try compositionvideoTrack.insertTimeRange(vid_timerange, of: videoTrack, at: CMTime.zero)
            } catch {
                print("error")
            }

            compositionvideoTrack.preferredTransform = videoTrack.preferredTransform

        } else {
            print("unable to add video track")
            return
        }


        // Watermark Effect
        let size = videoTrack.naturalSize
        let imglayer = CALayer()
        imglayer.contents = frameImage.cgImage
        imglayer.frame = CGRect(x: 5, y: 5, width: size.width, height: size.height)
        
        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentlayer.addSublayer(videolayer)
        parentlayer.addSublayer(imglayer)
       // parentlayer.addSublayer(titleLayer)

        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        layercomposition.renderSize = size
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)

        // instruction for watermark
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
        instruction.layerInstructions = NSArray(object: layerinstruction) as [AnyObject] as! [AVVideoCompositionLayerInstruction]
        layercomposition.instructions = NSArray(object: instruction) as [AnyObject] as! [AVVideoCompositionInstructionProtocol]

        //  create new file to receive data
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        let movieFilePath = docsDir.appendingPathComponent("\(path.lastPathComponent)")
        let movieDestinationUrl = NSURL(fileURLWithPath: movieFilePath)

        // use AVAssetExportSession to export video
        let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileType.mov
        assetExport?.videoComposition = layercomposition

        // Check exist and remove old file
        FileManager.default.removeItemIfExisted(movieDestinationUrl as URL)

        assetExport?.outputURL = movieDestinationUrl as URL
        assetExport?.exportAsynchronously(completionHandler: {
            switch assetExport!.status {
            case AVAssetExportSession.Status.failed:
                print("failed")
                print(assetExport?.error ?? "unknown error")
            case AVAssetExportSession.Status.cancelled:
                print("cancelled")
                print(assetExport?.error ?? "unknown error")
            default:
                print("Movie complete")

                

                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieDestinationUrl as URL)
                }) { saved, error in
                    if saved {
                        print("Saved")
                        DispatchQueue.main.async {
//                            self.showPlayerViewController(for: self.myurl!)
                            DispatchQueue.main.async {
                                let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
                                vc.url =  movieDestinationUrl as URL
                                vc.typeSelected = 1
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                       
                    }
                }

               

            }
        })

    }
    
    @IBAction func onClickVideo(_ sender:UIButton) {
        imgLBl.textColor = .lightGray
        videoLBl.textColor = UIColor(named: "White_Dark")
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

extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}
