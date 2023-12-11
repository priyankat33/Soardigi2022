//
//  LandscapeVC.swift
//  Soardigi
//
//  Created by Developer on 17/05/23.
//

import UIKit
import ZLImageEditor
import AVKit
import mobileffmpeg
import MobileCoreServices
import AVFoundation
import Photos

class LandscapeVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    var parentLayer: CALayer?
    var imageLayer: CALayer?
    var imageSelect: UIImage!
    
    var myurl: URL?
    @IBOutlet weak fileprivate var collectionView:UICollectionView!
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    var type: Bool = false
    var isFromVideo:Bool = false
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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
    
    func newVideoCode(path: URL) {
        let composition = AVMutableComposition()
        let vidAsset = AVURLAsset(url: path, options: nil)
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
        imglayer.contents = imageSelect.cgImage
        imglayer.frame = CGRect(x: 5, y: 5, width: 480, height: 360)
        imglayer.opacity = 0.4

        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentlayer.addSublayer(videolayer)
        parentlayer.addSublayer(imglayer)
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

//        // Check exist and remove old file
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
                self.myurl = movieDestinationUrl as URL
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieDestinationUrl as URL)
                }) { saved, error in
                    if saved {
                        DispatchQueue.main.async {
                            DispatchQueue.main.async {
                                let saveVideoModel = SaveVideoModel(videoSave: movieFilePath)
                                
                                UserDefaults.standard.saveVideoModel?.append(saveVideoModel)
                                let vc = mainStoryboard.instantiateViewController(withIdentifier: "ShareDetailVC") as! ShareDetailVC
                                vc.url = self.myurl!
                                
                                vc.typeSelected = 1
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                       
                    }
                }
            }
        })

    }
    
    func playVideo() {
        let player = AVPlayer(url: myurl!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        print("playing...")
    }
    
    private func showPlayerViewController(for url: URL) {
        let videoPlayer = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = videoPlayer
        
        present(playerViewController, animated: true) {
            if let player = playerViewController.player {
                player.play()
            }
        }
    }
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
    
       
        
    func export(videoURl: String, image:UIImage) {
            // remove existing export file if it exists
            let baseDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            let exportUrl = (baseDirectory.appendingPathComponent("export.mov", isDirectory: false) as NSURL).filePathURL!
            deleteExistingFile(url: exportUrl)
            
            // init variables
            let videoAsset: AVAsset = AVAsset(url: URL(string: videoURl)!) as AVAsset
            let tracks = videoAsset.tracks(withMediaType: AVMediaType.video)
            let videoAssetTrack = tracks.first!
            let exportSize: CGFloat = 320
            
            // build video composition
            let videoComposition = AVMutableVideoComposition()
            videoComposition.customVideoCompositorClass = CustomVideoCompositor.self
            videoComposition.renderSize = CGSize(width: exportSize, height: exportSize)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
            
            // build instructions
        let instructionTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoAssetTrack.timeRange.duration)
            // we're overlaying this on our source video. here, our source video is 1080 x 1080
            // so even though our final export is 320 x 320, if we want full coverage of the video with our watermark,
            // then we need to make our watermark frame 1080 x 1080
            let watermarkFrame = CGRect(x: 0, y: 0, width: 1080, height: 1080)
        
        let instruction = WatermarkCompositionInstruction(timeRange: instructionTimeRange, watermarkImage: image.cgImage!, watermarkFrame: watermarkFrame)
            
            videoComposition.instructions = [instruction]
            
            // create exporter and export
            let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetPassthrough)
        
            exporter!.videoComposition = videoComposition
            exporter!.outputURL = exportUrl
//        exporter!.determineCompatibleFileTypes { (fileTypes) in
//                        if fileTypes.contains(.m4v) {
//                            exporter!.outputFileType = .m4v
//                        } else {
//                            exporter!.outputFileType = .mov
//                        }
//                    }
            exporter!.outputFileType = .mp4
            exporter!.shouldOptimizeForNetworkUse = true
            exporter!.exportAsynchronously(completionHandler: { () -> Void in
                switch exporter!.status {
                case .completed:
                    print("Done!")
                    break
                case .failed:
                    print("Failed! \(exporter!.error)")
                default:
                    break
                }
            })
        }
        
        func deleteExistingFile(url: URL) {
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: url)
            }
            catch _ as NSError {
                
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BusinessCategoryCVC
             else{
               return
             }
        
        if isFromVideo {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                print("b")
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imageSelect = cell.imageView.image!
                self.present(imagePicker, animated: true,completion: nil)
            }
        } else {
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
    
    func addWatermark(waterMarkimage:UIImage,inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let mixComposition = AVMutableComposition()
        let asset = AVAsset(url: inputURL)
        let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        let timerange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)

            let compositionVideoTrack:AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))!

        do {
            try compositionVideoTrack.insertTimeRange(timerange, of: videoTrack, at: CMTime.zero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            print(error)
        }

        let watermarkFilter = CIFilter(name: "CISourceOverCompositing")!
        let watermarkImage = CIImage(image: waterMarkimage)
        let videoComposition = AVVideoComposition(asset: asset) { (filteringRequest) in
            let source = filteringRequest.sourceImage.clampedToExtent()
            watermarkFilter.setValue(source, forKey: "inputBackgroundImage")
            let transform = CGAffineTransform(translationX: filteringRequest.sourceImage.extent.width - (watermarkImage?.extent.width)! - 2, y: 0)
            watermarkFilter.setValue(watermarkImage?.transformed(by: transform), forKey: "inputImage")
            filteringRequest.finish(with: watermarkFilter.outputImage!, context: nil)
        }

        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            handler(nil)

            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func makeTransparent(image: UIImage) -> UIImage? {
        guard let rawImage = image.cgImage else { return nil}
        let colorMasking: [CGFloat] = [255, 255, 255, 255, 255, 255]
        UIGraphicsBeginImageContext(image.size)
        
        if let maskedImage = rawImage.copy(maskingColorComponents: colorMasking),
            let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0.0, y: image.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(maskedImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return finalImage
        }
        
        return nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                dismiss(animated: true, completion: nil)
        guard let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        
        newVideoCode(path: mediaURL)
        
        
               
            }
    

}


