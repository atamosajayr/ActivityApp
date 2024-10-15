//
//  ActivityViewModel.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/12/24.
//

import Foundation

// MARK: - ActivityViewModel
class ActivityViewModel {
    
    // MARK: - Properties
    internal var activityModel: ActivityModel?
    private var currentScreenIndex = 0
    
    // MARK: - Initialization
    init() {}
    
    // MARK: - Public Methods
    
    // Function to load activity data from a URL
    func loadActivityData(from urlString: String, completion: @escaping (Result<ActivityModel, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")  // Check the response
            }
            
            if let activityModel: ActivityModel = parse(from: data, toType: ActivityModel.self) {
                self?.activityModel = activityModel
                completion(.success(activityModel))
            } else {
                completion(.failure(NSError(domain: "Parsing Error", code: 500, userInfo: nil)))
            }
        }.resume()
    }
    
    func isCorrect(_ answer:String) -> Bool {
        guard let screen = getCurrentScreen() else { return false }
        if screen.correctAnswer == answer {
            return true
        } else {
            return false
        }
    }
    
    // Get the total number of screens
    func getTotalScreens() -> Int {
        return activityModel?.activity.screens.count ?? 0
    }
    
    // Get the current screen model
    func getCurrentScreen() -> Screen? {
        guard let activityModel = activityModel, currentScreenIndex < activityModel.activity.screens.count else {
            return nil
        }
        return activityModel.activity.screens[currentScreenIndex]
    }
    
    // Navigate to the next screen
    func nextScreen() {
        guard let activityModel = activityModel, currentScreenIndex < activityModel.activity.screens.count - 1 else {
            return
        }
        currentScreenIndex += 1
    }
    
    // Navigate to the previous screen
    func previousScreen() {
        if currentScreenIndex > 0 {
            currentScreenIndex -= 1
        }
    }
    
    // Get progress percentage
    func getProgress() -> Float {
        guard let activityModel = activityModel else { return 0 }
        return Float(currentScreenIndex + 1) / Float(activityModel.activity.screens.count)
    }
}
