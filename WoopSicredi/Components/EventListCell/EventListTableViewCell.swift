//
//  EventListTableViewCell.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import UIKit
import RxSwift

class EventListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel: EventListCellViewModel = EventListCellViewModel()
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        viewModel.image.asObservable().bind(to: self.eventImage.rx.image).disposed(by: self.disposeBag)
        viewModel.spinner.asObservable().bind(to: self.activityIndicator.rx.isHidden).disposed(by: self.disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(title: String, imageURL: String){
        self.title.text = title
        if let url = URL(string: imageURL){
            self.activityIndicator.startAnimating()
            self.loadImage(url)
        }
    }
    
    private func loadImage(_ imageURL: URL){
        self.viewModel.downloadImage(url: imageURL, imageView: self.eventImage)
    }

}
