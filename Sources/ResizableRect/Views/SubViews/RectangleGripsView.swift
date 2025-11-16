//
//  RectangleGripsView.swift
//  ResizableRect
//
//  Created by Ceboolion on 16/11/2025.
//

import SwiftUI

struct RectangleGripsView: View {

    // MARK: - PUBLIC PROPERTIES

    @Binding var rect: CGRect
    @Binding var initialRect: CGRect
    var gripColor: Color
    var gripWidth: CGFloat
    var gripHeight: CGFloat

    // MARK: - INITIALIZERS

    var body: some View {
        Group {
            RectangleGripItemView(rect: $rect, initialRect: $initialRect, gripPosition: .top, gripColor: gripColor, gripWidth: gripWidth, gripHeight: gripHeight)
            RectangleGripItemView(rect: $rect, initialRect: $initialRect, gripPosition: .left, gripColor: gripColor, gripWidth: gripWidth, gripHeight: gripHeight)
            RectangleGripItemView(rect: $rect, initialRect: $initialRect, gripPosition: .bottom, gripColor: gripColor, gripWidth: gripWidth, gripHeight: gripHeight)
            RectangleGripItemView(rect: $rect, initialRect: $initialRect, gripPosition: .right, gripColor: gripColor, gripWidth: gripWidth, gripHeight: gripHeight)
        }
    }
}

// MARK: - PREVIEW

#Preview {
    ResizableRectView()
}
