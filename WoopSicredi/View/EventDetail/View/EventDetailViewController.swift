//
//  EventDetailViewController.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    private var viewModel: EventViewModel!
    @IBOutlet weak var eventTitle: UILabel!
    
    static func instantiate(with viewModel: EventViewModel) -> EventDetailViewController {
        let storyboard = UIStoryboard(name: "EventDetail", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetail") as? EventDetailViewController else { return EventDetailViewController()}
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventTitle.text = viewModel.title
    }

}
