//
//  TweetTableViewCell.swift
//  SmartTag
//
//  Created by Trương Thắng on 4/7/17.
//  Copyright © 2017 Trương Thắng. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let profileImageUrl = tweet?.user.profileImageURL {
            if let imageData = try? Data(contentsOf: profileImageUrl) {
                tweetProfileImageView.image = UIImage(data: imageData)
            }
        }
        if let create = tweet?.created {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "VI")
            if Date().timeIntervalSince(create) > 24 * 60 * 60 {
                dateFormatter.dateStyle = .short
            } else {
                dateFormatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = dateFormatter.string(from: create)
        }
        tweetUserLabel?.text = tweet?.user.name ?? ""
        tweetTextLabel?.text = tweet?.text ?? ""
        
    }
    
    override func prepareForReuse() {
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = ""
        tweetUserLabel?.text = ""
        tweetTextLabel?.text = ""
    }
}
