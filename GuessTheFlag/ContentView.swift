import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
        .shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
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
            Text("Your score is \(score)")
        }
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
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.bottom, 10)
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
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
        }
        
        showingScore = true
    }
    
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
