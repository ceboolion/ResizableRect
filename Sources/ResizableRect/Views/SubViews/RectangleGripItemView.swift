//
//  RectangleGripItemView.swift
//  ResizableRect
//
//  Created by Cebooliom on 16/11/2025.
//

import SwiftUI

enum GripPosition {
    case top
    case bottom
    case left
    case right
}

struct RectangleGripItemView: View {
    
    @Binding var rect: CGRect
    @Binding var initialRect: CGRect
    var gripPosition: GripPosition
    var gripColor: Color
    var gripWidth: CGFloat
    var gripHeight: CGFloat
    
    // MARK: - VIEW BODY

    var body: some View {
        Rectangle()
            .fill(gripColor)
            .clipShape(Capsule())
            .frame(width: setFrameWidth(), height: setFrameHeight())
            .position(x: setPositionX(), y: setPositionY())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newPosition = setNewMaxY(value)
                        let newSize = setNewHeight(newPosition)

                        if newSize > gripWidth + 20 {
                            setRect(newPosition, newSize)
                        }
                    }
                    .onEnded { _ in initialRect = rect }
            )
    }
    
    private func setFrameWidth() -> CGFloat {
        switch gripPosition {
        case .top, .bottom: gripWidth
        case .left, .right: gripHeight
        }
    }
    
    private func setFrameHeight() -> CGFloat {
        switch gripPosition {
        case .top, .bottom: gripHeight
        case .left, .right: gripWidth
        }
    }
    
    private func setPositionX() -> CGFloat {
        switch gripPosition {
        case .top, .bottom: rect.midX
        case .left: rect.minX
        case .right: rect.maxX
        }
    }
    
    private func setPositionY() -> CGFloat {
        switch gripPosition {
        case .top: rect.minY
        case .bottom: rect.maxY
        case .left, .right: rect.midY
        }
    }
    
    private func setNewMaxY(_ value: DragGesture.Value) -> CGFloat {
        switch gripPosition {
        case .top: initialRect.minY + value.translation.height
        case .bottom: initialRect.maxY + value.translation.height
        case .left: initialRect.minX + value.translation.width
        case .right: initialRect.maxX + value.translation.width
        }
    }
    
    private func setNewHeight(_ value: CGFloat) -> CGFloat {
        switch gripPosition {
        case .top: initialRect.maxY - value
        case .bottom: value - initialRect.minY
        case .left: initialRect.maxX - value
        case .right: value - initialRect.minX
        }
    }
    
    private func setRect(_ newPosition: CGFloat? = nil, _ newSize: CGFloat? = nil) {
        switch gripPosition {
        case .top:
            guard let newPosition, let newSize else { return }
            rect.origin.y = newPosition
            rect.size.height = newSize
        case .bottom:
            guard let newSize else { return }
            rect.size.height = newSize
        case .left:
            guard let newPosition, let newSize else { return }
            rect.origin.x = newPosition
            rect.size.width = newSize
        case .right:
            guard let newSize else { return }
            rect.size.width = newSize
        }
    }
}

// MARK: - PREVIEW
#Preview("Top Grip") {
    RectangleGripItemView(
        rect: .constant(CGRect(x: 100, y: 200, width: 200, height: 200)),
        initialRect: .constant(.zero),
        gripPosition: .top,
        gripColor: Color.customGreen,
        gripWidth: 60,
        gripHeight: 3
    )
}

#Preview("Left Grip") {
    RectangleGripItemView(
        rect: .constant(CGRect(x: 100, y: 200, width: 200, height: 200)),
        initialRect: .constant(.zero),
        gripPosition: .left,
        gripColor: Color.customGreen,
        gripWidth: 60,
        gripHeight: 3
    )
}

#Preview("Bottom Grip") {
    RectangleGripItemView(
        rect: .constant(CGRect(x: 100, y: 200, width: 200, height: 200)),
        initialRect: .constant(.zero),
        gripPosition: .bottom,
        gripColor: Color.customGreen,
        gripWidth: 60,
        gripHeight: 3
    )
}

#Preview("Right Grip") {
    RectangleGripItemView(
        rect: .constant(CGRect(x: 100, y: 200, width: 200, height: 200)),
        initialRect: .constant(.zero),
        gripPosition: .right,
        gripColor: Color.customGreen,
        gripWidth: 60,
        gripHeight: 3
    )
}
