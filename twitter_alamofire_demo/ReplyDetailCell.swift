//
//  ReplyDetailCell.swift
//  twitter_alamofire_demo
//
//  Created by Sarah Villegas  on 3/7/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ReplyDetailCell: UITableViewCell {

    // Profile Photo
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    // Tweet Details
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLapsLabel: UILabel!
    @IBOutlet weak var recipientUsernameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetMessageLabel: UILabel!
    
    // Button Counts
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!{
        didSet{
            
            self.profilePhotoImageView.af_setImage(withURL: tweet.user.profileImageURL!)
            self.nameLabel.text = tweet.user.name
            self.timeLapsLabel.text = tweet.createdAtString
            self.usernameLabel.text = tweet.user.screenName
            self.tweetMessageLabel.text = tweet.text
            self.recipientUsernameLabel.text = tweet.replyTo
            
            // Set Counts
            if tweet.retweetCount == 0{
                
                self.retweetCountLabel.text = ""
            }
            else{
                
                self.retweetCountLabel.text = String(tweet.retweetCount)
            }
            
            if tweet.favoriteCount == 0{
                
                self.favoriteCountLabel.text = ""
            }
            else{
                
                self.favoriteCountLabel.text = String(tweet.favoriteCount)
            }
            
            
        }
    }
    
    
    @IBAction func retweetResponce(_ sender: Any) {
        
        let uncoloredHeart = #imageLiteral(resourceName: "retweet-icon.png")
        self.retweetButton.setBackgroundImage(uncoloredHeart, for: UIControlState.normal)
        
        
        
    }
    
    @IBAction func favoriteResponce(_ sender: Any) {
        
        let uncoloredHeart = #imageLiteral(resourceName: "favor-icon.png")
        self.favoriteButton.setBackgroundImage(uncoloredHeart, for: UIControlState.normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
