//
//  QuizViewModel.swift
//  JRF Super Quiz
//
//  Created by Habibur Rahman on 8/12/24.
//

import Foundation
import UIKit

class QuizViewModel {
    
    var questions: [Question] = []
    var currentQuestionIndex = 0
    var score = 0
    var wrongAnswerColor = UIColor.red
    var rightAnswerColor = UIColor.green.withAlphaComponent(0.2)
    var notAnsweredColor = UIColor.white
    var currentQuestion: Question {
        return questions[currentQuestionIndex]
    }
    
    func nextQuestion() {
        currentQuestionIndex = min(currentQuestionIndex + 1, questions.count - 1)
    }
    
    func checkAnswer(selectedAnswer: String) -> Bool {
        return selectedAnswer == currentQuestion.correctAnswer
    }
}
