//
//  ViewController.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 09/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class EventsListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    static func instantiate() -> EventsListViewController {
        let storyboard = UIStoryboard(name: "EventsList", bundle: .main)
        guard let viewController = storyboard.instantiateInitialViewController() as? EventsListViewController else { return EventsListViewController()}
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Eventos"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        let service = EventService()
        service.fetchEvents().observe(on: MainScheduler.instance).subscribe { result in
            print(result)
        }.disposed(by: disposeBag)
    }


}

