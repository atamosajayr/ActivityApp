//
//  RecapBottomView.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/15/24.
//

import UIKit

class RecapBottomView: UIView {
    
    var onButtonTapped: ((_ isHidden: Bool, _ isCorrect: Bool) -> Void)?
    
    private var isCorrect: Bool = false
    private var isConfettiShowing: Bool = false
    
    let checkButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let attributedTitle = NSAttributedString(
            string: "Check",
            attributes: [
                .foregroundColor: UIColor(named: "confirmButtonColor")!,
                .font: UIFont(name: "EuclidCircularB-Medium", size: 16)!
            ]
        )
        config.attributedTitle = AttributedString(attributedTitle)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.isHidden = true
        return button
    }()
    
    private let statusView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
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
        addSubview(statusView)
        addSubview(messageLabel)
        addSubview(checkButton)
        
        checkButton.addTarget(self, action: #selector(checkSelection), for: .touchUpInside)
        
        checkButton.backgroundColor = checkButton.isEnabled ? UIColor(named: "confirmEnabled") : UIColor(named: "confirmDisabled")
        NSLayoutConstraint.activate([
            statusView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            statusView.topAnchor.constraint(equalTo: self.topAnchor),
            statusView.heightAnchor.constraint(equalToConstant: 4),
            
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 16),
            messageLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Check button at the bottom
            checkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            checkButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            checkButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        setNeedsLayout()
    }
    
    func setTitle(_  title: String) {
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor(named: "confirmButtonColor")!,
                .font: UIFont(name: "EuclidCircularB-Medium", size: 16)!
            ]
        )
        checkButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func updateStatus(isHidden: Bool, isCorrect: Bool) {
        statusView.isHidden = isHidden
        messageLabel.isHidden = isHidden
        self.isCorrect = isCorrect
        statusView.backgroundColor = isCorrect ? UIColor(named: "correctColor") : UIColor(named: "wrongColor")
        checkButton.isEnabled = true
        if isCorrect {
            setTitle("Continue")
            messageLabel.text = "You’re correct!"
        } else {
            setTitle("Continue")
            messageLabel.text = "Try again"
        }
        checkButton.backgroundColor = checkButton.isEnabled ? UIColor(named: "confirmEnabled") : UIColor(named: "confirmDisabled")
    }
    
    func updateCheck(isHidden: Bool, isConfettiShowing: Bool) {
        self.isHidden = isHidden
        self.isConfettiShowing = isConfettiShowing
        checkButton.isHidden = isHidden
        checkButton.isEnabled = !isHidden && !isConfettiShowing
        checkButton.backgroundColor = checkButton.isEnabled ? UIColor(named: "confirmEnabled") : UIColor(named: "confirmDisabled")
    }
    
    @objc private func checkSelection() {
        if !isConfettiShowing && !isCorrect{
            isConfettiShowing = true
            checkButton.isEnabled = false
        } else if isConfettiShowing && !isCorrect {
            isConfettiShowing = false
        }
        checkButton.backgroundColor = checkButton.isEnabled ? UIColor(named: "confirmEnabled") : UIColor(named: "confirmDisabled")
        onButtonTapped?(isCorrect, isConfettiShowing)
    }
}
