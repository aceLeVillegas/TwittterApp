//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshcontrol: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        
        refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(TimelineViewController.loadToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshcontrol, at: 0)
        
        loadTweets()
    }
    
    func loadTweets(){
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshcontrol.endRefreshing()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
    }
    
    @objc func loadToRefresh(_ refreshControl: UIRefreshControl){
        
        loadTweets()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("-=-=-=-=-=-=-=-=-==-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=--=-=-==-=-=-")
//        print(tweets[indexPath.row].text)
//        print("Retweeted  \(tweets[indexPath.row].retweetedStatus)")
//        print("-=-=-=-=-=-=-=-=-==-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=--=-=-==-=-=-")
        
        if (tweets[indexPath.row].retweetedStatus as? [String: Any]) != nil{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RetweetCell", for: indexPath) as! RetweetCell
            
            cell.tweet = tweets[indexPath.row]
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            
            cell.tweet = tweets[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TweetDetailsViewController
        
        let cell = sender as! UITableViewCell
        
        if let indexPath = tableView.indexPath(for: cell){
            
            destination.tweet = tweets[indexPath.row]
            
            print("^&^&&^&^&^&^&^&^&^&^&^&^&^&^&&^^&^^&^&^&^&^&^^&^&^&^&^&^^&^&")
            print(tweets[indexPath.row])
            print("^&^&&^&^&^&^&^&^&^&^&^&^&^&^&&^^&^^&^&^&^&^&^^&^&^&^&^&^^&^&")
        }
    }
   
    
}
