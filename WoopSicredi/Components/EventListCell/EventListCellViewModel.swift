//
//  EventListCellViewModel.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import Foundation
import RxSwift
import RxRelay

class EventListCellViewModel {
    
    let image : BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    let spinner : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func downloadImage(url: URL, imageView: UIImageView) {
        
        DispatchQueue.main.async {
            var image = UIImage(named: "defaultPlaceholder")
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
            UIView.transition(with: imageView,
                                   duration: 0.3,
                                   options: .transitionCrossDissolve,
                                   animations: {
                                    self.image.accept(image)
                                   },
                                   completion: nil)
            self.spinner.accept(true)
        }
    }
}
