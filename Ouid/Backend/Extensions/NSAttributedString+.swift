//
//  NSAttributedString+.swift
//  Ouid
//
//  Created by Kevin Laminto on 29/5/21.
//

import UIKit

extension NSMutableAttributedString {
    var fontSize: CGFloat { return UIFont.preferredFont(forTextStyle: .body).pointSize }
    var boldFont: UIFont { return .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize) }
    var normalFont: UIFont { return .preferredFont(forTextStyle: .caption1) }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
