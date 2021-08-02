//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Luke Inger on 28/02/2021.
//

import SwiftUI

struct flagModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
    }
}

extension View {
    func flagStyle() -> some View {
        self.modifier(flagModifier())
    }
}

struct CornerRotationModifier : ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot : AnyTransition {
        .modifier(
            active: CornerRotationModifier(amount: -360, anchor: .topLeading),
            identity: CornerRotationModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var ScoreTitle = ""
    @State private var ScoreMessage = ""
    @State private var ShowingScore = false
    @State private var currentScore = 0
    @State private var correct = false
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack{
                    Text("Tap the correct flag for")
                        .foregroundColor(.white)
                    Text("\(countries[correctAnswer])")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach (0 ..< 3){ number in
                    Button(action:{
                        flagTapped(number)
                    }) {
                        if number == correctAnswer {
                            Image(self.countries[number])
                                .renderingMode(.original)
                                .shadow(color: .black, radius: 2)
                                .flagStyle()
                                .rotationEffect(.degrees(correct ? 360 : 0))
                                .animation(.default)
                        } else {
                            Image(self.countries[number])
                                .renderingMode(.original)
                                .shadow(color: .black, radius: 2)
                                .flagStyle()
                                .opacity(correct ? 0.25 : 1)
                        }
                    }
                }
                
                Text("Your current score is \(currentScore)")
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            .alert(isPresented: $ShowingScore) {
                Alert(title: Text(ScoreTitle), message: Text(ScoreMessage), dismissButton: .default(Text("Continue")){
                    askQuestion()
                })
            }

        }
    }
    
    func flagTapped(_ number:Int){
        if (number==correctAnswer){
            ScoreTitle = "Correct"
            currentScore += 1
            ScoreMessage = "Your score is \(currentScore)"
            correct = true
        } else {
            ScoreTitle = "Incorrect"
            ScoreMessage = "Thats the flag for \(self.countries[number])"
            correct = false
        }
        ShowingScore = true
    }
    
    func askQuestion(){
        correct = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
