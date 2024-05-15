//
//  OffSetKey.swift
//  task-management
//
//  Created by Billy Okoth on 14/05/2024.
//

import SwiftUI

struct OffsetKey:PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
    
    
}
