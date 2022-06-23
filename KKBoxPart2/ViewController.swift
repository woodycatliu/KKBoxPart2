//
//  ViewController.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/22.
//

import UIKit
import MWFeedParser

class ViewController: UIViewController {
    var parser: MWFeedParser!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")!
        print("url:", url)
        parser = MWFeedParser(feedURL: url)
        parser.delegate = self
        parser.parse()
    }


}

extension ViewController: MWFeedParserDelegate {
    
    func feedParserDidStart(_ parser: MWFeedParser!) {
        
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        print("info:", info)
    }
    
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        if let array = item.enclosures as? NSArray,
           let first = array.firstObject as? NSDictionary {
            print("first:", first)
        }
//           let data = first.data(using: .utf8) {
//            print("enclosures:", data)
//        }
        
    }
    
    
    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        print("error:", error)
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        
    }
    

    
}
