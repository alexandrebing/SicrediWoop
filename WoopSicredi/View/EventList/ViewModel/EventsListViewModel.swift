//
//  EventsListViewModel.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import Foundation
import MapKit
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
    
    func tabelViewRowHeight() -> Observable<CGFloat> {
        return Observable.create { observer -> Disposable in
            observer.onNext(150.0)
            return Disposables.create()
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
    
    var eventDate: String {
        // MARK: Improvised property considering that date provides an Integer, so I picked date on time and added this Integer(divided by 1000 for a realistic result) as a TimeInterval from this picked date
        guard let currentDate = Date.dateFromString(date: "2020-11-10T00:00"),
              let timeInterval = event.date else { return "Sem data prevista" }
        let eventDate = currentDate.adding(seconds: (timeInterval/1000))
        return eventDate.getFullDateString()
    }
    
    func getDistanceToEvent(userLocation: CLLocationCoordinate2D?) -> String {
        guard let location = userLocation else { return "Não disponível"}
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let destinationLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let distance = destinationLocation.distance(from: clLocation)
        let kmDistance = distance/1000
        let formattedDistance = String(format: "%.1f", kmDistance)
        print(formattedDistance)
        return "\(formattedDistance)Km de distância"
    }
    
    init(event: Event) {
        self.event = event
    }
}
