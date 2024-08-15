//
//  ViewController.swift
//  JRF Super Quiz
//
//  Created by Habibur Rahman on 8/11/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var mainBackground: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var playQuizButton: UIButton!
    @IBOutlet weak var highScoreLabel: UILabel!
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playQuizButton.layer.borderWidth = 0.5
        playQuizButton.layer.borderColor = UIColor.lightGray.cgColor
        playQuizButton.layer.masksToBounds = true
        playQuizButton.layer.cornerRadius = 25
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(navigateToMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(navigateToMenu))
        configure()
        subview.clipsToBounds = true
        subview.layer.cornerRadius = 25
        subview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let highScore = UserDefaults.standard.integer(forKey: "score")
        highScoreLabel.text = "\(highScore)"
    }
    
    func configure() {
        gradientLayer.frame = background.frame
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        background.layer.addSublayer(gradientLayer)
    }
    
    @objc func navigateToNotification() {
        
    }
    
    @objc func navigateToMenu() {
        
    }
    
    @IBAction func playQuizButtonTapped(_ sender: UIButton) {
        showAlertToStart()
    }
    
    func showAlertToStart() {
        let alert = UIAlertController(title: "Are you sure you want to start your quiz?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .cancel))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { [self] _ in
            let quizVC = storyboard?.instantiateViewController(identifier: "QuizVC") as! QuizViewController as QuizViewController
            navigationController?.pushViewController(quizVC, animated: true)
        }))
        present(alert, animated: true)
    }
}
