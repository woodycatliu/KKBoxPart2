//
//  MediaPageTest.swift
//  KKBoxPart2Tests
//
//  Created by Woody on 2022/6/25.
//

import XCTest
@testable import KKBoxPart2
import Combine


class MediaPageTestt: XCTestCase {
    
    var parser: AnyCancellable?

    var mediaList: [Media] = []
    var media: Media? = nil
    
    lazy var frontUseCase: DefaultFrontPageCase = {
        let reducer = FrontPageNavigatedReducer { _, _ in }
        return DefaultFrontPageCase(navigateReducer: reducer)
    }()
    
    override func setUp() {
        super.setUp()
        let url = try! XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "sounds", withExtension: "rss"))
        let ext = expectation(description: "Test KKParserPublisherTest")
        parser = KKParser.publish(url)
            .map { [unowned self] in
                return self.frontUseCase.convertRssInfo($0, items: $1)
            }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in
                self?.mediaList = $0.mediaList
                self?.media = $0.mediaList.first
                ext.fulfill()
            })
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    override func tearDown() {
        parser = nil
        mediaList.removeAll()
        media = nil
        super.tearDown()
    }
    
    func test_MediaPageUseCase() {
        let detector = Detector()
        
        let reducer = MediaPageNavigatedReducer { [weak detector] media, list in
            detector?.isGoPlayerPage = true
            detector?.mediaInfo = media
            detector?.mediaList = list
        }
        
        let useCase = DefaultMediaPageCase(navigateReducer: reducer)
        
        // MARK: navigate case test
        useCase.navigateReducer(.playerPage(media!, mediaList), nil)
        
        XCTAssertTrue(detector.isGoPlayerPage)
        XCTAssertNotNil(detector.mediaInfo, "media is nil")
        XCTAssertEqual(detector.mediaList.count, 148)
        
        testFirstMedia(detector.mediaInfo!)
        
        // MARK: test use case
        detector.isGoPlayerPage = false
        detector.mediaInfo = nil
        detector.mediaList.removeAll()
        
        useCase.play(media!, fullList: mediaList)
        
        XCTAssertTrue(detector.isGoPlayerPage)
        XCTAssertNotNil(detector.mediaInfo, "media is nil")
        XCTAssertEqual(detector.mediaList.count, 148)
        
        testFirstMedia(detector.mediaInfo!)
        
        // MARK: test viewModel
        detector.isGoPlayerPage = false
        detector.mediaInfo = nil
        detector.mediaList.removeAll()
        
        let viewModel = MediaPageViewModel(useCase, media: media!, fullList: mediaList)
        
        viewModel.play()
        
        XCTAssertTrue(detector.isGoPlayerPage)
        XCTAssertNotNil(detector.mediaInfo, "media is nil")
        XCTAssertEqual(detector.mediaList.count, 148)
        
        testFirstMedia(detector.mediaInfo!)
        
    }
    
    func testFirstMedia(_ media: PlayerMediaInfo!) {
        XCTAssertNotNil(media.title, "item title is nil")
        XCTAssertEqual(media.title!, "SP. 科技島讀請回答")
        XCTAssertNotNil(media.date, "item date is nil")
        XCTAssertNotNil(media.mp3, "item link is nil")
        XCTAssertEqual(media.mp3, "https://feeds.soundcloud.com/stream/1062984568-daodutech-podcast-please-answer-daodu-tech.mp3")
        XCTAssertNotNil(media.remoteImage, "item image is nil")
        XCTAssertEqual(media.remoteImage!.absoluteString, "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg")
        XCTAssertNotNil(media.artist, "item summary is nil")
        XCTAssertTrue(media.artist!.contains("在這個最後的 Q&A 特輯中，兩位主持人回答聽眾對科技島讀與 podcast 最感興趣的問題。題目涵蓋寫作方法、發展特色、身心平衡，以及給迷惘的人的建議。 科技島讀 podcast 歷時 4 年。周欽華要特別感謝盧郁青擔任共同主持人，一起同甘共苦。謝謝房首伊與賴佳翎認真負責，是可靠的後援。謝謝工程師 Joe"))
    }
    
}

extension MediaPageTestt {
    class Detector {
        var mediaList: [PlayerMediaInfo] = []
        var mediaInfo: PlayerMediaInfo?
        var isGoPlayerPage = false
    }
}
