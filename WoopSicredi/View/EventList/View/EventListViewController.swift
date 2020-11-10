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
    private var viewModel: EventListViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    static func instantiate(viewModel: EventListViewModel) -> EventsListViewController {
        let storyboard = UIStoryboard(name: "EventsList", bundle: .main)
        guard let viewController = storyboard.instantiateInitialViewController() as? EventsListViewController else { return EventsListViewController()}
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Eventos"
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.fetchEventViewModel().observe(on: MainScheduler.instance).bind(to: tableView.rx.items(cellIdentifier: "eventCell")){ index, eventViewModel, cell in
            cell.textLabel?.text = eventViewModel.title
        }.disposed(by: disposeBag)

    }
    
    //TODO: Remove after all event's info are being displayed correctly in tableview
    func printEvents(){
        let service = EventService()
        service.fetchEvents().observe(on: MainScheduler.instance).subscribe { result in
            print(result)
        }.disposed(by: disposeBag)
    }


}

