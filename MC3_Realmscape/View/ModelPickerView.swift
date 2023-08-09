//
//  ModelPickerView.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 03/08/23.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI

struct ModelPickerView: View {
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack (spacing: 30){
                ForEach (0 ..< models.count){
                    index in
                    Button(action: {
                        print("DEBUG: selected model with name: \(models[index])")
                        selectedModel = models[index]
                    }) {
                        Image(uiImage: models[index].image)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}
