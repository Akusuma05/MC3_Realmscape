//
//  Highlight.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 14/08/23.
//

import SwiftUI

struct Highlight: Identifiable, Equatable {
    var id: UUID = .init()
    var anchor: Anchor<CGRect>
    var title: String
    var cornerRadius: CGFloat
    var style: RoundedCornerStyle = .continuous
    var scale: CGFloat = 1
    var offset: CGFloat
}
