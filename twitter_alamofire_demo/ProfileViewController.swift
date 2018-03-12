//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Sarah Villegas  on 3/9/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    // Images
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var loactionLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    var tweets: [Tweet] = []
    
    var curUser = User.current!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        
        // Set Up Images
        if curUser.profileImageURL != nil {
            
            profileImageView.af_setImage(withURL: curUser.profileImageURL!)
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
        }
        if curUser.bgImageURL != nil {
            
            backgroundImageView.af_setImage(withURL: curUser.bgImageURL!)
            
        }
       
        // Set Up Labels
        profileNameLabel.text = curUser.name
        userHandleLabel.text = "@" + curUser.screenName!
        loactionLabel.text = curUser.location
        let strFollowing = String(describing: curUser.friendsCount)
        followingCountLabel.text = strFollowing
        
        let strFollowers = String(describing: curUser.followerCount)
        followersCountLabel.text = strFollowers
        
        
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 130
        
        loadUserTweets()
    }
    
    func loadUserTweets(){
        
        APIManager.shared.usersTweetTimeline(curUser.screenName!) { (tweets, error) in
            if let tweets = tweets as? [Tweet]{
                self.tweets = tweets
                self.tweetTableView.reloadData()
            }
            if let error = error{
                print("Error getting user timeline: " + error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tweets[indexPath.row].retweetedStatus as? [String: Any]) != nil{
            
            let cell = tweetTableView.dequeueReusableCell(withIdentifier: "UserRetweetCell", for: indexPath) as! UserRetweetCell
            
            cell.retweet = Tweet(dictionary: tweets[indexPath.row].retweetedStatus!)
            return cell
        }
        else{
            
            let cell = tweetTableView.dequeueReusableCell(withIdentifier: "UserTweetCell", for: indexPath) as! UserTweetCell
            
            cell.tweet = tweets[indexPath.row]
            return cell
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
