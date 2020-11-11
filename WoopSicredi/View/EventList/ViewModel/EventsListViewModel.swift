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
    var eventId: String? {
        return event.id
    }
    var title: String {
        return event.title ?? "Evento sem nome"
    }
    var imageURL: String {
        return event.image ?? ""
    }
    var description: String {
        return event.description ?? "Detalhes do evento não disponíveis"
    }
    var eventHasCoordinates: Bool {
        return event.latitude != nil && event.longitude != nil
    }
    var latitude: Double {
        return event.latitude ?? 0
    }
    var longitude: Double {
        return event.longitude ?? 0
    }
    var numberOfPartcicipants: Int {
        return event.people.count
    }
    var participants: [Participant] {
        return event.people
    }
    var suggestedDonation: Double {
        return event.price ?? 0
    }
    
    init(event: Event) {
        self.event = event
    }
}
