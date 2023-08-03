//
//  PlacementButtonView.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 03/08/23.
//

import Foundation
import ARKit
import SwiftUI
import RealityKit

struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    var body: some View{
        HStack {
            //Cancel Button
            Button(action: {
                print("DEBUG: Cancel model placement.")
                resetPlacementParamaters()
            }) {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            //Confirm Button
            Button(action: {
                print("DEBUG: Confirm model placement.")
                modelConfirmedForPlacement = selectedModel
                resetPlacementParamaters()
                
            }) {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParamaters(){
        isPlacementEnabled = false
        selectedModel = nil
    }
}
