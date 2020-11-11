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
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
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
        viewModel.getEventTitle()
            .observe(on: MainScheduler.instance)
            .bind(to: eventTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.getEventDescription()
            .observe(on: MainScheduler.instance)
            .bind(to: EventDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.image.asObservable()
            .bind(to: self.eventImageView.rx.image)
            .disposed(by: self.disposeBag)
        
        viewModel.downloadImage(imageView: eventImageView)
        
        viewModel.getEventLocationView()
            .observe(on: MainScheduler.instance)
            .bind(to: eventMapView.rx.region)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.participantName)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.participantEmail)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .observe(on: MainScheduler.instance)
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] response in
                self?.submitButton.backgroundColor = (response == true) ? UIColor(named: "WoopGreen") : UIColor.gray
            }).disposed(by: disposeBag)
        
        submitButton.rx.tap.subscribe {  _ in
            self.viewModel.postToEventService().subscribe(onNext: {
                result in
                if (200..<400).contains(result){
                    self.presentAlert(title: "Sucesso", message: "Você confirmou interesse por este evento. Verifique o email fornecido para mais informações!")
                } else if result == -1 {
                    self.presentAlert(title: "Oops", message: "Parece que alguma coisa deu errado. Tente novamente mais tarde.")
                }
                
            }, onError: { error in
                print(error)
                self.presentAlert(title: "Oops", message: "Parece que alguma coisa deu errado. Tente novamente mais tarde.")
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        
        setupKeyboard()
    }
    
    private func presentAlert(title: String, message: String){
        DispatchQueue.main.async{
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
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
