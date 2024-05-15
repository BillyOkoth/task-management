//
//  View+Extensions.swift
//  task-management
//
//  Created by Billy Okoth on 14/05/2024.
//

import SwiftUI

extension View {
        //custom spacers
    
    @ViewBuilder
    func hSpacing(_ alignment :Alignment) -> some View { 
        self.frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,  alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment :Alignment) -> some View {
        self.frame( maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,  alignment: alignment)
    }
    
    func isSameDate(_ date1:Date, _ date2:Date) -> Bool{
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
