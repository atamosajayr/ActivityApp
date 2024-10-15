//
//  RecapHeaderView.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/15/24.
//

import UIKit

class RecapHeaderView: UIView {
    
    let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "recapIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "RECAP"
        label.textAlignment = .left
        label.textColor = UIColor(named: "orangeText")
        label.font = UIFont(name: "EuclidCircularB-Medium", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Fill in the blank"
        label.textAlignment = .left
        label.font = UIFont(name: "EuclidCircularB-Medium", size: 18)
        label.textColor = UIColor(named: "textColor")
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    func setupUI() {
        addSubview(titleImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            titleImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleImage.topAnchor.constraint(equalTo: self.topAnchor),
            titleImage.widthAnchor.constraint(equalToConstant: 16),
            titleImage.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
}

