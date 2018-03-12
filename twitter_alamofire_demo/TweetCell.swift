//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage


class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timeLapsLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // Counters for buttons
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    
    var tweet: Tweet! {
        didSet {
            
            self.profilePhotoImageView.af_setImage(withURL: tweet.user.profileImageURL!)
            
            // Find protos in tweet
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: tweet.text, options: [], range: NSRange(location: 0, length: tweet.text.utf16.count))
            
//            print("************************ Tweet Text *****************************")
//            print(tweet.text)
//            print("**********************************************************************")
//            for match in matches {
//                guard let range = Range(match.range, in: tweet.text) else { continue }
//                let url = tweet.text[range]
//
//                print("************************ Match Tweet Text *****************************")
//                print(match)
//                print("**********************************************************************")
//                print("************************ URL for Photos *****************************")
//                print(url)
//            print("**********************************************************************")
//
//                // Make UIImageView & alamofireimage
//            }
            self.tweetTextLabel.text = tweet.text
            self.usernameLabel.text = tweet.user.name
            
            
            let userHandle = "@" + tweet.user.screenName!
            self.userHandleLabel.text = userHandle
            self.timeLapsLabel.text = tweet.createdAtString
            // Button counts
            if tweet.retweetCount == 0{
                
                self.retweetCountLabel.text = ""
            }
            else{
               
                self.retweetCountLabel.text = String(tweet.retweetCount)
            }
            
            if tweet.favoriteCount == 0 {
                
                self.favoriteCountLabel.text = ""
            }
            else{
                
                self.favoriteCountLabel.text = String(tweet.favoriteCount)
            }
            
            // Button UI
            if tweet.favorited {
                let coloredHeart = #imageLiteral(resourceName: "favor-icon-red.png")
                favoriteButton.setBackgroundImage(coloredHeart, for: UIControlState.normal)
                
            }
            else{
            
                let uncoloredHeart = #imageLiteral(resourceName: "favor-icon.png")
                favoriteButton.setBackgroundImage(uncoloredHeart, for: UIControlState.normal)
            }
            
            if tweet.retweeted {
               
                let coloredRT = #imageLiteral(resourceName: "retweet-icon-green.png")
                retweetButton.setBackgroundImage(coloredRT, for: UIControlState.normal)
            }
            else{
                
                let uncoloredRT = #imageLiteral(resourceName: "retweet-icon.png")
                retweetButton.setBackgroundImage(uncoloredRT, for: UIControlState.normal)
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
    
    // Buttons reactions 
    
    @IBAction func retweetTweet(_ sender: Any) {
        
        // Alreadlt retweeted Tweet
        if tweet.retweeted {
            
            tweet.retweeted  = false
            tweet.retweetCount -= 1
            
            // Set Label
            if retweetCountLabel.text == "1"{
                
                retweetCountLabel.text = ""
            }
            else{
                
                let minus1 = Int(retweetCountLabel.text!)! - 1
                retweetCountLabel.text =  String(minus1)
            }
            
            // Set Button
            let uncoloredRT = #imageLiteral(resourceName: "retweet-icon.png")
            retweetButton.setBackgroundImage(uncoloredRT, for: UIControlState.normal)
            
            // unRetweet Tweet
            APIManager.shared.unretweet(tweet, completion: { (tweet, error) in
                if let  error = error {
                    print("Error unrewteet tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unrewteet the following Tweet: \n\(tweet.text)")
                }
            })
        }
            
        // First Retweet for Tweet
        else{
            
            tweet.retweeted  = true
            tweet.retweetCount += 1
            
            // Set Label
            let add1 = Int(retweetCountLabel.text!)! + 1
            retweetCountLabel.text =  String(add1)
            // Set Button
            let coloredRT = #imageLiteral(resourceName: "retweet-icon-green.png")
            retweetButton.setBackgroundImage(coloredRT, for: UIControlState.normal)
        }
        // Retweet Tweet
        APIManager.shared.retweet(tweet) { (tweet, error) in
            if let  error = error {
                print("Error unfavoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully retweet the following Tweet: \n\(tweet.text)")
            }
        }
        
    }
        
        
    @IBAction func favoriteTweet(_ sender: Any) {
        
        // Already Favorited Tweet
        if tweet.favorited {
            
            tweet.favorited = false
            tweet.favoriteCount -= 1
            
            // Set Label
            if favoriteCountLabel.text == "1" {
                
                self.favoriteCountLabel.text = ""
            }
            else{
                
                let minus1 = Int(favoriteCountLabel.text!)! - 1
                self.favoriteCountLabel.text =  String(minus1)

            }
            
            // Set Image 
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
        // First Favorite Tweet
        else{
            
            tweet.favorited = true
            tweet.favoriteCount += 1
            
            // Set Leabel
            if favoriteCountLabel.text == "" {
                
                self.favoriteCountLabel.text = "1"
            }
            else{
                
                let add1 = Int(favoriteCountLabel.text!)! + 1
                self.favoriteCountLabel.text =  String(add1)
                
            }
           // Set Image
           let coloredHeart = #imageLiteral(resourceName: "favor-icon-red.png")
           self.favoriteButton.setBackgroundImage(coloredHeart, for: UIControlState.normal)
            
            // Add favorite
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
        
        
        
    }
    
    
        
    override func layoutSubviews() {
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }
        
        
    
}
