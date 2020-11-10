//
//  EventDetailViewController.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import UIKit

class EventDetailViewController: UIViewController {

    static func instantiate() -> EventDetailViewController {
        let storyboard = UIStoryboard(name: "EventDetail", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetail") as? EventDetailViewController else { return EventDetailViewController()}
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
