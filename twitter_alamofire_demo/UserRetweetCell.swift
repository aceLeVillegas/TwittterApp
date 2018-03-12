//
//  UserRetweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Sarah Villegas  on 3/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class UserRetweetCell: UITableViewCell {

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
    
    var retweet: Tweet! {
        didSet{
            profileImageView.af_setImage(withURL: retweet.user.profileImageURL!)
            
            // Set Labels
            nameLabel.text = retweet.user.name
            userHandleLabel.text = retweet.user.screenName
            timeLapsLabel.text = retweet.createdAtString
            tweetLabel.text = retweet.text
            
            if retweet.retweetCount == 0{
                
                retweetCountLabel.text = ""
            }
            else{
                
                let strRTCount = String(retweet.retweetCount)
                retweetCountLabel.text = strRTCount
            }
            
            if retweet.favoriteCount == 0{
                
                favoriteCountLabel.text = ""
            }
            else{
                
                let strFavCount = String(retweet.favoriteCount)
                favoriteCountLabel.text = strFavCount
            }
            
            
            
            // Buttons
            if retweet.favorited{
                
                let favRed = #imageLiteral(resourceName: "favor-icon-red.png")
                favoriteButton.setBackgroundImage(favRed, for: UIControlState.normal)
            }
            if retweet.retweeted{
                
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
    
    @IBAction func retweetTweet(_ sender: Any) {
        
        // Already Retweeted
        if retweet.retweeted{
            
            retweet.retweeted = false
            retweet.retweetCount -= 1
            
            // Set Labels
            if retweetCountLabel.text == "1"{
                
                retweetCountLabel.text = ""
            }
            else{
                
                let strRTCount = String(retweet.retweetCount)
                retweetCountLabel.text = strRTCount
            }
            
            // Set Button
            let rtGrey = #imageLiteral(resourceName: "retweet-icon.png")
            retweetButton.setBackgroundImage(rtGrey, for: UIControlState.normal)
            
            // Unretweet Tweet
            APIManager.shared.unretweet(retweet, completion: { (retweet, error) in
                if let retweet = retweet{
                    print("Sucessfully unretweeted the tweet: \(retweet.text)")
                }
                else if let error = error{
                    
                    print("Error unretweeted the tweet: \(error.localizedDescription) ")
                }
            })
        }// end if
        else{
            
            retweet.retweeted = true
            retweet.retweetCount += 1
            
            // Set Label
            let strRTCount = String(retweet.retweetCount)
            retweetCountLabel.text = strRTCount
            
            // Set Button
            let rtGreen = #imageLiteral(resourceName: "retweet-icon-green.png")
            retweetButton.setBackgroundImage(rtGreen, for: UIControlState.normal)
            
            // Retweet Tweet
            APIManager.shared.retweet(retweet, completion: { (retweet, error) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                }
                else if let retweet = retweet {
                    print("Successfully retweeted the following Tweet: \n\(retweet.text)")
                }
            })
        }
    }
    
    
    @IBAction func favoriteTweet(_ sender: Any) {
        
        if retweet.favorited{
         
            retweet.favoriteCount -= 1
            retweet.favorited = false
            
            // Set Label
            if favoriteCountLabel.text == "1"{
                
                favoriteCountLabel.text = ""
            }
            else{
                
                let strFavCount = String(retweet.favoriteCount)
                favoriteCountLabel.text = strFavCount
            }
            
            // Set Button
            let favGrey = #imageLiteral(resourceName: "retweet-icon.png")
            favoriteButton.setBackgroundImage(favGrey, for: UIControlState.normal)
            
            // unFavorite Tweet
            APIManager.shared.unfavorite(retweet, completion: { (retweet, error) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                }
                else if let retweet = retweet {
                    print("Successfully unfavorited the following Tweet: \n\(retweet.text)")
                }
            })
            
        }// end if
        else{
            
            retweet.favorited = true
            retweet.favoriteCount += 1
            
            // Set Label
            let strFavCount = String(retweet.favoriteCount)
            favoriteCountLabel.text = strFavCount
            
            // Set Button
            let favRed = #imageLiteral(resourceName: "favor-icon-red.png")
            favoriteButton.setBackgroundImage(favRed, for: UIControlState.normal)
            
            // Favorite Tweet
            APIManager.shared.favorite(retweet, completion: { (retweet, error) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                }
                else if let retweet = retweet {
                    print("Successfully favorited the following Tweet: \n\(retweet.text)")
                }
            })
        }
        
    }
    
    
    

}
