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
            ARViewContainer(selectedModel: $selectedModel)
            
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
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: activeIndex == index ? 4 : 0))
                        
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
        }
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
