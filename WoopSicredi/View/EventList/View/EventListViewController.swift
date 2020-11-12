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
    var coordinator: MainCoordinator?
    @IBOutlet weak var tableView: UITableView!
    
    static func instantiate(with viewModel: EventListViewModel) -> EventsListViewController {
        let storyboard = UIStoryboard(name: "EventsList", bundle: .main)
        guard let viewController = storyboard.instantiateInitialViewController() as? EventsListViewController else { return EventsListViewController()}
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        //testPost()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Eventos"
        navigationController?.navigationBar.prefersLargeTitles = true
        let color = UIColor(named: "WoopGreen")
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color as Any]
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: color as Any]
        navigationController?.navigationBar.tintColor = color
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        
        viewModel.tabelViewRowHeight()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.rowHeight)
            .disposed(by: disposeBag)
        
        viewModel.fetchEventViewModel()
            .observe(on: MainScheduler.instance)
            .catch({error -> Observable<[EventViewModel]> in
                print(error)
                return .just([])
            })
            .bind(to: tableView.rx.items){ (tableView, row, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventListTableViewCell
                cell.setData(title: item.title, imageURL: item.imageURL, eventParticipants: "\(item.numberOfPartcicipants) pessoas vão participar", eventDate: item.eventDate, eventDistance: "2.2km")
            return cell
        }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(EventViewModel.self)
            .subscribe(onNext: { [self] value in
                coordinator?.goToEventDetail(selectedEvent: value)
            }).disposed(by: disposeBag)
    }
    
    //TODO: Remove after all event's info are being displayed correctly in tableview
    func printEvents(){
        let service = EventService()
        service.fetchEvents().observe(on: MainScheduler.instance).subscribe { result in
            print(result)
        }.disposed(by: disposeBag)
    }
    
    //TODO: Remove after actual post is implemented
    func testPost(){
        let service = EventService()
        let participant = Participant(eventId: "1", name: "Pedro", email: "pedro@gmail.com")
        service.postToEvent(with: participant).observe(on: MainScheduler.instance).subscribe { httpCode in
            print(httpCode.element as Any)
        }.disposed(by: disposeBag)
    }
    
}
