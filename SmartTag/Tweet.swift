//
//  Tweet.swift
//  SmartTag
//
//  Created by Trương Thắng on 4/9/17.
//  Copyright © 2017 Trương Thắng. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet? {
        let request : NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet: dataBase inconsistency")
                return matches.first!
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.created = twitterInfo.created as NSDate
        tweet.text = twitterInfo.text
        tweet.twitter = try? TwitterUser.findOrCreateTweet(matching: twitterInfo.user, in: context)
        return tweet
    }
}