class CustomVideoCompositor: NSObject, AVVideoCompositing {
    
    var duration: CMTime?
    
    var sourcePixelBufferAttributes: [String : Any]? {
        get {
            return ["\(kCVPixelBufferPixelFormatTypeKey)": kCVPixelFormatType_32BGRA]
        }
    }
    
    var requiredPixelBufferAttributesForRenderContext: [String : Any] {
        get {
            return ["\(kCVPixelBufferPixelFormatTypeKey)": kCVPixelFormatType_32BGRA]
        }
    }
    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
        // do anything in here you need to before you start writing frames
    }
    
    func startRequest(_ request: AVAsynchronousVideoCompositionRequest) {
        // called for every frame
        // assuming there's a single video track. account for more complex scenarios as you need to
        let buffer = request.sourceFrame(byTrackID: request.sourceTrackIDs[0].int32Value)
        let instruction = request.videoCompositionInstruction
        
        // if we have our expected instructions
        if let inst = instruction as? WatermarkCompositionInstruction, let image = inst.watermarkImage, let frame = inst.watermarkFrame  {
            // lock the buffer, create a new context and draw the watermark image
            CVPixelBufferLockBaseAddress(buffer!, CVPixelBufferLockFlags.readOnly)
            let newContext = CGContext.init(data: CVPixelBufferGetBaseAddress(buffer!), width: CVPixelBufferGetWidth(buffer!), height: CVPixelBufferGetHeight(buffer!), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer!), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
            newContext?.draw(image, in: frame)
            CVPixelBufferUnlockBaseAddress(buffer!, CVPixelBufferLockFlags.readOnly)
        }
        request.finish(withComposedVideoFrame: buffer!)
    }
    
    func cancelAllPendingVideoCompositionRequests() {
        // anything you want to do when the compositing is canceled
    }
}


class WatermarkCompositionInstruction: NSObject, AVVideoCompositionInstructionProtocol {
    
    // AVVideoCompositionInstructionProtocol allows you to pass along any type of instruction that the compositor might need to
    // correctly render frames for a given time range. in our case, we need a watermark image and a transform
    // but any type of property could go here and then be drawn in your custom compositor
    
    var watermarkImage: CGImage?
    var watermarkFrame: CGRect?
    
    /// The following 5 items are required for the protocol
    /// See information on them here:
    /// https://developer.apple.com/reference/avfoundation/avvideocompositioninstructionprotocol
    /// set the correct values for your specific use case
    
    /* Indicates the timeRange during which the instruction is effective. Note requirements for the timeRanges of instructions described in connection with AVVideoComposition's instructions key above. */
    var timeRange: CMTimeRange
    
    /* If NO, indicates that post-processing should be skipped for the duration of this instruction.
     See +[AVVideoCompositionCoreAnimationTool videoCompositionToolWithPostProcessingAsVideoLayer:inLayer:].*/
    var enablePostProcessing: Bool = true
    
    /* If YES, rendering a frame from the same source buffers and the same composition instruction at 2 different
     compositionTime may yield different output frames. If NO, 2 such compositions would yield the
     same frame. The media pipeline may me able to avoid some duplicate processing when containsTweening is NO */
    var containsTweening: Bool = true
    
    /* List of video track IDs required to compose frames for this instruction. If the value of this property is nil, all source tracks will be considered required for composition */
    var requiredSourceTrackIDs: [NSValue]?
    
    /* If for the duration of the instruction, the video composition result is one of the source frames, this property should
     return the corresponding track ID. The compositor won't be run for the duration of the instruction and the proper source
     frame will be used instead. The dimensions, clean aperture and pixel aspect ratio of the source buffer will be
     matched to the required values automatically */
    var passthroughTrackID: CMPersistentTrackID = kCMPersistentTrackID_Invalid // if not a passthrough instruction
    
