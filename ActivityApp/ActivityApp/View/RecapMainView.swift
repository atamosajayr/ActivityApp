//
//  RecapMainView.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/15/24.
//

import UIKit

class RecapMainView: UIView {
    var onUpdateStatus: ((_ isHidden: Bool, _ isCorrect: Bool) -> Void)?
    var onUpdateCheck: ((_ isHidden: Bool, _ isConfettiShowing: Bool) -> Void)?
    
    private var viewModel = ActivityViewModel()
    private var snapAreaConstraints: [NSLayoutConstraint] = [] // Store constraints for the snap area
    private var currentButtonInSnapArea: UIButton?
    var originalString = ""
    var selectedAnswer = ""
    let delimiter = "%  RECAP  %"
    var optionStrings: [String] = []
    var optionButtons: [OptionButton] = []
    var optionPlaceHolders: [UIView] = []
    let horizontalSpacing: CGFloat = 10
    let verticalSpacing: CGFloat = 10
    let buttonHeight: CGFloat = 36
    
    // Recap label that contains the entire text
    let recapText: YanagiText = {
        let text = YanagiText()
        text.textAlignment = .left
        //text.font = UIFont(name: "EuclidCircularB-Regular", size: 22)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isScrollEnabled = false
        text.isEditable = false
        return text
    }()
    
    // Snap area to replace % RECAP %
    var snapArea: SnapView = {
        let view = SnapView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // Initializer for the custom view
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setViewModel(_ viewmodel: ActivityViewModel) {
        viewModel = viewmodel
        guard let screen = viewModel.getCurrentScreen() else { return }
        configure(with: screen.body ?? "", options: screen.answers ?? [])
    }
    
    func configure(with body: String, options: [Answer]) {
        originalString = body
        for option in options {
            optionStrings.append(option.text)
        }
        setupUI()
    }
    
    func setupUI() {
        var index = 0
        optionButtons = optionStrings.map { title in
            let button = OptionButton()
            button.updateTitle(title: title)
            button.tag = 100 + index
            index += 1
            return button
        }
        
        for (index, _) in optionButtons.enumerated() {
            let view = UIView()
            view.backgroundColor = UIColor(named: "placeholderBG")
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(named: "placeholderBG")?.cgColor
            view.tag = 1000 + index
            optionPlaceHolders.append(view)
        }
        
        addSubview(recapText)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBody()
        layoutOptionButtons()
    }
    
    private func setupSnapString(_ frame: CGRect)-> NSAttributedString {
        snapArea = SnapView(frame: frame)
        snapArea.isUserInteractionEnabled = true
        return self.recapText.getViewString(with: snapArea, size: snapArea.frame.size) ?? .init()
    }
    
    func layoutBody() {
        guard self.bounds.width > 0, self.bounds.height > 0 else {
            return // Exit the function if the frame is not set
        }
        recapText.removeViewString(view: snapArea)
        NSLayoutConstraint.deactivate(recapText.constraints)
        let substrings = originalString.components(separatedBy: delimiter)
        let attributedString = self.getAttributedString(string: substrings[0]) +
        self.setupSnapString(CGRect(x: 0, y: 0, width: 80, height: 36)) + self.getAttributedString(string: substrings[1])
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "EuclidCircularB-Regular", size: 22)!,
            .paragraphStyle: paragraphStyle,
            .kern: 0.1,
        ]
        
        // Apply attributes to the entire string without manually specifying the range
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        recapText.attributedText = mutableAttributedString
        
