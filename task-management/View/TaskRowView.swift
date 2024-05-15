//
//  TaskRowView.swift
//  task-management
//
//  Created by Billy Okoth on 14/05/2024.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var task:Task
    var body: some View {
        
        HStack(alignment: .top ,spacing: 15){
            Circle()
                .fill(indicator)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color:.black.opacity(0.1) ,radius: 3)) ,in: .circle)
                .overlay {
                    Circle()
                        .frame(width: 50, height: 50)
                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation(.snappy){
                                task.isCompleted.toggle()
                            }
                        }
                }
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text(task.taskTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                Label(task.creationDate.format("hh.mm.a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.black)
            })
            .padding(15)
            .hSpacing(.leading)
            .background(task.tint ,in: .rect(topLeadingRadius: 15, bottomLeadingRadius:15))
            .strikethrough(task.isCompleted , pattern: .solid, color: .black)
            .offset(y:-8)
                 
            
        }
    }
    
    
    var indicator:Color {
        if task.isCompleted {
            return .green
        }
        return task.creationDate.isSameHour ? .blue :(task.creationDate.isPastHour ? .red : .black)
    }
}

#Preview {
    ContentView()
}
