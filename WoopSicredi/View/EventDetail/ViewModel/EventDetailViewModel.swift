//
//  EventDetailViewModel.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import Foundation
import RxSwift
import RxRelay
import MapKit

final class EventDetailViewModel {
    
    private let eventService: EventServiceProtocol
    private let selectedEvent: EventViewModel
    
    let participantName = BehaviorRelay<String>(value: "")
    let participantEmail = BehaviorRelay<String>(value: "")
    
    let isValid: Observable<Bool>
    
    let image : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    init(selectedEvent: EventViewModel, eventService: EventServiceProtocol = EventService() ) {
        self.eventService = eventService
        self.selectedEvent = selectedEvent
        isValid = Observable.combineLatest(self.participantName.asObservable(), self.participantEmail.asObservable())
                { (name, email) in
                    return name.count > 0
                        && email.count > 0
        }.share(replay: 1)
    }
    
    func getEventTitle() ->Observable<String> {
        return Observable.create { observer -> Disposable in
            observer.onNext(self.selectedEvent.title)
            return Disposables.create()
        }
    }
    
    func getEventDescription() -> Observable<String> {
        return Observable.create { observer -> Disposable in
            observer.onNext(self.selectedEvent.description)
            return Disposables.create()
        }
    }
    
    func getEventImageURL() -> Observable<String> {
        return Observable.create { observer -> Disposable in
            observer.onNext(self.selectedEvent.imageURL)
            return Disposables.create()
        }
    }
    
    func getEventCoordinates() -> Observable<CLLocationCoordinate2D> {
        return Observable.create { observer -> Disposable in
            let coordinates = CLLocationCoordinate2D(latitude: self.selectedEvent.latitude, longitude: self.selectedEvent.longitude)
            observer.onNext(coordinates)
            return Disposables.create()
        }
        
    }
    
    func getEventLocationView() -> Observable<MKCoordinateRegion> {
        return Observable.create{ observer -> Disposable in
            let coordinate = CLLocationCoordinate2D(latitude: self.selectedEvent.latitude, longitude: self.selectedEvent.longitude)
            let region = MKMapView().regionThatFits(MKCoordinateRegion(center: coordinate, latitudinalMeters: 700, longitudinalMeters: 700))
            observer.onNext(region)
            return Disposables.create()
        }
    }
    
    func postToEventService() -> Observable<Int>{
        let participant = Participant(eventId: "1", name: participantName.value, email: participantEmail.value)
        return eventService.postToEvent(with: participant)
    }
}
