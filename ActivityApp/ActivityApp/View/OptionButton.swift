//
//  OptionButton.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/15/24.
//

import UIKit

class OptionButton: UIButton {
    let buttonHeight: CGFloat = 36
    
    // Initializer for the custom button
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Setup the button appearance and configuration
    func updateTitle(title: String) {
        var config = UIButton.Configuration.plain()
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor(named: "textColor")!,
                .font: UIFont(name: "EuclidCircularB-Medium", size: 16)!
            ]
        )
        config.attributedTitle = AttributedString(attributedTitle)
        
        self.configuration = config
        self.sizeToFit() // Adjust width based on title size
        self.frame.size.height = buttonHeight // Set the fixed height
        
        // Custom styling for the button
        self.backgroundColor = UIColor(named: "confirmButtonColor")!
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "optionBorderColor")?.cgColor
        self.layer.shadowColor = UIColor(named: "buttonDopdownShadow")?.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2) // Adjust height for dropdown effect
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.15
        self.layer.masksToBounds = false
    }
}
