//
//  ContentView.swift
//  GuessTheseMovies
//
//  Created by Loyio Hex on 1/21/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Guess These Movies")
                .fontWeight(.bold)
                .font(.largeTitle)
            Text("Can you guess the movie from these emojis?")
            Text("Tap the button to find out the answer")
            
            Button {
                speak(text: "The answer is Kung fu Panda")
            }label: {
                Text("🐼👊")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(20)
            
            Button {
                speak(text: "The answer is The Devil Wears Prada")
            }label: {
                Text("😈👗👠")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(20)
            
            Button {
                speak(text: "The answer is Apollo 13")
            }label: {
                Text("🚀🌛1⃣️3⃣️")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(20)
            
            Button {
                speak(text: "The answer is Spiderman")
            }label: {
                Text("🕷️🦸🏻‍♂️")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(20)
        }
        
    }
    
    func speak(text: String){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
