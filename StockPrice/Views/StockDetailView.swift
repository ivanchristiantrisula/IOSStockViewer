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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        List{
            Text("Last close : $\(Int((detailViewModel.quote?.c.compactMap{$0}.last ?? 0).rounded(.awayFromZero)))")
                .listRowInsets(EdgeInsets())
                .listRowBackground(colorScheme == .dark ? Color.black : Color(.secondarySystemBackground))
                .listRowSeparator(.hidden, edges: .all)
            Section{
                ChartView(detailViewModel: detailViewModel)
                
            }
            .listRowInsets(EdgeInsets())
            .background(Color(.secondarySystemBackground))
            
            Section("Profile"){
                CompanyProfileView(detailViewModel: detailViewModel)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(detailViewModel.ticker)
        .onAppear{
            if(detailViewModel.quote == nil){
                detailViewModel.load()
            }
            
        }.refreshable {
            detailViewModel.load()
        }
        
        
    }
}

// MARK: - CHART

struct ChartView : View {
    @ObservedObject var detailViewModel : DetailViewModel
    @State var selectedRange = "1w"
    @Environment(\.colorScheme) var colorScheme
    let range = ["1h", "1d", "1w","1mo","1y"]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(height : 300)
            .foregroundColor(Color(.secondarySystemBackground))
            .overlay(
                VStack(alignment : .leading, spacing: 40){
                    
                    switch detailViewModel.chartLoadingState{
                    case .idle :
                        LineChartView(lineChartController: LineChartController(prices: (detailViewModel.quote?.c.compactMap{$0}) ?? [0],dragGesture:true))
                    case .loading :
                        HStack{
                            Spacer()
                            ProgressView()
                                .frame(height : 300)
                            Spacer()
                        }
                    case .error :
                        HStack{
                            Spacer()
                            Text("No Data")
                            Spacer()
                        }
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
            .listRowBackground(colorScheme == .dark ? Color.black : Color(.secondarySystemBackground))
            .listRowSeparator(.hidden, edges: .all)
       
    }
}

// MARK: - COMPANY PROFILE

struct CompanyProfileView : View {
    @ObservedObject var detailViewModel : DetailViewModel
    
    
    var body : some View {
        
        Text(detailViewModel.ticker)
            .fontWeight(.semibold)
            .font(.title2)
        Text(detailViewModel.stockProfile?.longBusinessSummary ?? "")
            .multilineTextAlignment(.leading)
        HStack{
            Text("Industry")
            Spacer()
            Text(detailViewModel.stockProfile?.industry ?? "Unknown / API Hit Limit Reached")
                .font(.caption)
        }
        HStack{
            Text("Website")
            Spacer()
            Text(detailViewModel.stockProfile?.website ?? "Unknown / API Hit Limit Reached")
                .font(.caption)
        }
        HStack{
            Text("Address")
            Spacer()
            Text(detailViewModel.stockProfile?.address1 ?? "Unknown / API Hit Limit Reached")
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
            Text(detailViewModel.stockProfile?.state ?? "Unknown / API Hit Limit Reached")
                .font(.caption)
        }
        
    }
}

//struct StockDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        //StockDetailView()
//    }
//}
