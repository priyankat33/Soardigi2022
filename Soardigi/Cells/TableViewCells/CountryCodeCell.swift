//
//  CountryCodeCell.swift
//  Practina
//
//  Created by Chandan on 28/05/19.
//  Copyright © 2019 Chandan. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var categoryLBL:UILabel!
    @IBOutlet weak var imageViewCat:CustomImageView!
}

class CategoryTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   @IBOutlet weak var collectionView: UICollectionView!
    weak var parent:HomeVC?
    weak var delegate : CategoriasTableViewCellDelegate?
   fileprivate var categoryImagesResponseModel:[CategoryImagesResponseModel] = [CategoryImagesResponseModel]()
    var imageResponseModel:[CategoryImagesResponseModel]? {
        didSet {
            self.categoryImagesResponseModel = imageResponseModel ?? []
                self.collectionView.reloadData()
            }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImagesResponseModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CategoryCVC" , for: indexPath) as! CategoryCVC
        let data = categoryImagesResponseModel[indexPath.item]
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
    
}




class SliderTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   @IBOutlet weak var collectionView: UICollectionView!
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
}


class SliderImageCVC:UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

class CategoryCVC:UICollectionViewCell {
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var lbl: UILabel!
}
