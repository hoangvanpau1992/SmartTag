//
//  SmashTweetTableViewController.swift
//  SmartTag
//
//  Created by Trương Thắng on 4/9/17.
//  Copyright © 2017 Trương Thắng. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
    let container = AppDelegate.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets:[Twitter.Tweet]) {
        print("starting database load")
        container.performBackgroundTask { context in
            for tweetInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: tweetInfo, in: context )
            }
            try? context.save()
            self.printDatabaseStatistics()
            print("finish database load")
        }
    }
    
    private func printDatabaseStatistics() {
        
        if Thread.isMainThread {
            print("on main queue")
        } else {
            print("off main queue")
        }
        
        let tweetRequest : NSFetchRequest<Tweet> = Tweet.fetchRequest()
        if let tweetCount = (try? AppDelegate.context.fetch(tweetRequest))?.count {
            print("\(tweetCount) tweet(s)")
        }
        let twitterRequest : NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        if let twitterCount = (try? AppDelegate.context.count(for: twitterRequest)) {
            print("\(twitterCount) tweet(s)")
        }
    }
 
}
