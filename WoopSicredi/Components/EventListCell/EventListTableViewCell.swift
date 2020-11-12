//
//  EventListTableViewCell.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import UIKit
import RxSwift
import Kingfisher

class EventListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventDistanceLabel: UILabel!
    
    @IBOutlet weak var eventParticipantsLabel: UILabel!
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.activityIndicator.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(title: String, imageURL: String, eventParticipants: String, eventDate: String, eventDistance: String){
        self.titleLabel.text = title
        self.eventDateLabel.text = eventDate
        self.eventDistanceLabel.text = eventDistance
        self.eventParticipantsLabel.text = eventParticipants
        if let url = URL(string: imageURL){
            self.activityIndicator.startAnimating()
            self.loadImage(url)
        }
    }
    
    private func loadImage(_ imageURL: URL){
        eventImage.kf.setImage(with: imageURL,
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: {receivedSize, totalSize in},
                              completionHandler: {result in
                                switch result {
                                case.success(let value):
                                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                case .failure(let error):
                                    print("Job failed: \(error.localizedDescription)")
                                    self.eventImage.image = UIImage(named: "defaultPlaceholder")
                                }
                                self.activityIndicator.stopAnimating()
                              })
    }
    

}
