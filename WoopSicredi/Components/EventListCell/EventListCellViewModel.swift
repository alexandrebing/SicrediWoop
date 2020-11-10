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
 
    func downloadImage(url: URL, callback: @escaping ()-> Void) {
        URLSession.shared.dataTask( with: url, completionHandler: { (data, _, _) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    self.image.accept(UIImage(data: data))
                    callback()
                }
            }
        }
        ).resume()
    }
}
