//
//  Home.swift
//  task-management
//
//  Created by Billy Okoth on 14/05/2024.
//

import SwiftUI

struct Home: View {
    
    //task manager properties
    @State private var currentDate:Date = .init()
    @State private var weekSlider:[[Date.WeekDay]] = []
    @State private var currentWeekIndex:Int = 1
    @State private var createWeek:Bool = false
    @State private var tasks:[Task] = sampleTasks.sorted(by: {$1.creationDate > $0.creationDate})
    @State private var createNewTask:Bool = false
    
    ///animation namespace
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()
            ScrollView(.vertical){
                VStack {
                    //task view
                    TasksView()
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        })
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height:55)
                    .background(.blue.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)) ,in: .circle)
            })
            .padding(15)
        })
        .onAppear(perform: {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        })
        .sheet(isPresented: $createNewTask, content: {
             NewTaskView()
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.white)
        })
    }
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6, content: {
            HStack(spacing: 5, content: {
                Text(currentDate.format("MMMM")).foregroundStyle(.blue)
                Text(currentDate.format("YYYY")).foregroundStyle(.gray)
            }).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                 .font(.callout).fontWeight(.semibold).textScale(.secondary).foregroundStyle(.gray)
            
            //tab view
            TabView(selection: $currentWeekIndex){
                ForEach(weekSlider.indices ,id: \.self){ index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal ,15)
                        .tag(index)
                }
            }
            .padding(.horizontal ,-20)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
             
                    
            
        })
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing, content: {
            Button(action: {}, label: {
                Image(.pic).resizable().aspectRatio(contentMode: .fill).frame(width: 45, height:45).clipShape(.circle)
            })
        })
        .padding(15)
        .background(.white)
        .onChange(of: currentWeekIndex, initial: false) { oldValue , newValue in
            //creating when it reaches first /laast page
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    func WeekView(_ week: [Date.WeekDay])-> some View{
        HStack(spacing:0){
            ForEach(week) { day in
                VStack(spacing:8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle().fill(.red).matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            //indicator to show the current date
                            if day.date.isToday  {
                                Circle().fill(.red).frame(width:5, height:5).vSpacing(.bottom).offset(y:12 )
                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)) ,in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy){
                        currentDate = day.date
                        
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self){ value in
                        //when the offset reaches 15 and if the createweek is toggled
                        //then generate the next set of week
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                        
                    }
            }
        }
    }
    func TasksView() -> some View {
        VStack(alignment: .leading, spacing: 35){
            ForEach($tasks) { $task in 
                TaskRowView(task: $task)
                    .background(alignment:.leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 9, y: 0)
                                .padding(.bottom ,-35)
                        }
                            
                    }
            }
        }
        .padding([.vertical ,.leading] ,15)
        .padding(.top ,15)
    }
    func paginateWeek(){
        //safe check
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date ,currentWeekIndex == 0 {
                //inserting new week at 0th index and removing the last array
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            if let lastDate = weekSlider[currentWeekIndex].last?.date ,currentWeekIndex == (weekSlider.count - 1) {
                ///appending new week @ last index and removing the first array item
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
        print(weekSlider.count)
    }
}

#Preview {
    Home()
}
