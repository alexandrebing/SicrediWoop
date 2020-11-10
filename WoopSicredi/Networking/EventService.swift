//
//  EventService.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import Foundation
import RxSwift

protocol EventServiceProtocol{
    func fetchEvents() -> Observable<[Event]>
    //func postInterestedParticipant()
}

final class EventService: EventServiceProtocol {
    
    // MARK: Fetch events
    func fetchEvents() -> Observable<[Event]> {
        return Observable.create { observer -> Disposable in
            
            let task = URLSession.shared.dataTask(with: URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!) { data, _, _ in
                 //then put the code above in this completition handler
                guard let data = data else {
                    observer.onError(NSError(domain: "", code: -1, userInfo: nil) )
                    return
                }
                do {
                    let events = try JSONDecoder().decode([Event].self, from: data)
                    observer.onNext(events)
                }
                catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create{
                task.cancel()
            }
        }
    }
    
    
}
