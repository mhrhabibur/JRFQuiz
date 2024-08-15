//
//  QuizViewController.swift
//  JRF Super Quiz
//
//  Created by Habibur Rahman on 8/11/24.
//

import UIKit
import Alamofire
import SDWebImage

class QuizViewController: UIViewController {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var timerProgressView: UIProgressView!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var answerOptionA: UIButton!
    @IBOutlet weak var answerOptionB: UIButton!
    @IBOutlet weak var answerOptionC: UIButton!
    @IBOutlet weak var answerOptionD: UIButton!
    var gradientLayer = CAGradientLayer()
    var viewModel = QuizViewModel()
    var timer: Timer?
    var countdownTime = 10
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuizData()
        decorateButton()
        timerProgressView.progress = 0.0
        questionImageView.layer.masksToBounds = true
        questionImageView.layer.cornerRadius = 10
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(showAlertToQuit))
        subView.layer.masksToBounds = true
        subView.layer.cornerRadius = 20
        answerOptionA.backgroundColor = viewModel.notAnsweredColor
        answerOptionB.backgroundColor = viewModel.notAnsweredColor
        answerOptionC.backgroundColor = viewModel.notAnsweredColor
        answerOptionD.backgroundColor = viewModel.notAnsweredColor
        configure()
    }
    
    func configure() {
        gradientLayer.frame = background.frame
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        background.layer.addSublayer(gradientLayer)
    }
    
    func decorateButton() {
        let buttons = [answerOptionA, answerOptionB, answerOptionC, answerOptionD, nextButton]
        for button in buttons {
            button?.layer.borderWidth = 0.5
            button?.layer.borderColor = UIColor.lightGray.cgColor
            button?.layer.masksToBounds = true
            button?.layer.cornerRadius = 22
        }
    }
    
    func fetchQuizData() {
        AF.request("https://herosapp.nyc3.digitaloceanspaces.com/quiz.json").responseDecodable(of: Quiz.self) { response in
            self.viewModel.questions = (response.value?.questions)!
            self.questionLabel.text = String(self.viewModel.currentQuestion.question!)
            self.questionImageView.sd_setImage(with: URL(string: self.viewModel.currentQuestion.questionImageURL ?? ""), placeholderImage: UIImage(named: "JRF_Card.png"))
            self.questionNumberLabel.text = "Question \(self.viewModel.currentQuestionIndex + 1)/\(self.viewModel.questions.count)"
            self.showAnswer()
            if self.viewModel.questions.count == self.viewModel.currentQuestionIndex + 1 {
                self.nextButton.isEnabled = false
            }
        }
        startTimer()
    }
    
    func startTimer() {
        countdownTime = 10
        timerProgressView.progress = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if countdownTime > 0 {
            countdownTime -= 1
            countDownLabel.text = String(countdownTime) + " sec"
            timerProgressView.progress += 0.10
            timerProgressView.setProgress(timerProgressView.progress, animated: true)
        } else {
            timer?.invalidate()
            disablingButton()
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        showNextQuestion()
    }
    
    @objc func showNextQuestion() {
        answerOptionA.backgroundColor = viewModel.notAnsweredColor
        answerOptionB.backgroundColor = viewModel.notAnsweredColor
        answerOptionC.backgroundColor = viewModel.notAnsweredColor
        answerOptionD.backgroundColor = viewModel.notAnsweredColor
        self.viewModel.nextQuestion()
        self.questionLabel.text = String(self.viewModel.currentQuestion.question!)
        self.questionNumberLabel.text = "Question \(viewModel.currentQuestionIndex + 1)/\(viewModel.questions.count)"
        self.questionImageView.sd_setImage(with: URL(string: self.viewModel.currentQuestion.questionImageURL ?? ""), placeholderImage: UIImage(named: "JRF_Card.png"))
        showAnswer()
        if viewModel.questions.count == viewModel.currentQuestionIndex + 1 {
            nextButton.isEnabled = false
        }
        timer?.invalidate()
        startTimer()
        enablingButton()
    }

    func showAnswer() {
        if let optionA = viewModel.questions[viewModel.currentQuestionIndex].answers?.a?.capitalized {
            answerOptionA.isHidden = false
            answerOptionA.setTitle("A.  " + String(describing: optionA), for: .normal)
        } else {
            answerOptionA.isHidden = true
        }
        if let optionB = viewModel.questions[viewModel.currentQuestionIndex].answers?.b?.capitalized {
            answerOptionB.isHidden = false
            answerOptionB.setTitle("B.  " + String(describing: optionB), for: .normal)
        } else {
            answerOptionB.isHidden = true
        }
        if let optionC = viewModel.questions[viewModel.currentQuestionIndex].answers?.c?.capitalized {
            answerOptionC.isHidden = false
            answerOptionC.setTitle("C.  " + String(describing: optionC), for: .normal)
        } else {
            answerOptionC.isHidden = true
        }
        if let optionD = viewModel.questions[viewModel.currentQuestionIndex].answers?.d?.capitalized {
            answerOptionD.isHidden = false
            answerOptionD.setTitle("D.  " + String(describing: optionD), for: .normal)
        } else {
            answerOptionD.isHidden = true
        }
    }
    
    @IBAction func answerOptionATapped(_ sender: UIButton) {
        updateAnswer(selectedAnswer: "A", correctAnswer: self.viewModel.questions[self.viewModel.currentQuestionIndex].correctAnswer ?? "")
        coinLabel.text = "\(score)"
        disablingButton()
    }
    
    @IBAction func answerOptionBTapped(_ sender: UIButton) {
        updateAnswer(selectedAnswer: "B", correctAnswer: self.viewModel.questions[self.viewModel.currentQuestionIndex].correctAnswer ?? "")
        coinLabel.text = "\(score)"
        disablingButton()
    }
    
    @IBAction func answerOptionCTapped(_ sender: UIButton) {
        updateAnswer(selectedAnswer: "C", correctAnswer: self.viewModel.questions[self.viewModel.currentQuestionIndex].correctAnswer ?? "")
        coinLabel.text = "\(score)"
        disablingButton()
    }
    
    @IBAction func answerOptionDTapped(_ sender: UIButton) {
        updateAnswer(selectedAnswer: "D", correctAnswer: self.viewModel.questions[self.viewModel.currentQuestionIndex].correctAnswer ?? "")
        coinLabel.text = "\(score)"
        disablingButton()
    }
    
    func updateAnswer(selectedAnswer: String, correctAnswer: String) {
        if selectedAnswer == correctAnswer {
            score += viewModel.questions[viewModel.currentQuestionIndex].score ?? 0
            UserDefaults.standard.set(score, forKey: "score")
        }
        answerOptionA.backgroundColor = getAnswerOptionColor(currentOption: "A", selectedAnswer: selectedAnswer, correctAnswer: correctAnswer)
        answerOptionB.backgroundColor = getAnswerOptionColor(currentOption: "B", selectedAnswer: selectedAnswer, correctAnswer: correctAnswer)
        answerOptionC.backgroundColor = getAnswerOptionColor(currentOption: "C", selectedAnswer: selectedAnswer, correctAnswer: correctAnswer)
        answerOptionD.backgroundColor = getAnswerOptionColor(currentOption: "D", selectedAnswer: selectedAnswer, correctAnswer: correctAnswer)
    }
    
    func getAnswerOptionColor(currentOption: String, selectedAnswer: String, correctAnswer: String) -> UIColor {
        if currentOption == correctAnswer {
            return viewModel.rightAnswerColor
        } else if currentOption == selectedAnswer {
            return viewModel.wrongAnswerColor
        } else {
            return viewModel.notAnsweredColor
        }
    }
    
    func showCongratulationAlert() {
        let alert = UIAlertController(title: "Congratulations", message: "You have conpleted your quiz. Your score is \(score) and you have earnt \(score) coin.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back To Home", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc func showAlertToQuit() {
        let alert = UIAlertController(title: "Are you sure you want to exit your quiz?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .cancel))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func disablingButton() {
        timer?.invalidate()
        nextButton.isEnabled = false
        answerOptionA.isEnabled = false
        answerOptionB.isEnabled = false
        answerOptionC.isEnabled = false
        answerOptionD.isEnabled = false
        if viewModel.questions.count == viewModel.currentQuestionIndex + 1 {
            showCongratulationAlert()
        }
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(showNextQuestion), userInfo: nil, repeats: false)
    }
    
    func enablingButton() {
        countDownLabel.text = "10 sec"
        nextButton.isEnabled = true
        if viewModel.questions.count == viewModel.currentQuestionIndex + 1 {
            nextButton.isEnabled = false
        }
        answerOptionA.isEnabled = true
        answerOptionB.isEnabled = true
        answerOptionC.isEnabled = true
        answerOptionD.isEnabled = true
    }
}
