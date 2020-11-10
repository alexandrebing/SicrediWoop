//
//  EventsListViewModel.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import Foundation
import RxSwift

final class EventListViewModel{
    let title = "Eventos"
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService() ) {
        self.eventService = eventService
    }
    
    func fetchEventViewModel() -> Observable<[EventViewModel]>{
        eventService.fetchEvents().map { eventList in
            eventList.map  { event in
                EventViewModel(event: event)
            }
        }
    }
}

struct EventViewModel {
    private let event: Event
    var title: String {
        return event.title
    }
    
    init(event: Event) {
        self.event = event
    }
}
