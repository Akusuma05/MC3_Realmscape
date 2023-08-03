//
//  ARViewController.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 02/08/23.
//

import ARKit
import RealityKit
import SwiftUI
import FocusEntity

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        let focusSquare = FocusEntity(on: arView, focus: .classic)
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        
        arView.enableObjectRemoval()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        var isModelEntityPresent = false
        
        if let model = modelConfirmedForPlacement {
            
            if let modelEntity = model.modelEntity{
                for anchor in uiView.scene.anchors {
                    for entity in anchor.children {
                        if entity == modelEntity {
                            print("DEBUG: adding clone model to scene - \(model.modelName)")
                            let clonedModelEntity = modelEntity.clone(recursive: true)
                            let anchorEntity = AnchorEntity(plane: .any)
                            uiView.scene.addAnchor(anchorEntity)
                            anchorEntity.addChild(clonedModelEntity)
                            
                            clonedModelEntity.generateCollisionShapes(recursive: true)
                            uiView.installGestures([.translation, .rotation], for: clonedModelEntity)
                            isModelEntityPresent = true
                            break
                        }
                        break
                    }
                    
                }
                if isModelEntityPresent == false{
                    print("DEBUG: adding model to scene - \(model.modelName)")
                    
                    let anchorEntity = AnchorEntity(plane: .any)
                    uiView.scene.addAnchor(anchorEntity)
                    anchorEntity.addChild(modelEntity)
                    
                    //Move and rotate
                    //Generate Collision Shapes
                    modelEntity.generateCollisionShapes(recursive: true)
                    uiView.installGestures([.translation, .rotation], for: modelEntity)
                }
                
            } else {
                print("DEBUG: Unable to load modelEntity for \(model.modelName)")
            }
            
            DispatchQueue.main.async {
                modelConfirmedForPlacement = nil
            }
        }
    }
}

extension ARView{
    //Delete Object
    func enableObjectRemoval() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
        let location = recognizer.location(in: self)
        
        if let entity = self.entity(at: location){
            if let anchorEntity = entity.anchor, anchorEntity.name == "CubeAnchor"{
                anchorEntity.removeFromParent()
                print("Removed anchor with name: " + anchorEntity.name)
            }
        }
    }
}



