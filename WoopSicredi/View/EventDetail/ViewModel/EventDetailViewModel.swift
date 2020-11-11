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
    
    let image : BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
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
    
    func getEventDescription() -> Observable<String> {
        return Observable.create { observer -> Disposable in
            observer.onNext(self.selectedEvent.description)
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
    
    func downloadImage(imageView: UIImageView) {
        
        guard let url = URL(string: self.selectedEvent.imageURL) else { return }
        
        DispatchQueue.main.async { [weak self] in
            var image = UIImage(named: "defaultPlaceholder")
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
            UIView.transition(with: imageView,
                                   duration: 0.3,
                                   options: .transitionCrossDissolve,
                                   animations: {
                                    self?.image.accept(image)
                                   },
                                   completion: nil)
        }
    }
}
