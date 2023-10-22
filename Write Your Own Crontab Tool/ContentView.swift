//
//  ContentView.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-22.
//

import SwiftUI

struct ContentView: View {
    
    let symbolsMeaning: [(symbol: String, meaning: String)] =
    [
        (symbol: "*", meaning: "any value (wildcard)"),
        (symbol:",", meaning: "list separator (i.e.: 0, 15, 30, 45)"),
        (symbol:"-", meaning: "ranger separator (i.e. 1-5)"),
        (symbol:"/", meaning: "step values (i.e. 1/10)")
    ]
    
    @State var cronPattern = "* * * * *"
    @State var cronPatternMeaning = "Every Minute"
    var body: some View {
        VStack {
            Text("Cron Pattern")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            TextField("Enter Cron Pattern", text: $cronPattern)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green)
                }
            
            Text("Cron Pattern Meaning")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            Text(cronPatternMeaning)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green)
                }
            
            List {
                RowView(leftVal: "Symbol", rightVal: "Meaning")
                    .bold()
                    .padding(.bottom, 10)
                ForEach(symbolsMeaning, id:\.symbol) {
                    RowView(leftVal: $0.symbol, rightVal: $0.meaning)
                }
            }
            .listRowSeparatorTint(.green, edges: .all)
            .listStyle(.plain)
        }
        .padding()
    }
    
    
    
}

#Preview {
    ContentView()
}


struct RowView: View {
    let leftVal: String
    let rightVal: String
    var body: some View {
        
        HStack {
            Text(leftVal)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(rightVal)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
