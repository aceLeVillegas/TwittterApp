//
//  TweetDetailsViewController.swift
//  twitter_alamofire_demo
//
//  Created by Sarah Villegas  on 3/7/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController{
//    , UITableViewDelegate, UITableViewDataSource
    @IBOutlet weak var detailsTableView: UITableView!
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        detailsTableView.delegate = self
//        detailsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
////        if tweet?.retweetedStatus != nil{
////
//        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "RetweetInfoCell", for: indexPath)
////
////        }
////
//        return cell
//
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
////        switch indexPath.row {
////        // Tweet
////        case 1:
////            if tweet?.retweetedStatus != nil{
////
////                    return height
////            }
////        //Reweet
////        case 2:
////            if tweet?.retweetedStatus == nil{
////
////                return 0.0
////            }
////
////        default:
////            return 5.0
////        }
//        return 0.1
//        
//
//    }

}
