import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
        .shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    
    private static let numberOfQuestions = 8
    @State private var questionsLeft = Self.numberOfQuestions
    @State private var questionIndex = 1
    @State private var showingEndGame = false
    
    @State private var flagRotations = [0.0, 0.0, 0.0]
    @State private var flagOpacities = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            gameBackground
            
            VStack {
                Spacer()
                
                gameTitle
                
                boardGame
                
                Spacer()
                Spacer()
                
                scoreView
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage.isEmpty ? "Your score is \(score)" : "\(scoreMessage)\n\nYour score is \(score)")
        }
        .alert("Game is Over!", isPresented: $showingEndGame, actions: {
            Button("Restart game", action: reset)
        }, message: resetMessage)
    }
    
    private var gameBackground: some View {
        RadialGradient(stops: [
            .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
            .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
        ], center: .top, startRadius: 200, endRadius: 400)
        .ignoresSafeArea()
    }
    
    private var gameTitle: some View {
        Text("Guess the Flag")
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.white)
    }
    
    private var boardGame: some View {
        VStack(spacing: 15) {
            VStack {
                Text("Tap the flag of")
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(.secondary)
                
                Text(countries[correctAnswer])
                    .font(.largeTitle.weight(.semibold))
            }
            
            ForEach(0..<3) { number in
                Button {
                    didTapFlag(with: number)
                } label: {
                    Image(countries[number])
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                        .shadow(radius: 5)
                        .rotation3DEffect(.degrees(flagRotations[number]), axis: (0, 1, 0))
                        .opacity(flagOpacities[number])
                }
            }
            
            Text("Question \(questionIndex)/\(Self.numberOfQuestions)")
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var scoreView: some View {
        Text("Score: \(score) \(pointsString)")
            .foregroundStyle(.white)
            .font(.title.bold())
    }
    
    private var pointsString: String {
        score == 1 ? "point" : "points"
    }
    
    private func didTapFlag(with number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct ✅"
            scoreMessage = ""
            score += 1
        } else {
            scoreTitle = "Wrong 🔴"
            scoreMessage = "That's the flag of \(countries[number])"
            score -= 1
        }
        
        showingScore = true
        questionsLeft -= 1
        
        withAnimation {
            flagRotations[number] += 360
            
            let secondFlagIndex = (number + 1) % 3
            flagOpacities[secondFlagIndex] = 0.25
            
            let thirdFlagIndex = (secondFlagIndex + 1) % 3
            flagOpacities[thirdFlagIndex] = 0.25
        }
    }
    
    private func askQuestion() {
        withAnimation {
            flagOpacities = flagOpacities.map { _ in 1.0 }
        }
        
        if questionsLeft == 0 {
            showingEndGame = true
            return
        }
        
        questionIndex += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    private func reset() {
        questionsLeft = Self.numberOfQuestions
        questionIndex = 0
        score = 0
        
        askQuestion()
    }

    private func resetMessage() -> some View {
        Text("You already went through all the questions.\n Your final score is:\n\(score) out of \(Self.numberOfQuestions)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
