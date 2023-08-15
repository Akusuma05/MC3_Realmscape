//
//  ContentView.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 02/08/23.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ContentView : View {
    @State private var selectedModel: Model?
    @State private var showingSheet = false
    let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    @State private var activeIndex: Int = 0
    
    private var models: [Model] = {
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? filemanager.contentsOfDirectory(atPath: path) else { return []
        }
        
        var availableModels: [Model] = []
        for filename in files where filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName)
            availableModels.append(model)
        }
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            //Ar View Camera
            
            ARViewContainer(selectedModel: $selectedModel)
            
            
            //Radial Layout
            GeometryReader(content: { geometry in
                VStack{
                    Spacer(minLength: 0)
                    RadialLayout(items: models, id: \.modelName, spacing: 220) { Model, index, size in
                        Image(uiImage: models[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .background(Color.white)
                            .cornerRadius(40)
                            .overlay(
                                activeIndex == index ? RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 4)
                                    .showCase(order: 0, title: "Select a furniture by sliding left and right", cornerRadius: 10, style: .continuous, offset: 190)
                                : nil
                            )
                        
                    } onIndexChange: { index in
                        activeIndex = index
                        selectedModel = models[index]
                        
                    }
                    .padding(.horizontal, -150)
                    .frame(width: geometry.size.width, height: geometry.size.width / 2)
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            })
            .padding(15)
            
            
            //OnBoarding
        }
        .overlay(alignment: .bottom, content: {
            ZStack() {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 45, height: 45)
                    .showCase(order: 1, title: "Tap here to place object", cornerRadius: 30, style: .continuous, offset: 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 45, height: 45)
                    .showCase(order: 2, title: "Drag with 1 finger to move, and 2 fingers to rotate", cornerRadius: 30, style: .continuous, offset: 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 45, height: 45)
                    .showCase(order: 3, title: "Hold the object to delete", cornerRadius: 30, style: .continuous, offset: 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .allowsHitTesting(false)
        })
        .modifier(ShowCaseRoot(showHighlights: true, onFinished: {
            print("Finished OnBoarding")
        }))
    }
}


extension PresentationDetent {
    static let bar = Self.fraction(0.9)
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
