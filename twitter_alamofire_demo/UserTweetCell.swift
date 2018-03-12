//
//  UserTweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Sarah Villegas  on 3/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class UserTweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timeLapsLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    // Buttons
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!{
        didSet{
            
            self.profileImageView.af_setImage(withURL: tweet.user.profileImageURL!)
            // Labels
            self.nameLabel.text = tweet.user.name
            let strHandle = "@" + tweet.user.screenName!
            self.userHandleLabel.text = strHandle
            self.timeLapsLabel.text = tweet.createdAtString
            self.tweetLabel.text = tweet.text
            
            if tweet.retweetCount == 0{
                
                self.retweetCountLabel.text = ""
            }
            else{
                
                let strRT = String(tweet.retweetCount)
                self.retweetCountLabel.text = strRT
            }
            
            if tweet.favoriteCount == 0 {
                
                self.favoriteCountLabel.text = ""
            }
            else{
                
                let strFav = String(tweet.favoriteCount)
                self.favoriteCountLabel.text = strFav
            }
            
            // Buttons
            if tweet.favorited{
                
                let favRed = #imageLiteral(resourceName: "favor-icon-red.png")
                favoriteButton.setBackgroundImage(favRed, for: UIControlState.normal)
            }
            if tweet.retweeted{
                
                let rtGreen = #imageLiteral(resourceName: "retweet-icon-green.png")
                retweetButton.setBackgroundImage(rtGreen, for: UIControlState.normal)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if (profileImageView != nil){
            
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func RetweetTweet(_ sender: Any) {
        
        // Already A Retweet
        if tweet.retweeted{
            
            tweet.retweetCount -= 1
            tweet.retweeted = false
            
            // Fix UI For 0
            if retweetCountLabel.text == "1"{
                
                retweetCountLabel.text = ""
            }
            else{
                
                let strRTCount = String(tweet.retweetCount)
                retweetCountLabel.text = strRTCount
                
            }
            
            // Set Button Image
            let rtGrey = #imageLiteral(resourceName: "retweet-icon.png")
            retweetButton.setBackgroundImage(rtGrey, for: UIControlState.normal)
            
            // UnRetweet Tweet
            APIManager.shared.unretweet(tweet, completion: { (retweet, error) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                }
                else if let retweet = retweet {
                    print("Successfully unretweeted the following Tweet: \n\(retweet.text)")
                }
            })
            
        }// end if
        else{
            
            tweet.retweetCount += 1
            tweet.retweeted = true
            
            // Set Label
            let strRTCount = String(tweet.retweetCount)
            retweetCountLabel.text = strRTCount
            
            // Set Button
            let rtGreen = #imageLiteral(resourceName: "retweet-icon-green.png")
            retweetButton.setBackgroundImage(rtGreen, for: UIControlState.normal)
            
            // Retweet Tweet
            APIManager.shared.retweet(tweet, completion: { (retweet, error) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                }
                else if let retweet = retweet {
                    print("Successfully retweeted the following Tweet: \n\(retweet.text)")
                }
            })
        }// end else
    }
    
    
    @IBAction func favoriteTweet(_ sender: Any) {
        
        // Tweet Already favorited
        if tweet.favorited{
            
            tweet.favorited = false
            tweet.favoriteCount -= 1
            
            // Set Labels
            if favoriteCountLabel.text == "1"{
                
                favoriteCountLabel.text = ""
            }
            else{
                
                let strFav = String(tweet.favoriteCount)
                favoriteCountLabel.text = strFav
            }
            
            // Set Button
            let favGrey = #imageLiteral(resourceName: "favor-icon.png")
            favoriteButton.setBackgroundImage(favGrey, for: UIControlState.normal)
            
            // UnFavorite Tweet
            APIManager.shared.unfavorite(tweet, completion: { (tweet, error) in
                if let error = error{
                     print("Error unfavoriting tweet: \(error.localizedDescription)")
                }
                else if let tweet = tweet{
                     print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            })
        }// end if
        else{
            
            tweet.favorited = true
            tweet.favoriteCount += 1
            
            // Set Label
            let strFavCount = String(tweet.favoriteCount)
            favoriteCountLabel.text = strFavCount
            
            // Set Button
            let favRed = #imageLiteral(resourceName: "favor-icon-red.png")
            favoriteButton.setBackgroundImage(favRed, for: UIControlState.normal)
            
            // Favorite Tweet
            APIManager.shared.favorite(tweet, completion: { (tweet, error) in
                if let error = error{
                    print("Error favoriting tweet: \(error.localizedDescription)")
                }
                else if let tweet = tweet{
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            })
        }// end else
        
    }
    

}
