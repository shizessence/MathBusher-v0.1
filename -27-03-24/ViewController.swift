import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let appName: UILabel = {
        let appNameq = UILabel()
        appNameq.text = "Math Buster"
        appNameq.textColor = .init(red: 100/255, green: 100/255, blue: 50/255, alpha: 1)
        appNameq.font = .boldSystemFont(ofSize: 35)
        return appNameq
    }()
    
    let problem: UILabel = {
        let problem = UILabel()
        problem.text = "0/0=?"
        problem.textColor = .init(red: 100/255, green: 100/255, blue: 50/255, alpha: 1)
        problem.font = .boldSystemFont(ofSize: 35)
        return problem
    }()
    
    let score: UILabel = {
        let scoreq = UILabel()
        scoreq.text = "Score:"
        scoreq.textColor = .init(red: 100/255, green: 100/255, blue: 50/255, alpha: 1)
        scoreq.font = .italicSystemFont(ofSize: 20)
        return scoreq
    }()
    
    let actualScore: UILabel = {
        let scoreA = UILabel()
        scoreA.text = "0"
        scoreA.textColor = .init(red: 100/255, green: 100/255, blue: 50/255, alpha: 1)
        scoreA.font = .italicSystemFont(ofSize: 20)
        return scoreA
    }()
    
    lazy var answerInput: UITextField = {
        let answerInput = UITextField()
        answerInput.text = ""
        answerInput.backgroundColor = .white
        answerInput.layer.cornerRadius = 8
        return answerInput
    }()
    
    var difficulty: UISegmentedControl = {
        let difficulty = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
        return difficulty
    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .init(UIColor(red: 79/255, green: 111/255, blue: 82/255, alpha: 1))
        view.setProgress(0, animated: false)
        return view
    }()
    
    let sumbit: UIButton = {
        let sumbit = UIButton()
        sumbit.setTitle("Submit", for: .normal)
        sumbit.setTitleColor(.white, for: .normal)
        sumbit.backgroundColor = .red
        sumbit.layer.cornerRadius = 15
        sumbit.translatesAutoresizingMaskIntoConstraints = false
        return sumbit
    }()
    
    let restart: UIButton = {
        let restart = UIButton()
        restart.setTitle("Restart", for: .normal)
        restart.setTitleColor(.green, for: .normal)
        restart.translatesAutoresizingMaskIntoConstraints = false
        return restart
    }()
    
    var operand1 = 0
    var operand2 = 0
    var operatorSymbol = "+"
    var correctAnswersCount = 0 {
        didSet {
            let progress = Float(correctAnswersCount) / 15.0
            progressView.setProgress(progress, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(red: 236/255, green: 227/255, blue: 206/255, alpha: 1)
        view.addSubview(sumbit)
        view.addSubview(appName)
        view.addSubview(progressView)
        view.addSubview(answerInput)
        view.addSubview(score)
        view.addSubview(actualScore)
        view.addSubview(difficulty)
        view.addSubview(problem)
        view.addSubview(restart)
        
        problem.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-90)
        }
        
        sumbit.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(answerInput)
        }
        
        appName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-250)
        }
        
        progressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(appName).offset(20)
            make.width.equalTo(appName)
        }
        
        score.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(appName).offset(35)
            make.width.equalTo(appName)
        }
        
        answerInput.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.width.equalTo(appName)
            make.height.equalTo(sumbit)
        }
        
        actualScore.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(60)
            make.centerY.equalTo(appName).offset(35)
            make.width.equalTo(appName)
        }
        
        difficulty.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-180)
            make.width.equalTo(300)
        }
        
        restart.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(answerInput).offset(50)
        }
        
        sumbit.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        difficulty.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        generateRandomMathProblem()
    }
    
    @objc func submitButtonTapped() {
        guard let answerText = answerInput.text, let userAnswer = Int(answerText) else {
            return
        }
        
        let correctAnswer = calculateCorrectAnswer()
        
        if userAnswer == correctAnswer {
            updateScore()
            
            correctAnswersCount += 1
            
            if correctAnswersCount >= 15 {
                print("Вы достигли 15 правильных ответов!")
            }
            
            generateRandomMathProblem()
            
            answerInput.text = ""
        } else {
            print("Неверный ответ. Попробуйте еще раз.")
        }
    }
    
    func calculateCorrectAnswer() -> Int {
        var correctAnswer: Int
        
        switch operatorSymbol {
        case "+":
            correctAnswer = operand1 + operand2
        case "-":
            correctAnswer = operand1 - operand2
        case "*":
            correctAnswer = operand1 * operand2
        case "/":
            correctAnswer = operand1 / operand2
        default:
            correctAnswer = 0
        }
        
        return correctAnswer
    }
    
    func updateScore() {
        guard let currentScore = Int(actualScore.text ?? "0") else { return }
        let newScore = currentScore + 1
        actualScore.text = "\(newScore)"
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        generateRandomMathProblem()
    }
    
    func generateRandomMathProblem() {
        let maxOperand: Int
        switch difficulty.selectedSegmentIndex {
        case 0:
            maxOperand = 10
        case 1:
            maxOperand = 50
        case 2:
            maxOperand = 100
        default:
            maxOperand = 10
        }
        
        operand1 = Int.random(in: 0...maxOperand)
        operand2 = Int.random(in: 1...maxOperand)
        
        let operators = ["+", "-", "*", "/"]
        operatorSymbol = operators.randomElement() ?? "+"
        
        if operatorSymbol == "/" && operand2 == 0 {
            operand2 = 1
        }
        
        let mathProblem = "\(operand1) \(operatorSymbol) \(operand2) = ?"
        
        problem.text = mathProblem
    }

}
