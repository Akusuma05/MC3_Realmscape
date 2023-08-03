//
//  ARViewController.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 02/08/23.
//

import ARKit
import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
//        coffeeTable()
//
//        arView.enableObjectRemoval()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = modelConfirmedForPlacement {
            
            if let modelEntity = model.modelEntity {
                print("DEBUG: adding model to scene - \(model.modelName)")
                
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("DEBUG: Unable to load modelEntity for \(model.modelName)")
            }
            
            DispatchQueue.main.async {
                modelConfirmedForPlacement = nil
            }
        }
    }
    
//    func createBox(){
//        let mesh = MeshResource.generateBox(size: 0.2)
//        let material = SimpleMaterial(color: .red, isMetallic: true)
//        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
//        let anchorEntity = AnchorEntity(plane: .horizontal)
//        anchorEntity.name = "CubeAnchor"
//        anchorEntity.addChild(modelEntity)
//        arView.scene.addAnchor(anchorEntity)
//
//        //Move and rotate
//        //Generate Collision Shapes
//        modelEntity.generateCollisionShapes(recursive: true)
//
//        //Install Gesture
//        arView.installGestures([.translation, .rotation], for: modelEntity)
//    }
    
//    func coffeeTable(){
//        let entity = try! ModelEntity.loadModel(named: "robot_walk_idle")
//        let anchor: AnchorEntity = AnchorEntity(plane: .horizontal)
//        arView.scene.addAnchor(anchor)
//        anchor.addChild(entity)
//        //Move and rotate
//        //Generate Collision Shapes
//        entity.generateCollisionShapes(recursive: true)
//
//        //Install Gesture
//        arView.installGestures([.translation, .rotation], for: entity)
//    }
}

//extension ARView{
//    //Delete Object
//    func enableObjectRemoval() {
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
//        self.addGestureRecognizer(longPressGestureRecognizer)
//    }
//
//    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
//        let location = recognizer.location(in: self)
//
//        if let entity = self.entity(at: location){
//            if let anchorEntity = entity.anchor, anchorEntity.name == "CubeAnchor"{
//                anchorEntity.removeFromParent()
//                print("Removed anchor with name: " + anchorEntity.name)
//            }
//        }
//    }
//}



