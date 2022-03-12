//
//  ContentView.swift
//  StudentTutor
//
//  Created by Loyio Hex on 1/21/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack(spacing:20) {
            VStack{
                Text("Instant Developer")
                    .font(.system(.largeTitle))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Get help from expert in 15 minutes")
                    .foregroundColor(.white)
            }
            
            HStack(alignment: .bottom, spacing: 20){
                Image("student")
                    .resizable()
                    .scaledToFit()
                Image("tutor")
                    .resizable()
                    .scaledToFit()
            }
            .padding(.horizontal, 50)
            
            Text("Need help with coding problem? Register!")
                .foregroundColor(.white)
            
            Spacer()
            
            if verticalSizeClass == .compact{
                HSignUpButtonGroup()
            }else{
                VSignUpButtonGroup()
            }
        }
        .padding(.top, 30)
        .frame(maxWidth: .infinity)
        .background{
            Image("background")
                .resizable()
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
            
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air")
        }
        
    }
}

struct VSignUpButtonGroup: View {
    var body: some View {
        VStack{
            Button{
                
            }label: {
                Text("Sign up")
            }
            .frame(width:200)
            .padding()
            .foregroundColor(.white)
            .background(Color.indigo)
            .cornerRadius(10)
            
            Button{
                
            }label: {
                Text("Log In")
            }
            .frame(width:200)
            .padding()
            .foregroundColor(.white)
            .background(Color.gray)
            .cornerRadius(10)
        }
    }
}

struct HSignUpButtonGroup: View {
    var body: some View {
        HStack{
            Button{
                
            }label: {
                Text("Sign up")
            }
            .frame(width:200)
            .padding()
            .foregroundColor(.white)
            .background(Color.indigo)
            .cornerRadius(10)
            
            Button{
                
            }label: {
                Text("Log In")
            }
            .frame(width:200)
            .padding()
            .foregroundColor(.white)
            .background(Color.gray)
            .cornerRadius(10)
        }
    }
}
