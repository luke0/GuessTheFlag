//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Luke Inger on 28/02/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var ScoreTitle = ""
    @State private var ScoreMessage = ""
    @State private var ShowingScore = false
    @State private var currentScore = 0
    
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
                        Image(self.countries[number]).renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
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
        } else {
            ScoreTitle = "Incorrect"
            ScoreMessage = "Thats the flag for \(self.countries[number])"
        }
        ShowingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
