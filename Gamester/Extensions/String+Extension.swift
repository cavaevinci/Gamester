//
//  String+Extension.swift
//  Gamester
//
//  Created by Nino on 22.02.2024..
//

import Foundation

extension String {
    func formatDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
}
