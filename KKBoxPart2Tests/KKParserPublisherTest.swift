//
//  KKParserPublisherTest.swift
//  KKBoxPart2Tests
//
//  Created by Woody on 2022/6/24.
//

import Foundation

import XCTest
@testable import KKBoxPart2
import Combine

class KKParserPublisherTest: XCTestCase {
    var parser: AnyCancellable?
    
    var info: EpisodeInfo!
    var items: [EpisodeItem] = []
    
    @Published
    var album: AlbumMediaInfo!
    @Published
    var mediaList: [PlayerMediaInfo]? = []
    
    override func setUp() {
        super.setUp()
        let url = try! XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "sounds", withExtension: "rss"))
        let ext = expectation(description: "Test KKParserPublisherTest")
        parser = KKParser.publish(url)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in
                self?.info = $0
                self?.items = $1
                ext.fulfill()
            })
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    override func tearDown() {
        parser = nil
        info = nil
        album = nil
        mediaList?.removeAll()
        items.removeAll()
        super.tearDown()
    }
    

    func test_EpisodeInfo() {
        XCTAssertNotNil(info.link, "link is nil")
        XCTAssertEqual(info.link!, "https://daodu.tech")
        XCTAssertNotNil(info.summary, "summary is nil")
        XCTAssertEqual(info.summary!, "科技島讀是會員制媒體，專注於分析國際事件，解讀科技、商業與社會趨勢。我們從台灣出發，因此取名「島」讀。")
        XCTAssertNotNil(info.image, "image is nil")
        XCTAssertEqual(info.image!, "https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg")
        
    }
    
    func test_EpisodeItems() {
        XCTAssertEqual(items.count, 148)
        let item1 = items.first!
        XCTAssertNotNil(item1.title, "item title is nil")
        XCTAssertEqual(item1.title!, "SP. 科技島讀請回答")
        XCTAssertNotNil(item1.date, "item date is nil")
        XCTAssertEqual(item1.date!.description, "2021-06-06 22:00:11 +0000")
        XCTAssertNotNil(item1.link, "item link is nil")
        XCTAssertEqual(item1.link!, "https://soundcloud.com/daodutech/podcast-please-answer-daodu-tech")
        XCTAssertNotNil(item1.author, "item author is nil")
        XCTAssertEqual(item1.author!, "Daodu Tech")
        XCTAssertNotNil(item1.image, "item image is nil")
        XCTAssertEqual(item1.image!, "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg")
        XCTAssertNotNil(item1.summary, "item summary is nil")
        XCTAssertTrue(item1.summary.contains("在這個最後的 Q&A 特輯中，兩位主持人回答聽眾對科技島讀與 podcast 最感興趣的問題。題目涵蓋寫作方法、發展特色、身心平衡，以及給迷惘的人的建議。 科技島讀 podcast 歷時 4 年。周欽華要特別感謝盧郁青擔任共同主持人，一起同甘共苦。謝謝房首伊與賴佳翎認真負責，是可靠的後援。謝謝工程師 Joe"))
        
        
        let item148 = items.last!
        XCTAssertNotNil(item148.title, "item title is nil")
        XCTAssertEqual(item148.title!, "Ep.01 比手機更迷人的世界：遊戲")
        XCTAssertNotNil(item148.date, "item date is nil")
        XCTAssertEqual(item148.date!.description, "2017-07-27 09:56:47 +0000")
        XCTAssertNotNil(item148.link, "item link is nil")
        XCTAssertEqual(item148.link!, "https://soundcloud.com/daodutech/vr4bkoas3ort")
        XCTAssertNotNil(item148.author, "item author is nil")
        XCTAssertEqual(item148.author!, "Daodu Tech")
        XCTAssertNotNil(item148.image, "item image is nil")
        XCTAssertEqual(item148.image!, "https://i1.sndcdn.com/artworks-000235417599-6vthgf-t3000x3000.jpg")
        XCTAssertNotNil(item148.summary, "item summary is nil")
        XCTAssertTrue(item148.summary.contains("科技島讀第一次的島聚，邀請到創夢市集負責人以及遊戲產業電子報「曼不經心的遊戲評論」創辦人李易鴻一同對談遊戲的迷人之處"))
    }
    
    
    func test_Album() {
        XCTAssertNotNil(info.link, "link is nil")
        XCTAssertEqual(info.link!, "https://daodu.tech")
        XCTAssertNotNil(info.summary, "summary is nil")
        XCTAssertEqual(info.summary!, "科技島讀是會員制媒體，專注於分析國際事件，解讀科技、商業與社會趨勢。我們從台灣出發，因此取名「島」讀。")
        XCTAssertNotNil(info.image, "image is nil")
        XCTAssertEqual(info.image!, "https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg")
        
    }
    func test_FrontUseCase() {
        
        var detectorAlbum: AlbumMediaInfo
        var detectorMedias: [PlayerMediaInfo]
        
        // MARK: Build Nativagate Case and UseCase
        let detector = Detector()
        
        let reducer = FrontPageNavigatedReducer { [weak detector] media, _ in
            detector?.isGoToMediaPage = true
            detector?.mediaInfo = media
        }
        
        let useCase = DefaultFrontPageCase(navigateReducer: reducer)
        
        // MARK: Test Convert Case
        
        let tuple = useCase.convertRssInfo(info, items: items)
        
        detectorMedias = tuple.1
        detectorAlbum = tuple.0
        
        testAlbum(detectorAlbum)
        
        testMediaList(detectorMedias)
        
        // MARK: test update
        useCase.updateAlbumInfo(newAlbumInfo: detectorAlbum, oldAlbumInfo: &album)
        
        useCase.updateMediaList(newMediaList: detectorMedias, oldMediaList: &mediaList)
        
        testAlbum(album)
        
        XCTAssertNotNil(mediaList, "mediaList is nil")
        
        testMediaList(mediaList!)
        
        // MARK: test navigateReducer
        let media1 = mediaList!.first!
        
        useCase.navigateReducer(.mediaInfoPage(media1, mediaList!), nil)
        
        XCTAssertTrue(detector.isGoToMediaPage)
        
        testFirstMedia(media1)
        
        // MARK: test cell did selected
        detector.isGoToMediaPage = false
        let lastIndexPath = IndexPath(row: mediaList!.indices.max()!, section: 0)
        
        useCase.cellDidSelected(lastIndexPath, mediaList!)
        
        let lastMedia = mediaList!.last!
        testLastMedia(lastMedia)
        
    }
    
    
    func testAlbum(_ album: AlbumMediaInfo) {
        XCTAssertNotNil(album.image, "image is nil")
        XCTAssertEqual(album.image!, "https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg")
        
        XCTAssertNotNil(album.title, "title nil")
        XCTAssertEqual(album.title!, "科技島讀")
    }
    
    func testMediaList(_ mediaList: [PlayerMediaInfo]) {
        let media1 = mediaList.first!
        testFirstMedia(media1)
        
        let media148 = mediaList.last!
        testLastMedia(media148)
        
    }
    
    func testFirstMedia(_ media: PlayerMediaInfo!) {
        XCTAssertNotNil(media.title, "item title is nil")
        XCTAssertEqual(media.title!, "SP. 科技島讀請回答")
        XCTAssertNotNil(media.date, "item date is nil")
        XCTAssertNotNil(media.link, "item link is nil")
        XCTAssertEqual(media.link, "https://soundcloud.com/daodutech/podcast-please-answer-daodu-tech")
        XCTAssertNotNil(media.remoteImage, "item image is nil")
        XCTAssertEqual(media.remoteImage!.absoluteString, "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg")
        XCTAssertNotNil(media.artist, "item summary is nil")
        XCTAssertTrue(media.artist!.contains("在這個最後的 Q&A 特輯中，兩位主持人回答聽眾對科技島讀與 podcast 最感興趣的問題。題目涵蓋寫作方法、發展特色、身心平衡，以及給迷惘的人的建議。 科技島讀 podcast 歷時 4 年。周欽華要特別感謝盧郁青擔任共同主持人，一起同甘共苦。謝謝房首伊與賴佳翎認真負責，是可靠的後援。謝謝工程師 Joe"))
    }
    
    func testLastMedia(_ media: PlayerMediaInfo!) {
        XCTAssertNotNil(media.title, "item title is nil")
        XCTAssertEqual(media.title!, "Ep.01 比手機更迷人的世界：遊戲")
        XCTAssertNotNil(media.link, "item link is nil")
        XCTAssertEqual(media.link, "https://soundcloud.com/daodutech/vr4bkoas3ort")
        XCTAssertNotNil(media.remoteImage, "item image is nil")
        XCTAssertEqual(media.remoteImage!.absoluteString, "https://i1.sndcdn.com/artworks-000235417599-6vthgf-t3000x3000.jpg")
        XCTAssertNotNil(media.artist, "item summary is nil")
        XCTAssertTrue(media.artist!.contains("科技島讀第一次的島聚，邀請到創夢市集負責人以及遊戲產業電子報「曼不經心的遊戲評論」創辦人李易鴻一同對談遊戲的迷人之處"))
    }
    
}

extension KKParserPublisherTest {
    class Detector {
        var mediaInfo: PlayerMediaInfo?
        var isGoToMediaPage = false
    }
    
}
