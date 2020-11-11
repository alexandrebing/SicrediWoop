//
//  EventDetailViewModel.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import Foundation
import RxSwift

final class EventDetailViewModel {
    
    private let eventService: EventServiceProtocol
    private let selectedEvent: EventViewModel
    
    init(selectedEvent: EventViewModel, eventService: EventServiceProtocol = EventService() ) {
        self.eventService = eventService
        self.selectedEvent = selectedEvent
    }
    
    func getEventTitle() ->Observable<String> {
        return Observable.create { observer -> Disposable in
            observer.onNext(self.selectedEvent.title)
            return Disposables.create()
        }
    }
}
