//
//  ContentView.swift
//  Edutainment
//
//  Created by Varun Kumar Raghav on 30/08/21.
//

import SwiftUI
struct Question {
    var text: String
    var answer: Int
}

struct ContentView: View {
    @State private var gameIsRunning = false
    @State private var multiplicationTable = 1
    let allMultiplicationTable = ClosedRange(1..<13)
    @State private var countOfQuestions = "5"
    let variantsOfQuestions = ["5","10","15","20","all"]
    @State private var arrayOfQuestions = [Question]()
    @State private var currentQuestion = 0
    @State private var arrayOfAnswers = [Question]()
    @State private var selectedNumber = 0
    @State private var totalScore = 0
    @State private var remainingQuestions = 0
    @State private var isCorrect = false
    @State private var isWrong = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var buttonAlertTitle = ""
    @State private var isWinGame = false
    var body: some View {
        Group{
            ZStack{LinearGradient(gradient: Gradient(colors: [.gray,.orange, .gray]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                if gameIsRunning {
                    VStack{
                        // Game Running part
                        Text(arrayOfQuestions[currentQuestion].text).bold()
                        VStack{
                            ForEach(0..<4, id: \.self){ number in
                                Button(action: {
                                    checkAnswer(selected: number)
                                }, label: {
                                    Text("\(arrayOfAnswers[number].answer)")
                                })
                            }
                        }
                        // Game Running part ends here
                    }
                }
                else {
                    VStack{
                        // Start or game setup view
                    
                        Text("Select Multiplication Table")
                            .padding()
                        Stepper(value: $multiplicationTable, in: allMultiplicationTable, step: 1){
                            Text("Table of \(multiplicationTable) is selected.").padding()
                        }
                        Spacer()
                        Text("Select Number of Questions")
                            .padding()
                        Picker("Select number of questions", selection: $countOfQuestions){
                            ForEach(variantsOfQuestions, id: \.self){
                                Text("\($0)")
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        Spacer()
                        
                        Button("Start Game"){
                            self.newGame()
                        }
                        Spacer()
                        
                        // Start or game setup view ends here
                    }
                }
            }
        }.alert(isPresented: $showingAlert){ () -> Alert in
            Alert(title: Text("\(alertTitle)"), message: Text("Your score is \(totalScore)"), dismissButton: .default(Text("\(buttonAlertTitle)")){
                if self.isWinGame {
                    self.gameIsRunning = false
                    self.isWinGame = false
                    self.isCorrect = false
                } else if self.isCorrect  {
                    self.isCorrect = false
                    self.newQuestion()
                } else {
                    self.isWrong = false
                }
            })
        }
    }
    // your methods comes here
    func newGame(){
        self.gameIsRunning = true
        self.arrayOfQuestions = []
        self.createArrayOfQuestions()
        self.currentQuestion = 0
        self.arrayOfAnswers = []
        self.createArrayOfAnswers()
        self.setQuetionsCount()
        self.totalScore = 0
    }
    func newQuestion() {
        self.currentQuestion += 1
        self.arrayOfAnswers = []
        self.createArrayOfAnswers()
    }
    
    func createArrayOfQuestions() {
        for i in 1...multiplicationTable {
            for j in 1...10 {
                let newQuestion = Question(text: "How much is \(i) * \(j) ??", answer: i*j)
                arrayOfQuestions.append(newQuestion)
            }
        }
        self.arrayOfQuestions.shuffle()
        self.currentQuestion = 0
        self.arrayOfAnswers = []
    }
    
    func createArrayOfAnswers() {
        if currentQuestion + 4 < arrayOfQuestions.count{
            for i in currentQuestion ... currentQuestion + 3 {
                arrayOfAnswers.append(arrayOfQuestions[i])
            }
        }else{
            for i in arrayOfQuestions.count - 4 ..< arrayOfQuestions.count{
                arrayOfAnswers.append(arrayOfQuestions[i])
            }
        }
        self.arrayOfAnswers.shuffle()
    }
    
    func setQuetionsCount() {
        guard let count = Int(self.countOfQuestions) else {
            remainingQuestions = arrayOfQuestions.count
            return
        }
        remainingQuestions = count
    }
    
    func checkAnswer(selected number: Int) {
        self.selectedNumber = number
        if arrayOfAnswers[selectedNumber].answer == arrayOfQuestions[currentQuestion].answer {
            self.isCorrect = true
            remainingQuestions -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                if self.remainingQuestions == 0 {
                    alertTitle = "You Won !!"
                    buttonAlertTitle = "Play Again"
                    totalScore += 1
                    isWinGame = true
                    showingAlert = true
                }else{
                    alertTitle = "Right Answer"
                    buttonAlertTitle = "New Question"
                    totalScore += 1
                    showingAlert = true
                }
            }
        }else{
            self.isWrong = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                alertTitle = "Wrong Answer"
                buttonAlertTitle = "Try Again!!"
                showingAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
