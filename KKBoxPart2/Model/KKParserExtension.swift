//
//  KKParserExtension.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/24.
//

import Foundation
import Combine

extension KKParser {
    
    static func publish(_ url: URL)-> ParsePublisher {
        return ParsePublisher(url: url)
    }
    
    class ParsePublisher: Publisher {

        typealias Output = (EpisodeInfo, [EpisodeItem])

        typealias Failure = Error
        
        private let url: URL
        
        init(url: URL) {
            self.url = url
        }

        func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, (EpisodeInfo, [EpisodeItem]) == S.Input {
            let subscription = ParseSucbription(subscriber: subscriber, url: url)
            subscriber.receive(subscription: subscription)
        }
    }
}


fileprivate class ParseSucbription<SubscriberType: Subscriber>: NSObject, Subscription, KKParserDelegate where SubscriberType.Input == (EpisodeInfo, [EpisodeItem]), SubscriberType.Failure == Error {
    
    private var subscriber: SubscriberType?
    
    init(subscriber: SubscriberType, url: URL) {
        self.subscriber = subscriber
        super.init()
        parse(url)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        subscriber = nil
    }
    
    private func parse(_ url: URL) {
       let parser = KKParser(feedURL: url)
        parser?.delegate = self
        parser?.parse()
    }
    
    func feedParserDidStart(_ parser: KKParser!) {}
    
    func feedParser(_ parser: KKParser!, didFailWithError error: Error!) {
        subscriber?.receive(completion: .failure(error))
    }
    
    func feedParserDidFinish(_ info: EpisodeInfo!, items: [EpisodeItem]!) {
        _ = subscriber?.receive((info, items))
        subscriber?.receive(completion: .finished)
    }
}


