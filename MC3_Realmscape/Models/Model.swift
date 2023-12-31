//
//  Model.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 04/08/23.
//

import Foundation
import UIKit
import RealityKit
import Combine

class Model: Identifiable {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                //Handle Error
                print("DEBUG: Unable to load modelEntity for modelName: \(self.modelName)")
            }, receiveValue: { modelEntity in
                //Get our ModelEntity
                self.modelEntity = modelEntity
                print("DEBUG: Successfully loaded modelEntity for modalName: \(self.modelName)")
            })
    }
}
