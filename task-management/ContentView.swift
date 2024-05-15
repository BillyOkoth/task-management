//
//  ContentView.swift
//  task-management
//
//  Created by Billy Okoth on 14/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
//            .background(.BG)
            .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
