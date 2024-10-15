import UIKit

class RecapView: UIView {
    
    var onContinueTapped: (() -> Void)?
    private var viewModel = ActivityViewModel()
    private let confetti: ConfettiView = .bottom
    
    
    let headerView: RecapHeaderView = {
        let view = RecapHeaderView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainView: RecapMainView = {
        let view = RecapMainView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomView: RecapBottomView = {
        let view = RecapBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var firstLoad: Bool = true
    
    // Initializer for the custom view
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setViewModel(_ viewmodel: ActivityViewModel) {
        viewModel = viewmodel
        //set main viewmodel
        mainView.setViewModel(viewmodel)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        addSubview(headerView)
        addSubview(mainView)
        addSubview(bottomView)
        addSubview(confetti)
        
        confetti.translatesAutoresizingMaskIntoConstraints = false
        confetti.isHidden = true
        
        mainView.onUpdateCheck = { [self] isHidden, isConfettiShowing in
            bottomView.updateCheck(isHidden: isHidden, isConfettiShowing: isConfettiShowing)
        }
        mainView.onUpdateStatus = { [self] isHidden, isCorrect in
            bottomView.updateStatus(isHidden: isHidden, isCorrect: isCorrect)
        }
        
        bottomView.onButtonTapped = { [self] isCorrect, isConfettiShowing in
            if !isConfettiShowing {
                if !isCorrect {
                    bottomView.updateStatus(isHidden: true, isCorrect: false)
                    bottomView.updateCheck(isHidden: true, isConfettiShowing: false)
                    firstLoad = true
                    setNeedsLayout()
                }
            } else {
                if !isCorrect {
                    confetti.isHidden = false
                    let impactEngine = UIImpactFeedbackGenerator(style: .heavy)
                    impactEngine.impactOccurred()
                    confetti.emit()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [self] in
                        confetti.isHidden = true
                        let isCorrect = viewModel.isCorrect(mainView.selectedAnswer)
                        bottomView.updateStatus(isHidden: false, isCorrect: isCorrect)
                    }
                } else {
                    //call Next
                    onContinueTapped!()
                }
            }
        }
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if firstLoad {
            firstLoad = false
            
            NSLayoutConstraint.activate([
                headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                headerView.topAnchor.constraint(equalTo: self.topAnchor),
                headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                headerView.heightAnchor.constraint(equalToConstant: 56)
            ])
            
            NSLayoutConstraint.activate([
                bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bottomView.heightAnchor.constraint(equalToConstant: 172),
                bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            NSLayoutConstraint.activate([
                mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                mainView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                mainView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
            ])
            
            NSLayoutConstraint.activate([
                confetti.topAnchor.constraint(equalTo: self.topAnchor),
                confetti.rightAnchor.constraint(equalTo: self.rightAnchor),
                confetti.leftAnchor.constraint(equalTo: self.leftAnchor),
                confetti.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            //Reset values when continue button is Tapped
            mainView.layoutBody()
            mainView.layoutOptionButtons()
        }
    }
}
