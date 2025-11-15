//
//  UIScreen+Ext.swift
//  ResizableRect
//
//  Created by Ceboolion on 15/11/2025.
//

import SwiftUI

extension UIScreen {
    public static var width: CGFloat {
        UIWindow.currentWindow?.bounds.width ?? UIScreen.main.bounds.width
    }
}
