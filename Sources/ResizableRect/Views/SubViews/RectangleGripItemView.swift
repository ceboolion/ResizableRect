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

    // MARK: - PRIVATE PROPERTIES

    @State private var shouldResize: Bool = true
    @State private var defaultTopPosition: CGFloat = 0
    @State private var defaultBottomPosition: CGFloat = 0
    @State private var defaultSize: CGSize = .init()
    
    // MARK: - PUBLIC PROPERTIES

    @Binding var rect: CGRect
    @Binding var initialRect: CGRect
//    var initialSize: CGSize
    var horizontalPadding: CGFloat
    var verticalPadding: CGFloat
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
                        let newPosition = getNewPosition(value)
                        let newSize = getNewSize(newPosition)
                        if shouldResize(for: newSize) {
                            updateRect(newPosition, newSize)
                        }
                    }
                    .onEnded { value in
                        let newPosition = getNewPosition(value)
                        let newSize = getNewSize(newPosition)
                        resetSizeToDefaultIfNeeded(newPosition, newSize)
                        initialRect = rect
                    }
            )
            .onAppear {
                defaultTopPosition = rect.minY
                defaultBottomPosition = rect.maxY
                defaultSize = rect.size
            }
    }
    
    private func resetSizeToDefaultIfNeeded(_ newPosition: CGFloat, _ newSize: CGFloat) {
        switch gripPosition {
        case .top:
            withAnimation(.bouncy) {
                if newPosition < verticalPadding {
                    updateRect(horizontalPadding, initialRect.height)
                } else {
                    updateRect(newPosition, newSize)
                }
            }
        case .bottom:
            if newSize > defaultSize.height {
                withAnimation(.bouncy) {
                    updateRect(newPosition, defaultSize.height)
                }
            }
        case .left:
            withAnimation(.bouncy) {
                if newPosition < horizontalPadding {
                    updateRect(horizontalPadding, defaultSize.width)
                } else {
                    updateRect(newPosition, newSize)
                }
            }
        case .right:
            withAnimation(.bouncy) {
                if newSize > defaultSize.width - horizontalPadding {
                    updateRect(initialRect.maxX, defaultSize.width)
                } else {
                    updateRect(newPosition, newSize)
                }
            }
        }
    }

    // MARK: - PRIVATE METHODS

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
        case .top, .bottom: rect.midX + (horizontalPadding / 2)
        case .left: rect.minX + (horizontalPadding / 2)
        case .right: rect.maxX + (horizontalPadding / 2)
        }
    }
    
    private func setPositionY() -> CGFloat {
        switch gripPosition {
        case .top: rect.minY + (verticalPadding / 2)
        case .bottom: rect.maxY + (verticalPadding / 2)
        case .left, .right: rect.midY + (verticalPadding / 2)
        }
    }
    
    private func getNewPosition(_ value: DragGesture.Value) -> CGFloat {
        switch gripPosition {
        case .top: initialRect.minY + value.translation.height
        case .bottom: initialRect.maxY + value.translation.height
        case .left: initialRect.minX + value.translation.width
        case .right: initialRect.maxX + value.translation.width
        }
    }
    
    private func getNewSize(_ value: CGFloat) -> CGFloat {
        switch gripPosition {
        case .top: initialRect.maxY - value
        case .bottom: value - initialRect.minY
        case .left: initialRect.maxX - value
        case .right: value - initialRect.minX
        }
    }
    
    private func updateRect(_ newPosition: CGFloat? = nil, _ newSize: CGFloat? = nil) {
        guard let newPosition, let newSize else { return }
        switch gripPosition {
        case .top:
            rect.origin.y = newPosition
            rect.size.height = newSize
        case .bottom:
            rect.size.height = newSize
        case .left:
            rect.origin.x = newPosition
            rect.size.width = newSize
        case .right:
            rect.size.width = newSize
        }
    }
    
    private func shouldResize(for newSize: CGFloat) -> Bool {
        newSize > gripWidth + 30
    }
}

// MARK: - PREVIEW
#Preview("All grips") {
    ResizableRectView(
        rectViewWidth: UIScreen.width,
        rectViewHeight: 600,
        horizontalPadding: 16,
        verticalPadding: 16,
        cornerRadius: 16,
        gripColor: Color.customGreen,
        gripLineWidth: 1.5,
        gripWidth: 60,
        gripHeight: 12,
        dashSize: [20, 5],
        dashColor: .white
    )
}

#Preview("Top Grip") {
    RectangleGripItemView(
        rect: .constant(CGRect(x: 100, y: 200, width: 200, height: 200)),
        initialRect: .constant(.zero),
        horizontalPadding: 8,
        verticalPadding: 8,
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
        horizontalPadding: 0,
        verticalPadding: 0,
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
        horizontalPadding: 8,
        verticalPadding: 8,
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
        horizontalPadding: 8,
        verticalPadding: 8,
        gripPosition: .right,
        gripColor: Color.customGreen,
        gripWidth: 60,
        gripHeight: 3
    )
}
