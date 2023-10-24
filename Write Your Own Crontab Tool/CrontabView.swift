//
//  ContentView.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-22.
//

import SwiftUI

struct CrontabView: View {
    @StateObject var viewModel: CrontabViewModel
    @State var cronPattern = "* * * * *"
    @State var cronPatternMeaning = "Every Minute"
    var body: some View {
        VStack {
            Image("map")
                .resizable()
                .scaledToFit()
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
            Button {
                viewModel.cronPatternDidChange(cronPattern)
            } label: {
                Text("Validate")
                    .foregroundStyle(Color.white.gradient)
                    .font(.title3)
                    .background(Color.green)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            if let error = viewModel.error {
                Text("Title \(error.title) || Description \(error.errorDescription)")
                    .fontDesign(.rounded)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            
            Text("Cron Pattern Meaning")
                .frame(maxWidth: .infinity, alignment: .leading)
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
                ForEach(viewModel.symbolsMeaning, id:\.symbol) {
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
    CrontabView(viewModel: CrontabViewModel())
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