        let contentHeight = calculateAttributedStringHeight(attributedString: mutableAttributedString, width: self.frame.width)
        NSLayoutConstraint.activate([
            recapText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            recapText.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            recapText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            recapText.heightAnchor.constraint(equalToConstant: contentHeight)
        ])
    }
    
    func layoutOptionButtons() {
        var currentX: CGFloat = 20
        var currentY: CGFloat = 10
        let maxWidth: CGFloat = self.bounds.width - 40
        guard self.bounds.width > 0, self.bounds.height > 0 else {
            return // Exit the function if the frame is not set
        }
        for (index, button) in optionButtons.enumerated() {
            // Get the button width based on its content
            let buttonWidth = button.intrinsicContentSize.width // Add padding
            let buttonHeight = self.buttonHeight // Fixed height
            
            // Check if the button fits in the current row
            if currentX + buttonWidth > maxWidth {
                // Move to next row
                currentX = 0
                currentY += buttonHeight + verticalSpacing
            }
            
            let placeholder = optionPlaceHolders[index]
            // Set the button's frame with fixed height
            button.translatesAutoresizingMaskIntoConstraints = false // Ensure constraints are used
            placeholder.translatesAutoresizingMaskIntoConstraints = false
            
            // Adding the button to the view
            addSubview(placeholder)
            addSubview(button)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(buttonDragged(_:)))
            button.addGestureRecognizer(tapGesture)
            button.addGestureRecognizer(panGesture)
            
            // Set the button's frame with fixed height
            NSLayoutConstraint.activate([
                placeholder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: currentX),
                placeholder.topAnchor.constraint(equalTo: recapText.bottomAnchor, constant: currentY),
                placeholder.widthAnchor.constraint(equalToConstant: buttonWidth),
                placeholder.heightAnchor.constraint(equalToConstant: buttonHeight),
                
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: currentX),
                button.topAnchor.constraint(equalTo: recapText.bottomAnchor, constant: currentY),
                button.widthAnchor.constraint(equalToConstant: buttonWidth),
                button.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
            
            // Update currentX for the next button
            currentX += buttonWidth + horizontalSpacing
        }
    }
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        if let button = sender.view as? UIButton {
            onUpdateStatus!(true, false)
            if button.frame.intersects(snapArea.frame) || button == currentButtonInSnapArea {
                returnButtonToPlaceholder(button)
            } else {
                if let currentButton = currentButtonInSnapArea {
                    returnButtonToPlaceholder(currentButton)
                }
                snapButtonToPlace(button)
            }
        }
    }
    
    @objc private func buttonDragged(_ sender: UIPanGestureRecognizer) {
        let button = sender.view!
        let translation = sender.translation(in: self)
        button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
        sender.setTranslation(.zero, in: self)
        
        if sender.state == .ended {
            onUpdateStatus!(true, false)
            let frame = CGRect(x: snapArea.frame.minX, y: snapArea.frame.minY + 10, width: snapArea.frame.size.width, height: snapArea.frame.size.height)
            if button.frame.intersects(frame) {
                if let currentButton = currentButtonInSnapArea {
                    returnButtonToPlaceholder(currentButton) // Return the current button to its placeholder
                }
                snapButtonToPlace(button as! UIButton)
            } else {
                returnButtonToPlaceholder(button as! UIButton)
            }
        }
    }
    
    private func snapButtonToPlace(_ button: UIButton) {
        recapText.removeViewString(view: snapArea)
        let substrings = originalString.components(separatedBy: delimiter)
        let attributedString = self.getAttributedString(string: substrings[0]) +
        self.setupSnapString(CGRectMake(self.snapArea.frame.origin.x, self.snapArea.frame.origin.y, button.frame.width, self.snapArea.frame.size.height)) + self.getAttributedString(string: substrings[1])
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "EuclidCircularB-Regular", size: 22)!,
            .paragraphStyle: paragraphStyle,
            .kern: 0.1,
        ]
        
        // Apply attributes to the entire string without manually specifying the range
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        recapText.attributedText = mutableAttributedString
        
        //self.snapArea.frame = CGRectMake(self.snapArea.frame.origin.x, self.snapArea.frame.origin.y, button.frame.width, self.snapArea.frame.size.height)
        UIView.animate(withDuration: 0.3) {
            button.center = CGPoint(x: self.snapArea.frame.midX + 20, y: self.snapArea.frame.midY + 10)
        }
        let answer = self.viewModel.getCurrentScreen()?.answers?[button.tag - 100]
        selectedAnswer = answer!.id
        currentButtonInSnapArea = button // Set the current button in the snap area
        onUpdateCheck!(false, false)
    }
    
    private func returnButtonToPlaceholder(_ button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            let index = button.tag - 100
            if let placeholder = self.viewWithTag(1000 + index) {
                button.center = placeholder.center
            }
        }
        if button == currentButtonInSnapArea {
            selectedAnswer = ""
            currentButtonInSnapArea = nil // Clear the reference if the button is returned
            onUpdateCheck!(true, false)
        }
    }
    
    private func getAttributedString(string: String)-> NSAttributedString {
        let stringAttributes: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 20.0) ]
        
        return NSAttributedString(string: string, attributes:stringAttributes)
    }
}

