//
//  U*tility.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/15/24.
//

import UIKit

func calculateAttributedStringHeight(attributedString: NSAttributedString, width: CGFloat) -> CGFloat {
    let textView = UITextView()
    textView.attributedText = attributedString
    textView.isScrollEnabled = false
    textView.frame.size.width = width
    let sizeThatFits = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    let totalInset = textView.textContainerInset.top + textView.textContainerInset.bottom
    let calculatedHeight = sizeThatFits.height + totalInset
    return calculatedHeight
}
