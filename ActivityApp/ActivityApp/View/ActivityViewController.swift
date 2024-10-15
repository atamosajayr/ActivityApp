//
//  ActivityViewController.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/12/24.
//

import UIKit

class ActivityViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = ActivityViewModel()
    
    // UI Elements
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let backButton = UIButton(type: .custom)
    private let nextButton = UIButton(type: .custom)
    private let headerView = UIView()
    private let contentView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.async {
            self.showLoading(true)  // Show loading indicator on main thread
        }
        loadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.clipsToBounds = true
        view.addSubview(headerView)
        
        // Progress Bar
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(progressBar)
        
        // Back Button
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(backButton)
        
        // Next Button
        nextButton.setImage(UIImage(named: "close"), for: .normal)
        nextButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(nextButton)
        
        // Content View
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        // Loading Indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        // Set constraints
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 43.0),
            
            progressBar.topAnchor.constraint(equalTo: headerView.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            backButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nextButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 15),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Load Data
    private func loadData() {
        let urlString = "https://file.notion.so/f/f/e430ac3e-ca7a-48f9-804c-8fe9f7d4a267/174c6c45-c116-4762-8550-607cddb04270/activity-response-ios.json?table=block&id=111284a8-e7d3-80ea-a701-fad40b7b30ca&spaceId=e430ac3e-ca7a-48f9-804c-8fe9f7d4a267&expirationTimestamp=1728964800000&signature=cq5xOIwjdJggdd7bV7RkpZOLijMN69RLns2rrrpXyCs&downloadName=activity-response-ios.json"
        
        viewModel.loadActivityData(from: urlString) { [weak self] result in
            DispatchQueue.main.async {
                self?.showLoading(false)  // Hide loading indicator
                switch result {
                case .success(_):
                    self?.updateUI()
                    self?.progressBar.progress = self?.viewModel.getProgress() ?? 0
                case .failure(let error):
                    self?.showError(error: error)
                }
            }
        }
    }
    
    // MARK: - Show Loading Indicator
    private func showLoading(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
            contentView.isHidden = true
            backButton.isHidden = true
            nextButton.isHidden = true
        } else {
            loadingIndicator.stopAnimating()
            contentView.isHidden = false
            backButton.isHidden = false
            nextButton.isHidden = false
        }
    }
    
    // MARK: - Update UI
    private func updateUI() {
        guard let screen = viewModel.getCurrentScreen() else { return }
        
        // Remove old views
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Set up screen based on type
        if screen.type == .multipleChoiceModuleScreen {
            let multipleChoiceView = MultipleChoiceView()
            multipleChoiceView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(multipleChoiceView)
            multipleChoiceView.onContinueTapped = { [self] in
                viewModel.nextScreen()
                updateUI()
                progressBar.progress = viewModel.getProgress()
            }
            
            NSLayoutConstraint.activate([
                multipleChoiceView.topAnchor.constraint(equalTo: contentView.topAnchor),
                multipleChoiceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                multipleChoiceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                multipleChoiceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            
            multipleChoiceView.configure(with: screen)
        } else if screen.type == .recapModuleScreen {
            let recapView = RecapView()
            recapView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(recapView)
            recapView.setViewModel(self.viewModel)
            NSLayoutConstraint.activate([
                recapView.topAnchor.constraint(equalTo: contentView.topAnchor),
                recapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                recapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                recapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            recapView.onContinueTapped = { [self] in
                viewModel.nextScreen()
                updateUI()
                progressBar.progress = viewModel.getProgress()
            }
            
        }
    }
    
    // MARK: - Button Actions
    @objc private func closeButtonTapped() {
        
    }
    
    @objc private func backButtonTapped() {
        viewModel.previousScreen()
        updateUI()
        progressBar.progress = viewModel.getProgress()
    }
    
    // MARK: - Error Handling
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
