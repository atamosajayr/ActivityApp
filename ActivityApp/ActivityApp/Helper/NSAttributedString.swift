//
//  NSAttributedString.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/15/24.
//

import Foundation

extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
}
