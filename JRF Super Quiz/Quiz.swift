//
//  Quiz.swift
//  JRF Super Quiz
//
//  Created by Habibur Rahman on 8/11/24.
//

import Foundation

struct Quiz: Codable {
    let questions: [Question]?
}

struct Question: Codable {
    let question: String?
    let answers: Answers?
    let questionImageURL: String?
    let correctAnswer: String?
    let score: Int?
    
    enum CodingKeys: String, CodingKey {
        case question
        case answers
        case questionImageURL = "questionImageUrl"
        case correctAnswer
        case score
    }
}

struct Answers: Codable {
    let a, b, c, d: String?
    
    enum CodingKeys: String, CodingKey {
        case a = "A"
        case b = "B"
        case c = "C"
        case d = "D"
    }
}
