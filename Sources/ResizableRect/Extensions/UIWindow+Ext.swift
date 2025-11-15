//
//  UIWindow+Ext.swift
//  ResizableRect
//
//  Created by Ceboolion on 15/11/2025.
//

import SwiftUI

extension UIWindow {
    static var currentWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
