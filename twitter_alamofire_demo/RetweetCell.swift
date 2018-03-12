//
//  RetweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Sarah Villegas  on 3/2/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class RetweetCell: UITableViewCell {

    // Image Holders
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timeLapsLabel: UILabel!
    @IBOutlet weak var retweetUsernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // Counters for UIButtons
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    
    var rtInfo: Tweet?
    
    var tweet: Tweet!{
        didSet{
            
            self.retweetUsernameLabel.text = tweet.user.name
            
            self.rtInfo = Tweet(dictionary: tweet.retweetedStatus!)
            self.profilePhotoImageView.af_setImage(withURL: rtInfo!.user.profileImageURL!)
            self.usernameLabel.text = rtInfo!.user.name
            let userHandle = "@" + rtInfo!.user.screenName!
            self.userHandleLabel.text = userHandle
            
            self.timeLapsLabel.text = rtInfo!.createdAtString
            self.tweetLabel.text = rtInfo!.text
            
            
            if tweet.favoriteCount == 0{
                
                self.favoriteCount.text = ""
            }
            else{
                
                self.favoriteCount.text = String(rtInfo!.favoriteCount)
            }
            
            if tweet.retweetCount == 0{
                
                self.retweetCount.text = ""
            }
            else{
                
                self.retweetCount.text = String(rtInfo!.retweetCount)
            }
            
            if tweet.retweeted{
                
                let rtGreen = #imageLiteral(resourceName: "retweet-icon-green.png")
                retweetButton.setBackgroundImage(rtGreen, for: UIControlState.normal)
            }
            if tweet.favorited{
                
                let favRed = #imageLiteral(resourceName: "favor-icon-red.png")
                favoriteButton.setBackgroundImage(favRed, for: UIControlState.normal)
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if (profilePhotoImageView != nil){
            
            profilePhotoImageView.layer.masksToBounds = false
            profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.height/2
            profilePhotoImageView.clipsToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // Actions for UIButtons
    
    @IBAction func retweetTweet(_ sender: Any) {
        
        // Already retweeted Tweet
        if rtInfo!.retweeted {
            
            tweet.retweeted  = false
            tweet.retweetCount -= 1
            
            //Set Label
            if retweetCount.text == "1"{
                
                 self.retweetCount.text = ""
            }
            else{
                let minus1 = Int(retweetCount.text!)! - 1
                self.retweetCount.text =  String(minus1)
            }
           
            // Set Image
            let uncoloredHeart = #imageLiteral(resourceName: "favor-icon.png")
            self.retweetButton.setBackgroundImage(uncoloredHeart, for: UIControlState.normal)
            
            // Remove tweet
            APIManager.shared.unretweet(rtInfo!, completion: { (tweet, error) in
                if let  error = error {
                    print("Error unrewteet tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unrewteet the following Tweet: \n\(tweet.text)")
                }
            })
        }
        // First Retweet
        else{
            
            tweet.retweeted  = true
            tweet.retweetCount += 1
            // Set Label
            let add1 = Int(retweetCount.text!)! + 1
            self.retweetCount.text =  String(add1)
            //Set Image
            let coloredHeart = #imageLiteral(resourceName: "favor-icon-red.png")
            self.retweetButton.setBackgroundImage(coloredHeart, for: UIControlState.normal)
    
            APIManager.shared.retweet(rtInfo!, completion: { (tweet, error) in
                if let  error = error {
                    print("Error rewteet tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully rewteet the following Tweet: \n\(tweet.text)")
                }
            })
        }
       
    
    }
    
    
    @IBAction func FavoriteTweet(_ sender: Any) {
        
        // Already Favorited
        if rtInfo!.favorited {
            
            tweet.favorited = false
            tweet.favoriteCount -= 1
            // Set labels
            if favoriteCount.text == "1"{
                
                self.favoriteCount.text = ""
            }
            else{
                
                let minus1 = Int(favoriteCount.text!)! - 1
                self.favoriteCount.text =  String(minus1)
            }
            
            // Change Image
            let uncoloredHeart = #imageLiteral(resourceName: "favor-icon.png")
            self.favoriteButton.setBackgroundImage(uncoloredHeart, for: UIControlState.normal)
            
            // Remove Favorite
            APIManager.shared.unfavorite(tweet, completion: { (tweet, error) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            })
        }
        // First Time Favorite
        else{
            
            tweet.favorited = true
            tweet.favoriteCount += 1
            // Set Labels
            let add1 = Int(favoriteCount.text!)! + 1
            self.favoriteCount.text =  String(add1)
            //Change button
            let coloredHeart = #imageLiteral(resourceName: "favor-icon-red.png")
            self.favoriteButton.setBackgroundImage(coloredHeart, for: UIControlState.normal)

            // Add favorite
            APIManager.shared.favorite(tweet, completion: { (tweet, error) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            })
        }
    }
    
    
    
    
}
