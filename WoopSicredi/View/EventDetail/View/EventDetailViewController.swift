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
    
    @IBOutlet weak var bottomConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
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
        setupKeyboard()
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)

    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraintHeight.constant = keyboardRect.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.contentView.layoutIfNeeded()
            }
        }
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        bottomConstraintHeight.constant = 25
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            //self.contentView.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
