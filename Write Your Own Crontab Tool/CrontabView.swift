//
//  ContentView.swift
//  Write Your Own Crontab Tool
//
//  Created by Aziz Bessrour on 2023-10-22.
//

import SwiftUI

struct CrontabView: View {
    @StateObject var viewModel: CrontabViewModel
    @State var cronPattern = ""
    @State var cronPatternMeaning = "Every Minute"
    var body: some View {
        VStack {
            Image("map")
                .resizable()
                .scaledToFit()
            Text("Cron Pattern")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            TextField("* * * * *", text: $cronPattern)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green)
                }
                .onChange(of: cronPattern) {
                    viewModel.cronPatternDidChange(cronPattern)
                }

            if let error = viewModel.errors.first {
                Text("Invalid Cron Pattern")
                    .fontDesign(.rounded)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.top, 10)
                Text([error?.title, ": ", error?.errorDescription].compactMap({ $0 }).joined())
                    .fontDesign(.rounded)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.red.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
            } else {
                Text("Cron Pattern Meaning")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(cronPatternMeaning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green)
                    }
            }

            List {
                RowView(leftVal: "Symbol", rightVal: "Meaning", firstRow: true)
                    .bold()
                    .padding(.bottom, 10)
                ForEach(viewModel.symbolsMeaning, id:\.symbol) {
                    RowView(leftVal: $0.symbol, rightVal: $0.meaning)
                }
            }
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
    var firstRow: Bool = false
    var body: some View {
        
        HStack {
            Text(leftVal)
                .if(!firstRow) {
                    $0.font(.title2)
                }
            Text(rightVal)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .if(!firstRow) {
                    $0.font(.caption)
                }
        }
    }
}
