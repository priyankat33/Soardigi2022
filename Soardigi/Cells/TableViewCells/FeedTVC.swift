//
//  FeedTVC.swift
//  Soardigi
//
//  Created by Developer on 01/02/23.
//

import UIKit
import youtube_ios_player_helper
class FeedTVC: UITableViewCell {
    @IBOutlet weak var nameLBl:UILabel!
    @IBOutlet weak var dateLBl:UILabel!
    @IBOutlet weak var likeLBl:UILabel!
    @IBOutlet weak var imageViewFeed:UIImageView!
    @IBOutlet weak var likeBtn:UIButton!
    @IBOutlet weak var palyerView:YTPlayerView!
    @IBOutlet weak var readBtn:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class SubscriptionTVC: UITableViewCell {
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var subscriptionLbl:UILabel!
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var statusLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
