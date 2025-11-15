//
//  ResizableRectView.swift
//
//  Created by Ceboolion on 15/11/2025.
//

import SwiftUI

/// A protocol that defines the configurable properties of a resizable rectangle view.
///
/// Conforming types are expected to provide customization for the rectangle's grips, borders, and dash styles.
public protocol ResizableRectViewProtocol: View {
    
    /// The width of the rectangle view. Typically used to constrain the maximum width of the resizable area.
    var rectViewWidth: CGFloat { get set }
    
    /// The color of the grips used to resize the rectangle.
    var gripColor: Color { get set }
    
    /// The line width of the grips and the rectangle's dashed border.
    var gripLineWidth: CGFloat { get set }
    
    /// The width of the grips that appear on the top and bottom sides of the rectangle.
    var gripWidth: CGFloat { get set }
    
    /// The height of the grips that appear on the left and right sides of the rectangle.
    var gripHeight: CGFloat { get set }
    
    /// The dash pattern for the rectangle's border.
    ///
    /// Example: `[20, 5]` will create a pattern of 20 points filled and 5 points empty.
    var dashSize: [CGFloat] { get set }
    
    /// The color of the dashed border.
    var dashColor: Color { get set }
}

public struct ResizableRectView: ResizableRectViewProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    @State private var rect = CGRect(x: 100, y: 200, width: 200, height: 200)
    @State private var initialRect: CGRect = .zero
    
    // MARK: - PUBLIC PROPERTIES
    
    public var rectViewWidth: CGFloat
    public var gripColor: Color
    public var gripLineWidth: CGFloat
    public var gripWidth: CGFloat
    public var gripHeight: CGFloat
    public var dashSize: [CGFloat]
    public var dashColor: Color

    // MARK: - INITIALIZERS
    
    public init(
        rectViewWidth: CGFloat = UIScreen.width,
        gripColor: Color = Color.customGreen,
        gripLineWidth: CGFloat = 1.5,
        gripWidth: CGFloat = 60,
        gripHeight: CGFloat = 8,
        dashSize: [CGFloat] = [20, 5],
        dashColor: Color = .black
    ) {
        self.rectViewWidth = rectViewWidth
        self.gripColor = gripColor
        self.gripLineWidth = gripLineWidth
        self.gripWidth = gripWidth
        self.gripHeight = gripHeight
        self.dashSize = dashSize
        self.dashColor = dashColor
    }
    
    // MARK: - VIEW BODY

    public var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .stroke(dashColor, style: .init(lineWidth: gripLineWidth, dash: dashSize))
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX, y: rect.midY)

            topGrip
            bottomGrip
            leftGrip
            rightGrip
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            rect = CGRect(x: 8, y: 100, width: rectViewWidth - 16, height: 100)
        }
    }
    
    // MARK: - CUSTOM VIEWS
    
    private var topGrip: some View {
        Rectangle()
            .fill(gripColor)
            .clipShape(Capsule())
            .frame(width: gripWidth, height: gripHeight)
            .position(x: rect.midX, y: rect.minY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newMinY = initialRect.minY + value.translation.height
                        let newHeight = initialRect.maxY - newMinY

                        if newHeight > gripWidth + 20 {
                            rect.origin.y = newMinY
                            rect.size.height = newHeight
                        }
                    }
                    .onEnded { _ in initialRect = rect }
            )
            .onAppear { initialRect = rect }
    }
    
    private var bottomGrip: some View {
        Rectangle()
            .fill(gripColor)
            .clipShape(Capsule())
            .frame(width: gripWidth, height: gripHeight)
            .position(x: rect.midX, y: rect.maxY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newMaxY = initialRect.maxY + value.translation.height
                        let newHeight = newMaxY - initialRect.minY

                        if newHeight > gripWidth + 20 {
                            rect.size.height = newHeight
                        }
                    }
                    .onEnded { _ in initialRect = rect }
            )
    }
    
    private var leftGrip: some View {
        Rectangle()
            .fill(gripColor)
            .clipShape(Capsule())
            .frame(width: gripHeight, height: gripWidth)
            .position(x: rect.minX, y: rect.midY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newMinX = initialRect.minX + value.translation.width
                        let newWidth = initialRect.maxX - newMinX

                        if newWidth > gripWidth + 20 {
                            rect.origin.x = newMinX
                            rect.size.width = newWidth
                        }
                    }
                    .onEnded { _ in initialRect = rect }
            )
    }
    
    private var rightGrip: some View {
        Rectangle()
            .fill(gripColor)
            .clipShape(Capsule())
            .frame(width: gripHeight, height: gripWidth)
            .position(x: rect.maxX, y: rect.midY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newMaxX = initialRect.maxX + value.translation.width
                        let newWidth = newMaxX - initialRect.minX

                        if newWidth > gripWidth + 20 {
                            rect.size.width = newWidth
                        }
                    }
                    .onEnded { _ in initialRect = rect }
            )
    }
}

// MARK: - PREVIEW

#Preview {
    ResizableRectView()
}

