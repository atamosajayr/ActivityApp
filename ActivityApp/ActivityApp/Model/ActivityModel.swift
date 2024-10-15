//
//  ActivityModel.swift
//  ActivityApp
//
//  Created by JayR Atamosa on 10/12/24.
//
import Foundation

// MARK: - Root Model
struct ActivityModel: Codable {
    let id: String
    let state: String
    let stateChangedAt: String?
    let title: String
    let description: String
    let duration: String
    let activity: Activity
}

// MARK: - Activity
struct Activity: Codable {
    let screens: [Screen]
}

// MARK: - Screen
struct Screen: Codable {
    let id: String
    let type: ScreenType
    let question: String?
    let multipleChoicesAllowed: Bool?
    let choices: [Choice]?
    let eyebrow: String?
    let body: String?
    let answers: [Answer]?
    let correctAnswer: String?
}

// Enum to handle screen types
enum ScreenType: String, Codable {
    case multipleChoiceModuleScreen
    case recapModuleScreen
}

// MARK: - Choice
struct Choice: Codable {
    let id: String
    let text: String
    let emoji: String
}

// MARK: - Answer
struct Answer: Codable {
    let id: String
    let text: String
}

// MARK: - Generic Parsing Function
func parse<T: Decodable>(from jsonData: Data, toType type: T.Type) -> T? {
    let decoder = JSONDecoder()
    do {
        let decodedObject = try decoder.decode(type, from: jsonData)
        return decodedObject
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
