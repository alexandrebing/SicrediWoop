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
    }
    
    private func setupNavBar() {
        navigationItem.title = "Eventos"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.fetchEventViewModel().observe(on: MainScheduler.instance).bind(to: tableView.rx.items){ (tableView, row, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventListTableViewCell
            cell.setData(title: item.title, imageURL: item.imageURL)
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(EventViewModel.self)
            .subscribe(onNext: { [self] value in
                coordinator?.goToEventDetail(viewModel: value)
            }).disposed(by: disposeBag)
    }
    
    //TODO: Remove after all event's info are being displayed correctly in tableview
    func printEvents(){
        let service = EventService()
        service.fetchEvents().observe(on: MainScheduler.instance).subscribe { result in
            print(result)
        }.disposed(by: disposeBag)
    }


}

extension EventsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
