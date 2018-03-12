//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {

    var name: String?
    var screenName: String?
    var location: String?
    var url: String?
    var description: String?
    var verified: Bool
    var followerCount: Int
    var friendsCount: Int
    var statusesCount: Int
    var bgImageURL: URL?
    var profileImageURL: URL?
    var dictionary: [String: Any]?
    private static var _current: User?
    
    init(dictionary: [String: Any]) {
        
        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        self.screenName = dictionary["screen_name"] as? String
        self.location = dictionary["location"] as? String
        self.url = dictionary["url"] as? String
        self.description = dictionary["description"] as? String
        self.verified = dictionary["verified"] as! Bool
        self.followerCount = dictionary["followers_count"] as! Int
        self.friendsCount = dictionary["friends_count"] as! Int
        self.statusesCount = dictionary["statuses_count"] as! Int
        
        if let bgImageStr = dictionary["profile_background_image_url"] as? String{
            self.bgImageURL =  URL(string: bgImageStr)!
        }
        
        // http://...
        if let profileImageStr = dictionary["profile_image_url"] as? String{
             self.profileImageURL = URL(string: profileImageStr)!
        }
        
    }
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
}
