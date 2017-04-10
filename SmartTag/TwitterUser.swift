//
//  TwitterUser.swift
//
//
//  Created by Trương Thắng on 4/9/17.
//
//

import UIKit
import CoreData
import Twitter

class TwitterUser: NSManagedObject {
    class func findOrCreateTweet(matching twitterInfo: Twitter.User, in context: NSManagedObjectContext) throws -> TwitterUser {
        let request : NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "handle = %@", twitterInfo.screenName)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "TweetUser.findOrCreateTweet: dataBase inconsistency")
                return matches.first!
            }
        } catch {
            throw error
        }
        
        let twitterUser = TwitterUser(context: context)
        twitterUser.handle = twitterInfo.screenName
        twitterUser.name = twitterInfo.name
        return twitterUser
    }
}
