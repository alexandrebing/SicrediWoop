//
//  EventDetailViewController.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class EventDetailViewController: UIViewController {
    
    private var viewModel: EventDetailViewModel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var EventDescriptionLabel: UILabel!
    @IBOutlet weak var eventMapView: MKMapView!
    
    
    let disposeBag = DisposeBag()
    
    static func instantiate(with viewModel: EventDetailViewModel) -> EventDetailViewController {
        let storyboard = UIStoryboard(name: "EventDetail", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetail") as? EventDetailViewController else { return EventDetailViewController()}
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.getEventTitle().observe(on: MainScheduler.instance).bind(to: eventTitle.rx.text).disposed(by: disposeBag)
        viewModel.getEventDescription().observe(on: MainScheduler.instance).bind(to: EventDescriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.image.asObservable().bind(to: self.eventImageView.rx.image).disposed(by: self.disposeBag)
        viewModel.downloadImage(imageView: eventImageView)
        viewModel.getEventLocationView().observe(on: MainScheduler.instance).bind(to: eventMapView.rx.region).disposed(by: disposeBag)
        
    }

}
