//
//  ActivityViewModelTests.swift
//  ActivityAppTests
//
//  Created by JayR Atamosa on 10/15/24.
//

import XCTest
@testable import ActivityApp

class ActivityViewModelTests: XCTestCase {
    
    var viewModel: ActivityViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ActivityViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadActivityDataInvalidURL() {
        let expectation = self.expectation(description: "Loading activity data should fail with invalid URL")
        
        viewModel.loadActivityData(from: "invalid-url") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "unsupported URL")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadActivityDataNoData() {
        // Replace with a valid URL that returns no data for this test.
        let expectation = self.expectation(description: "Loading activity data should fail with no data")
        
        viewModel.loadActivityData(from: "https://example.com/no-data") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (Parsing Error error 500.)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testIsCorrectAnswer() {
        let answer1 = Answer(id: "1", text: "Correct Answer")
        let screen = Screen(id: "screen1", type: .multipleChoiceModuleScreen, question: "Sample Question?", multipleChoicesAllowed: false, choices: nil, eyebrow: nil, body: nil, answers: [answer1], correctAnswer: "1")
        
        viewModel.activityModel = ActivityModel(id: "activity1", state: "active", stateChangedAt: nil, title: "Sample Activity", description: "Activity Description", duration: "60", activity: Activity(screens: [screen]))
        
        XCTAssertTrue(viewModel.isCorrect("1"), "Expected answer to be correct")
        XCTAssertFalse(viewModel.isCorrect("wrongAnswer"), "Expected answer to be incorrect")
    }
    
    func testGetTotalScreens() {
        let screen1 = Screen(id: "screen1", type: .multipleChoiceModuleScreen, question: "Sample Question?", multipleChoicesAllowed: false, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        let screen2 = Screen(id: "screen2", type: .recapModuleScreen, question: nil, multipleChoicesAllowed: nil, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        
        viewModel.activityModel = ActivityModel(id: "activity1", state: "active", stateChangedAt: nil, title: "Sample Activity", description: "Activity Description", duration: "60", activity: Activity(screens: [screen1, screen2]))
        
        XCTAssertEqual(viewModel.getTotalScreens(), 2, "Expected total screens to be 2")
    }
    
    func testGetCurrentScreen() {
        let screen1 = Screen(id: "screen1", type: .multipleChoiceModuleScreen, question: "Sample Question?", multipleChoicesAllowed: false, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        let screen2 = Screen(id: "screen2", type: .recapModuleScreen, question: nil, multipleChoicesAllowed: nil, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        
        viewModel.activityModel = ActivityModel(id: "activity1", state: "active", stateChangedAt: nil, title: "Sample Activity", description: "Activity Description", duration: "60", activity: Activity(screens: [screen1, screen2]))
        
        XCTAssertEqual(viewModel.getCurrentScreen()?.id, "screen1", "Expected current screen to be screen1")
        
        viewModel.nextScreen()
        
        XCTAssertEqual(viewModel.getCurrentScreen()?.id, "screen2", "Expected current screen to be screen2")
    }
    
    func testNextScreen() {
        let screen1 = Screen(id: "screen1", type: .multipleChoiceModuleScreen, question: "Sample Question?", multipleChoicesAllowed: false, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        let screen2 = Screen(id: "screen2", type: .recapModuleScreen, question: nil, multipleChoicesAllowed: nil, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        
        viewModel.activityModel = ActivityModel(id: "activity1", state: "active", stateChangedAt: nil, title: "Sample Activity", description: "Activity Description", duration: "60", activity: Activity(screens: [screen1, screen2]))
        
        viewModel.nextScreen()
        XCTAssertEqual(viewModel.getCurrentScreen()?.id, "screen2", "Expected current screen to be screen2")
        
        viewModel.nextScreen() // Should not exceed the limit
        XCTAssertEqual(viewModel.getCurrentScreen()?.id, "screen2", "Expected current screen to remain screen2")
    }
    
    func testPreviousScreen() {
        let screen1 = Screen(id: "screen1", type: .multipleChoiceModuleScreen, question: "Sample Question?", multipleChoicesAllowed: false, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        let screen2 = Screen(id: "screen2", type: .recapModuleScreen, question: nil, multipleChoicesAllowed: nil, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        
        viewModel.activityModel = ActivityModel(id: "activity1", state: "active", stateChangedAt: nil, title: "Sample Activity", description: "Activity Description", duration: "60", activity: Activity(screens: [screen1, screen2]))
        
        viewModel.nextScreen() // Move to screen2
        viewModel.previousScreen() // Go back to screen1
        XCTAssertEqual(viewModel.getCurrentScreen()?.id, "screen1", "Expected current screen to be screen1")
    }
    
    func testGetProgress() {
        let screen1 = Screen(id: "screen1", type: .multipleChoiceModuleScreen, question: "Sample Question?", multipleChoicesAllowed: false, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        let screen2 = Screen(id: "screen2", type: .recapModuleScreen, question: nil, multipleChoicesAllowed: nil, choices: nil, eyebrow: nil, body: nil, answers: nil, correctAnswer: nil)
        
        viewModel.activityModel = ActivityModel(id: "activity1", state: "active", stateChangedAt: nil, title: "Sample Activity", description: "Activity Description", duration: "60", activity: Activity(screens: [screen1, screen2]))
        
        XCTAssertEqual(viewModel.getProgress(), 0.5, "Expected progress to be 50% after one screen")
        
        viewModel.nextScreen() // Move to next screen
        XCTAssertEqual(viewModel.getProgress(), 1.0, "Expected progress to be 100% after last screen")
    }
}
