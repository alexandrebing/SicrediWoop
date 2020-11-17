//
//  StringExtensions.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 17/11/20.
//

import Foundation

extension String {
    
    var isEmail: Bool {
        guard
            let regex = try? NSRegularExpression(
                pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                options: [.caseInsensitive]
            )
        else {
            assertionFailure("Regex not valid")
            return false
        }
        
        let regexFirstMatch = regex
            .firstMatch(
                in: self,
                options: [],
                range: NSRange(location: 0, length: self.count)
            )
        
        return regexFirstMatch != nil
    }
}
