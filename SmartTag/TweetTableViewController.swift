//
//  TweetTableViewController.swift
//  SmartTag
//
//  Created by Trương Thắng on 4/6/17.
//  Copyright © 2017 Trương Thắng. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController {
    var tweets: [Array<Twitter.Tweet>] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private var twitterRequest : Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets{[unowned self] newTweets in
                DispatchQueue.main.async {
                    guard request == self.lastTwitterRequest else {
                        return
                    }
                    guard !newTweets.isEmpty else {
                        return
                    }
                    self.tweets.insert(newTweets, at: 0)
                    if self.tweets.count == 1 {
                        self.tableView.reloadData()
                    } else {
                        self.tableView.insertSections([0], with: .fade)
                    }
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
       searchText = "#standford"
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet
        return cell
    }

}

// MARK: - <#Mark#>

extension TweetTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === searchTextField {
            searchText = searchTextField.text ?? ""
        }
        return true
    }
}
