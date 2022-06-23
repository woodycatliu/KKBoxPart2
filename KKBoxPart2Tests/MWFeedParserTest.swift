//
//  MWFeedParserTest.swift
//  KKBoxPart2Tests
//
//  Created by Woody on 2022/6/23.
//

import XCTest
@testable import KKBoxPart2

class MWFeedParserTest: XCTestCase {
    
    lazy var url: URL! = {
        return try! XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "rss", withExtension: "html"))
    }()
    

}
