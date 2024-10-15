//
//  MultipleChoiceView.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/12/24.
//

import UIKit

class MultipleChoiceView: UIView {
    
    var onContinueTapped: (() -> Void)?
    
    private var screen: Screen?
    private var choices: [Choice] = []
    private var selectedChoices: Set<UIButton> = [] // Track selected buttons
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont(name: "EuclidCircularB-Medium", size: 22)
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let confirmButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let attributedTitle = NSAttributedString(
            string: "Continue",
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
        return button
    }()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(questionLabel)
        addSubview(buttonStackView)
        addSubview(confirmButton)
        
        confirmButton.addTarget(self, action: #selector(confirmSelection), for: .touchUpInside)
        
        setupInitialConstraints()
    }
    
    private func setupInitialConstraints() {
        NSLayoutConstraint.activate([
            // Confirm button at the bottom
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Stack view just above the confirm button
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20),
            
            // Top view occupies the remaining space
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20)
        ])
    }
    
    // Function to configure the view with a Screen object
    func configure(with screen: Screen) {
        self.screen = screen
        self.choices = screen.choices ?? []
        questionLabel.text = screen.question
        
        setupButtons(with: choices, multipleChoicesAllowed: screen.multipleChoicesAllowed ?? true)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let screen = screen else { return }
        let isMultipleAllowed = screen.multipleChoicesAllowed ?? true
        let confirmHeight: CGFloat = isMultipleAllowed ? 50.0 : 0.0
        
        NSLayoutConstraint.activate([
            confirmButton.heightAnchor.constraint(equalToConstant: confirmHeight)
        ])
        
        setupConfirmButton()
    }
    
    private func setupButtons(with choices: [Choice], multipleChoicesAllowed: Bool) {
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // Limit the number of choices to 5
        let limitedChoices = Array(choices.prefix(5))
        //Limit characters to 80
        for choice in limitedChoices {
            var buttonTitle = "\(choice.emoji) \(choice.text)"
            if buttonTitle.count > 80 {
                buttonTitle = String(buttonTitle.prefix(80)) + "..."
            }
            
            var config = UIButton.Configuration.plain()
            let attributedTitle = NSAttributedString(
                string: buttonTitle,
                attributes: [
                    .foregroundColor: UIColor(named: "textColor")!,
                    .font: UIFont(name: "EuclidCircularB-Medium", size: 16)!
                ]
            )
            config.attributedTitle = AttributedString(attributedTitle)
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            
            let button = UIButton(configuration: config)
            button.contentHorizontalAlignment = .leading
            button.layer.cornerRadius = 12
            button.layer.borderColor = UIColor(named: "buttonBorderNormal")?.cgColor
            button.layer.borderWidth = 1
            button.tag = choices.firstIndex(where: { $0.id == choice.id }) ?? 0
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            
            // Adjust height based on content
            let maxWidth = UIScreen.main.bounds.width - 40
            let fittingSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
            let size = button.sizeThatFits(fittingSize)
            
            // Set the height dynamically based on content
            button.heightAnchor.constraint(equalToConstant: size.height + 10).isActive = true
            
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func setupConfirmButton() {
        confirmButton.isEnabled = !selectedChoices.isEmpty
        confirmButton.backgroundColor = confirmButton.isEnabled ? UIColor(named: "confirmEnabled") : UIColor(named: "confirmDisabled")
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        if selectedChoices.contains(sender) {
            selectedChoices.remove(sender)
            sender.layer.borderColor = UIColor(named: "buttonBorderNormal")?.cgColor
            sender.layer.borderWidth = 1
        } else {
            selectedChoices.insert(sender)
            sender.layer.borderColor = UIColor(named: "buttonBorderSelected")?.cgColor
            sender.layer.borderWidth = 2
        }
        let isMultipleAllowed = screen?.multipleChoicesAllowed ?? true
        if !isMultipleAllowed {
            confirmSelection()
        }  else {
            setupConfirmButton()
        }
    }
    
    @objc private func confirmSelection() {
        let selectedTitles = selectedChoices.map { $0.currentTitle ?? "" }
        print("Selected options: \(selectedTitles)")
        onContinueTapped!()
    }
}
