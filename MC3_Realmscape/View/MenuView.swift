//
//  MenuView.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 16/08/23.
//

import SwiftUI


struct MenuView: View {
    @State var animate = false
    
    var body: some View {
        NavigationView {
            ZStack{
                GifImage("Intro")
                    .scaledToFill()
                
                NavigationLink(destination: ContentView()) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
                Text("Click Here to Start")
                    .font(.largeTitle)
                    .onAppear { self.animate.toggle() }
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
