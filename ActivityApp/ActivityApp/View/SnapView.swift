//
//  SnapView.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/13/24.
//

import UIKit

class SnapView: UIView {
    
    let underLineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "EuclidCircularB-Regular", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    // Initializer for the custom view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        addSubview(underLineLabel)
        
        underLineLabel.text = "____________________________"
        
        // RecapLabel constraints
        NSLayoutConstraint.activate([
            underLineLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underLineLabel.topAnchor.constraint(equalTo: self.topAnchor),
            underLineLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underLineLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

