//
//  RadialView.swift
//  MC3_Realmscape
//
//  Created by Angelo Kusuma on 10/08/23.
//

import SwiftUI

struct RadialLayout<Content: View, Item: RandomAccessCollection, ID: Hashable>: View where Item.Element: Identifiable{
    var content: (Item.Element, Int, CGFloat) -> Content
    var keyPathID: KeyPath<Item.Element, ID>
    var items: Item
    var spacing: CGFloat?
    var onIndexChange: (Int) -> ()
    
    init(items: Item, id: KeyPath<Item.Element, ID>, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (Item.Element, Int, CGFloat) -> Content, onIndexChange: @escaping (Int) -> ()){
        self.content = content
        self.onIndexChange = onIndexChange
        self.spacing = spacing
        self.keyPathID = id
        self.items = items
    }
    
    @State private var activeIndex: Int = 0
    @State private var dragRotation: Angle = .zero
    @State private var lastDragRotation: Angle = .zero
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let width = size.width
            let count = CGFloat(items.count)
            let spacing: CGFloat = spacing ?? 0
            let viewSize = (width - spacing) / (count / 2)
            
            ZStack(content: {
                ForEach(items, id: keyPathID){ item in
                    let index = fetchIndex(item)
                    let rotation = (CGFloat(index) / count) * 360.0
                    
                    content(item, index, viewSize)
                        .rotationEffect(.init(degrees: 90))
                        .rotationEffect(.init(degrees: -rotation))
                        .rotationEffect(-dragRotation)
                        .frame(width: viewSize, height: viewSize)
                        .offset(x: (width - viewSize) / 2)
                        .rotationEffect(.init(degrees: -90))
                        .rotationEffect(.init(degrees: rotation))

                }
            })
            .frame(width: width, height: width)
            .contentShape(Rectangle())
            .rotationEffect(dragRotation)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationX = value.translation.width
                        
                        let progress = translationX / viewSize
                        let rotationFraction = 360.0 / count
                        
                        dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                        calculateIndex(count)
                    }).onEnded({ value in
                        let translationX = value.translation.width
                        
                        let progress = (translationX / viewSize).rounded()
                        let rotationFraction = 360.0 / count
                        
                        withAnimation(.easeInOut) {
                            dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                        }
                        
                        lastDragRotation = dragRotation
                        calculateIndex(count)
                    })
            )
        })
    }
    
    func calculateIndex(_ count: CGFloat) {
        var activeIndex = (dragRotation.degrees / 360.0 * count).rounded().truncatingRemainder(dividingBy: count)
        activeIndex = activeIndex == 0 ? 0 : (activeIndex < 0 ? -activeIndex : count - activeIndex)
        self.activeIndex = Int(activeIndex)
        onIndexChange(self.activeIndex)
    }
    
    func fetchIndex(_ item: Item.Element) -> Int {
        if let index = items.firstIndex(where: {
            $0.id == item.id
        }) as? Int {
            return index
        }
        return 0
    }
}

struct RadialView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
