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
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        let config = ARWorldTrackingConfiguration()
        let focusSquare = FocusEntity(on: arView, focus: .classic)
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        arView.enableTapGesture()
        arView.enableObjectRemoval()
        return arView
    }
    
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        var isModelEntityPresent = false
        
        if let model = modelConfirmedForPlacement {
            uiView.model = model
//            if let modelEntity = model.modelEntity {
//                for anchor in uiView.scene.anchors {
//                    for entity in anchor.children {
//                        if entity == modelEntity {
//                            print("DEBUG: adding clone model to scene - \(model.modelName)")
//                            let clonedModelEntity = modelEntity.clone(recursive: true)
//                            let anchorEntity = AnchorEntity(plane: .any)
//                            uiView.scene.addAnchor(anchorEntity)
//                            anchorEntity.addChild(clonedModelEntity)
//
//                            clonedModelEntity.generateCollisionShapes(recursive: true)
//                            uiView.installGestures([.translation, .rotation], for: clonedModelEntity)
//                            isModelEntityPresent = true
//                            break
//                        }
//                        break
//                    }
//
//                }
//                if isModelEntityPresent == false{
//                    print("DEBUG: adding model to scene - \(model.modelName)")
//
//                    let anchorEntity = AnchorEntity(plane: .any)
//                    uiView.scene.addAnchor(anchorEntity)
//                    anchorEntity.addChild(modelEntity)
//
//                    //Move and rotate
//                    //Generate Collision Shapes
//                    modelEntity.generateCollisionShapes(recursive: true)
//                    uiView.installGestures([.translation, .rotation], for: modelEntity)
//                }
//
//            } else {
//                print("DEBUG: Unable to load modelEntity for \(model.modelName)")
//            }
            
            DispatchQueue.main.async {
                modelConfirmedForPlacement = nil
            }
        }
    }
}


class CustomARView:ARView{
    var model:Model?
    var isModelEntityPresent = false
}

extension CustomARView{
    //Delete Object
    func enableObjectRemoval() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func enableTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer: )))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        let tapLocation = recognizer.location(in: self)
        
        guard let rayResult = self.ray(through: tapLocation) else { return }
        
        let results = self.scene.raycast(origin: rayResult.origin, direction: rayResult.direction)
        
        if let firstResult = results.first{
            var position = firstResult.position
            print("DEBUG: Tap Entity Position: \(position)")
            
            placeObject(at: position)
            
        } else {
            let results = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
            
            if let firstResult = results.first {
                let position = simd_make_float3(firstResult.worldTransform.columns.3)
                placeObject(at: position)
            }
        }
    }
    
    func placeObject(at position: SIMD3<Float>) {
        
        guard let modelEntitys = model else {return}
        
        print("DEBUG: adding model to scene - \(modelEntitys.modelName)")
        
        if let modelEntity = modelEntitys.modelEntity {
            for anchor in self.scene.anchors {
                for entity in anchor.children {
                    if entity == modelEntity {
                        print("DEBUG: adding clone model to scene - \(modelEntitys.modelName)")
                        let clonedModelEntity = modelEntity.clone(recursive: true)
                        let anchorEntity = AnchorEntity(world: position)
                        self.scene.addAnchor(anchorEntity)
                        anchorEntity.addChild(clonedModelEntity)
                        
                        clonedModelEntity.generateCollisionShapes(recursive: true)
                        self.installGestures([.translation, .rotation], for: clonedModelEntity)
                        isModelEntityPresent = true
                        break
                    }
                    break
                }
            }
            
            if isModelEntityPresent == false{
                print("DEBUG: adding model to scene - \(modelEntitys.modelName)")
                
                let anchorEntity = AnchorEntity(world: position)
                self.scene.addAnchor(anchorEntity)
                anchorEntity.addChild(modelEntity)
                
                //Move and rotate
                //Generate Collision Shapes
                modelEntity.generateCollisionShapes(recursive: true)
                self.installGestures([.translation, .rotation], for: modelEntity)
            } else {
                isModelEntityPresent = false
            }
            
        } else {
            print("DEBUG: Unable to load modelEntity for \(modelEntitys.modelName)")
        }
    }
    
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
        let location = recognizer.location(in: self)
        
        if let entity = self.entity(at: location), let modelEntity = entity as? ModelEntity{
            modelEntity.removeFromParent()
        }
    }
}


