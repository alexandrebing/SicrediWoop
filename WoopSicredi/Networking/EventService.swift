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
    func postToEvent(with data: Participant) -> Observable<Int>
}

final class EventService: EventServiceProtocol {
    
    // MARK: Fetch events
    func fetchEvents() -> Observable<[Event]> {
        return Observable.create { observer -> Disposable in
            
            let task = URLSession.shared.dataTask(with: URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!) { data, response, error in
                let httpResponse = response as? HTTPURLResponse
                guard let data = data else {
                    observer.onError(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: nil) )
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
    
    func postToEvent(with data: Participant) -> Observable<Int> {
        return Observable.create { observer -> Disposable in
            var request = URLRequest(url: URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/checkin")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField:
                  "Content-Type")
            do {
                let payloadData = try JSONSerialization.data(withJSONObject:
                           data.dictionaryValue!, options: [])
                     request.httpBody = payloadData
            } catch {
                observer.onError(error)
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let httpResponse = response as? HTTPURLResponse
                observer.onNext(httpResponse?.statusCode ?? -1)
            }
            task.resume()
            return Disposables.create{
                task.cancel()
            }
        }
    }
    
    
}

fileprivate extension Encodable {
  var dictionaryValue:[String: Any?]? {
      guard let data = try? JSONEncoder().encode(self),
      let dictionary = try? JSONSerialization.jsonObject(with: data,
        options: .allowFragments) as? [String: Any] else {
      return nil
    }
    return dictionary
  }
}
