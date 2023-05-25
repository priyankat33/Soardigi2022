//
//  CountryCodeCell.swift
//  Practina
//
//  Created by Chandan on 28/05/19.
//  Copyright © 2019 Chandan. All rights reserved.
//

import UIKit

protocol collectionCell_delegate {
    func didPressed(value:String,sectionValue:Int, isFromUpcoming:Bool,eventName:String)
}

protocol SliderCollectionCell {
    func didPressedSlide(value:String)
}

protocol CategoriasTableViewCellDelegate : AnyObject {
    func categoryTapped(_ cell: CategoryTVC, categoriasID:String)
}
class SectionHeadingCell: UITableViewCell {
    @IBOutlet weak var headingLBL: UILabel!
    @IBOutlet weak var forwardBtn: UIButton!
 }

class CountryCodeCell: UITableViewCell {
   
    @IBOutlet weak fileprivate var countryNameLBL: UILabel!
    @IBOutlet weak fileprivate var countryFlagImgView: UIImageView!
    var objCountryModel:CountryModel?{
        didSet{
            guard let countryName = objCountryModel?.name,let countryShortNameCode = objCountryModel?.phoneCode else{return}
           
            countryNameLBL.text =  "(\(countryShortNameCode)) \(countryName)"
            countryFlagImgView.image = objCountryModel?.flag
           
        }
    }
}

class PageCodeCell: UITableViewCell {
   
    @IBOutlet weak var countryNameLBL: UILabel!
    
}

class BusinessCategoryCell: UITableViewCell {
    @IBOutlet weak var bussinessLBL:UILabel!
    @IBOutlet weak var editBtn:UIButton!
    @IBOutlet weak var categoryLBL:UILabel!
    @IBOutlet weak var imageViewCat:CustomImageView!
}


class CreateCustomRequestCell: UITableViewCell {
    @IBOutlet weak var eventLBL:UILabel!
    @IBOutlet weak var dateLBL:UILabel!
}

class ChatCell: UITableViewCell {
    @IBOutlet weak var messageLBL:UILabel!
    @IBOutlet weak var msgView:CustomView!
    @IBOutlet weak var sampleBtn:CustomButton!
    @IBOutlet weak var downloadBtn:CustomButton!
    @IBOutlet weak var dateView:CustomView!
    @IBOutlet weak var dateLBL:UILabel!
    @IBOutlet weak var imgView:CustomImageView!
    @IBOutlet weak var imgViewCustom:CustomView!
}

class CategoryTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   @IBOutlet weak var collectionView: UICollectionView!
    weak var parent:HomeVC?
    weak var delegate : CategoriasTableViewCellDelegate?
    var deleg:collectionCell_delegate?
    var sectionValue:Int = 1
    
    
    fileprivate var categoryImagesResponseModel:[CategoryImagesResponseModel] = [CategoryImagesResponseModel]()
    fileprivate var events:[Event] = [Event]()
   
    var imageResponseModel:[CategoryImagesResponseModel]? {
        didSet {
            self.categoryImagesResponseModel = imageResponseModel ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            }
        
    }
    
    var eventsDetail:[Event]? {
        didSet {
            self.events = eventsDetail ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionValue == 0 ? eventsDetail?.count ?? 0 : categoryImagesResponseModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sectionValue == 0 {
            let data = eventsDetail?[indexPath.item].category
            if let del = deleg{
                del.didPressed(value: data?.id ?? "0",sectionValue:sectionValue, isFromUpcoming : true,eventName: data?.name ?? "")
            }
        } else {
            let data = categoryImagesResponseModel[indexPath.item]
            if let del = deleg{
                del.didPressed(value: data.id ?? "0",sectionValue:sectionValue, isFromUpcoming : false, eventName:"")
            }
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CategoryCVC" , for: indexPath) as! CategoryCVC
        if sectionValue == 0 {
            let data = eventsDetail?[indexPath.item]
            cell.lbl.text = data?.date ?? ""
            cell.lbl.isHidden = false
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: URL(string: data?.thumbnail ?? "" ), placeholder: nil, options: nil) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        } else {
            let data = categoryImagesResponseModel[indexPath.item]
            cell.lbl.text = "False"
           
            cell.lbl.isHidden = data.is_paid == 1 ? false : true
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil, options: nil) { result in
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
    
}




class SliderTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var Scrollinftimer = Timer()
    var scrollImg: Int = 0
   @IBOutlet weak var collectionView: UICollectionView!
    var sliderCollectionCell:SliderCollectionCell?
   fileprivate var sliderResponseModel:[HomeSliderResponseModel] = [HomeSliderResponseModel]()
    var homeSliderResponseModel:[HomeSliderResponseModel]? {
        didSet {
            self.sliderResponseModel = homeSliderResponseModel ?? []
                self.collectionView.reloadData()
            }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderResponseModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"SliderImageCVC" , for: indexPath) as! SliderImageCVC
        let data = sliderResponseModel[indexPath.item]
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil, options: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
//        var rowIndex = indexPath.item
//           let Numberofrecords : Int = sliderResponseModel.count - 1
//           if (rowIndex < Numberofrecords)
//           {
//               rowIndex = (rowIndex + 0) // 1
//           }
//           else
//           {
//               rowIndex = 0
//           }
        Scrollinftimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)

        return cell
    }
    
    @objc func autoScroll()
    {
        
        let totalCount = sliderResponseModel.count-1
        
        if scrollImg == totalCount {
            scrollImg = 0
        }else {
            scrollImg += 1
        }
        
      
        DispatchQueue.main.async {
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: self.scrollImg, section: 0))?.frame
            if self.scrollImg == 0{
                self.collectionView.scrollRectToVisible(rect!, animated: false)
            }else {
                self.collectionView.scrollRectToVisible(rect!, animated: true)
            }
        
        }
        
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = sliderResponseModel[indexPath.item]
        if let del = sliderCollectionCell{
            del.didPressedSlide(value: data.sliderCategoryResponseModel?.id ?? "0")
        }
    }
    
}


class SliderImageCVC:UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

class CategoryCVC:UICollectionViewCell {
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var lbl: UILabel!
    
}