    init(timeRange: CMTimeRange, watermarkImage: CGImage, watermarkFrame: CGRect) {
        self.watermarkImage = watermarkImage
        self.watermarkFrame = watermarkFrame
        self.timeRange = timeRange
    }
}


class VideoOverlayProcessor {
    let inputURL: URL
    let outputURL: URL
    
    var outputPresetName: String = AVAssetExportPresetHighestQuality
    
    private var overlays: [BaseOverlay] = []
    
    var videoSize: CGSize {
        let asset = AVURLAsset(url: inputURL)
        return asset.tracks(withMediaType: AVMediaType.video).first?.naturalSize ?? CGSize.zero
    }
    
    var videoDuration: TimeInterval {
        let asset = AVURLAsset(url: inputURL)
        return asset.duration.seconds
    }
    
    private var asset: AVAsset {
        return AVURLAsset(url: inputURL)
    }
    
    // MARK: Initializers
    
    init(inputURL: URL, outputURL: URL) {
        self.inputURL = inputURL
        self.outputURL = outputURL
    }
    
    // MARK: Processing
    
    func process(_ completionHandler: @escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let composition = AVMutableComposition()
        let asset = AVURLAsset(url: inputURL)
        
        guard let videoTrack = asset.tracks(withMediaType: AVMediaType.video).first else {
            completionHandler(nil)
            return
        }
        
        guard let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid)) else {
            completionHandler(nil)
            return
        }
        
        let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)

        do {
            try compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: CMTime.zero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            completionHandler(nil)
            return
        }
        
        if let audioTrack = asset.tracks(withMediaType: AVMediaType.audio).first {
            let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))

            do {
                try compositionAudioTrack?.insertTimeRange(timeRange, of: audioTrack, at: CMTime.zero)
            } catch {
                completionHandler(nil)
                return
            }
        }

        let overlayLayer = CALayer()
        let videoLayer = CALayer()
        overlayLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        overlayLayer.addSublayer(videoLayer)
        
        overlays.forEach { (overlay) in
            let layer = overlay.layer
            layer.add(overlay.startAnimation, forKey: "startAnimation")
            layer.add(overlay.endAnimation, forKey: "endAnimation")
            overlayLayer.addSublayer(layer)
        }

        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: overlayLayer)

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        _ = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack

        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: outputPresetName) else {
            completionHandler(nil)
            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously { () -> Void in
            completionHandler(exportSession)
        }
    }
    
    func addOverlay(_ overlay: BaseOverlay) {
        overlays.append(overlay)
    }
}

class BaseOverlay {
    let frame: CGRect
    let delay: TimeInterval
    let duration: TimeInterval
    let backgroundColor: UIColor
    
    var startAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = timeRange.start.seconds == 0.0 ? 1.0 : 0.0
        animation.toValue = 1.0
        animation.beginTime = AVCoreAnimationBeginTimeAtZero + timeRange.start.seconds
        animation.duration = 0.01 // WORKAROUND: we have to change the duration to avoid animating initial phase
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    var endAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.beginTime = AVCoreAnimationBeginTimeAtZero + timeRange.start.seconds + timeRange.duration.seconds
        animation.duration = 0.01 // WORKAROUND: we have to change the duration to avoid animating final phase
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    var layer: CALayer {
        fatalError("Subclasses need to implement the `layer` property.")
    }
    
    var timeRange: CMTimeRange {
        let timescale: Double = 1000
        
        let startTime = CMTimeMake(value: Int64(delay*timescale), timescale: Int32(timescale))
        let durationTime = CMTimeMake(value: Int64(duration*timescale), timescale: Int32(timescale))
        
        return CMTimeRangeMake(start: startTime, duration: durationTime)
    }
    
    init(frame: CGRect,
         delay: TimeInterval,
         duration: TimeInterval,
         backgroundColor: UIColor = UIColor.clear) {
        
        self.frame = frame
        self.delay = delay
        self.duration = duration
        self.backgroundColor = backgroundColor
    }
}

class ImageOverlay: BaseOverlay {
    let image: UIImage
    
    override var layer: CALayer {
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.backgroundColor = backgroundColor.cgColor
        imageLayer.frame = frame
        imageLayer.opacity = 0.0
        
        return imageLayer
    }
    
    init(image: UIImage,
         frame: CGRect,
         delay: TimeInterval,
         duration: TimeInterval,
         backgroundColor: UIColor = UIColor.clear) {
        
        self.image = image
        
        super.init(frame: frame, delay: delay, duration: duration, backgroundColor: backgroundColor)
    }
}
extension UIImage {
        func imageWithColor(tintColor: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0);
            context.setBlendMode(.normal)

            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
            context.clip(to: rect, mask: self.cgImage!)
            tintColor.setFill()
            context.fill(rect)

            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            return newImage
        }
    }

extension FileManager {
func removeItemIfExisted(_ url:URL) -> Void {
    if FileManager.default.fileExists(atPath: url.path) {
        do {
            try FileManager.default.removeItem(atPath: url.path)
        }
        catch {
            print("Failed to delete file")
        }
    }
}
}
