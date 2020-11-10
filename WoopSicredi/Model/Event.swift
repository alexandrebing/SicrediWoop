//
//  Event.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import Foundation

struct Event: Decodable {
    var people: [Participant]
    var date: Int
    var description: String
    var image: String
    var longitude: Double
    var latitude: Double
    var price: Double
    var title: String
    var id: String
}
