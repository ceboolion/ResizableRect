//
//  ResizableRectView.swift
//
//  Created by Ceboolion on 15/11/2025.
//

import SwiftUI

/// A protocol that defines the configurable properties of a resizable rectangle view.
///
/// Conforming types can customize the rectangle's size, grips, corner radius,
/// and dashed border appearance.
public protocol ResizableRectViewProtocol: View {
    
    /// The width of the rectangle view. Used to define the available horizontal space.
    var rectViewWidth: CGFloat { get set }
    
    /// The height of the rectangle view. Used to define the available vertical space.
    var rectViewHeight: CGFloat { get set }
    
    /// The corner radius of the rectangle. If `nil`, the rectangle has sharp corners.
    var cornerRadius: CGFloat? { get set }
    
    /// The color of the grips used to resize the rectangle.
    var gripColor: Color { get set }
    
    /// The line width used for grips and the dashed border.
    var gripLineWidth: CGFloat { get set }
    
    /// The width of the grips on the top and bottom edges.
    var gripWidth: CGFloat { get set }
    
    /// The height of the grips on the left and right edges.
    var gripHeight: CGFloat { get set }
    
    /// The dash pattern of the rectangle's border.
    ///
    /// Example: `[20, 5]` produces a pattern of 20 points drawn and 5 points skipped.
    var dashSize: [CGFloat] { get set }
    
    /// The color of the dashed border. If `nil`, the border may be hidden.
    var dashColor: Color? { get set }
}

public struct ResizableRectView: ResizableRectViewProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var rect = CGRect(x: 100, y: 200, width: 200, height: 200)
    @State private var initialRect: CGRect = .zero
    
    // MARK: - PUBLIC PROPERTIES
    
    public var rectViewWidth: CGFloat
    public var rectViewHeight: CGFloat
    public var cornerRadius: CGFloat?
    public var gripColor: Color
    public var gripLineWidth: CGFloat
    public var gripWidth: CGFloat
    public var gripHeight: CGFloat
    public var dashSize: [CGFloat]
    public var dashColor: Color?

    // MARK: - INITIALIZERS
    
    public init(
        rectViewWidth: CGFloat = UIScreen.width,
        rectViewHeight: CGFloat = 200,
        cornerRadius: CGFloat? = nil,
        gripColor: Color = Color.customGreen,
        gripLineWidth: CGFloat = 1.5,
        gripWidth: CGFloat = 60,
        gripHeight: CGFloat = 8,
        dashSize: [CGFloat] = [20, 5],
        dashColor: Color? = nil
    ) {
        self.rectViewWidth = rectViewWidth
        self.rectViewHeight = rectViewHeight
        self.cornerRadius = cornerRadius
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
            RoundedRectangle(cornerRadius: cornerRadius ?? 0)
                .fill(.clear)
                .stroke(setDashColor(), style: .init(lineWidth: gripLineWidth, dash: dashSize))
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX, y: rect.midY)
            
            RectangleGripsView(
                rect: $rect,
                initialRect: $initialRect,
                initialSize: CGSize(width: rectViewWidth, height: rectViewHeight),
                gripColor: gripColor,
                gripWidth: gripWidth,
                gripHeight: gripHeight
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            rect = CGRect(x: 8, y: 8, width: rectViewWidth - 16, height: rectViewHeight - 16)
        }
    }

    // MARK: - PRIVATE METHODS

    private func setDashColor() -> Color {
        dashColor ?? (colorScheme == .dark ? .white : .black)
    }
}

// MARK: - PREVIEW

#Preview {
    ResizableRectView(rectViewWidth: UIScreen.width, rectViewHeight: 600, cornerRadius: 16)
}

