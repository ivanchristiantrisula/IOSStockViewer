//
//  StockDetail.swift
//  StockPrice
//
//  Created by Ivan Christian on 11/05/22.
//

import SwiftUI
import StockCharts

struct StockDetailView: View {
    @ObservedObject var detailViewModel : DetailViewModel

    var body: some View {
        VStack(alignment: .leading){
            List{
                Section("Chart"){
                    ChartView(detailViewModel: detailViewModel)
                }
                Section("Profile"){
                    CompanyProfileView(detailViewModel: detailViewModel)
                }
            }
            
        }.navigationTitle(detailViewModel.ticker)
        
    }
}

// MARK: - CHART

struct ChartView : View {
    @ObservedObject var detailViewModel : DetailViewModel
    @State var selectedRange = "1d"
    let range = ["5m", "30m", "1h", "1d", "1wk"]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(height : 300)
            .foregroundColor(Color(.secondarySystemBackground))
            .overlay(
                VStack(alignment : .leading){
                    switch detailViewModel.chartLoadingState{
                    case .idle :
                        LineChartView(lineChartController: LineChartController(prices: (detailViewModel.quote?.close.compactMap{$0}) ?? [0],dragGesture:true))
                    case .loading :
                        ProgressView()
                    }
                    
                    
                    
                }.padding()
            )
        Picker("Range", selection: $selectedRange){
            ForEach(range, id:\.self){
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedRange) { newValue in
            detailViewModel.range = newValue
            detailViewModel.fetchChart()
        }
    }
}

// MARK: - COMPANY PROFILE

struct CompanyProfileView : View {
    @ObservedObject var detailViewModel : DetailViewModel
    
    
    var body : some View {
        
        Text(detailViewModel.meta?.symbol ?? "")
            .fontWeight(.semibold)
            .font(.title2)
        Text(detailViewModel.stockProfile?.longBusinessSummary ?? "")
            .multilineTextAlignment(.leading)
        HStack{
            Text("Industry")
            Spacer()
            Text(detailViewModel.stockProfile?.industry ?? "")
                .font(.caption)
        }
        HStack{
            Text("Website")
            Spacer()
            Text(detailViewModel.stockProfile?.website ?? "")
                .font(.caption)
        }
        HStack{
            Text("Address")
            Spacer()
            Text(detailViewModel.stockProfile?.address1 ?? "")
                .font(.caption)
        }
        HStack{
            Text("Employee Count")
            Spacer()
            Text(String(detailViewModel.stockProfile?.fullTimeEmployees ?? 0) )
                .font(.caption)
        }
        HStack{
            Text("State")
            Spacer()
            Text(detailViewModel.stockProfile?.state ?? "")
                .font(.caption)
        }
        
    }
}

//struct StockDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        //StockDetailView()
//    }
//}
