//
//  MWFeedParserTest.swift
//  KKBoxPart2Tests
//
//  Created by Woody on 2022/6/23.
//

import XCTest
@testable import KKBoxPart2
import MWFeedParser

class MWFeedParserTest: XCTestCase {
    
    
    var parser: MWFeedParser!
       
    override func setUp() {
        let url = try! XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "sounds", withExtension: "rss"))
        
        parser = MWFeedParser(feedURL: url)
        parser.delegate = self
        parser.parse()
        super.setUp()
    }
    
    override func tearDown() {
        parser = nil
    }
    
    
    func testWhat() {
        
    }
    
}


extension MWFeedParserTest: MWFeedParserDelegate {
    
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
        
    }
    
    
    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        print("error:", error)
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        
    }
    

    
}
