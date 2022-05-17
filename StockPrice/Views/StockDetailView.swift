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
            
            Section("Recent News"){
                RecentNews(detailViewModel: detailViewModel)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(detailViewModel.ticker)
        .onAppear{
            detailViewModel.load(withGraph : detailViewModel.quote == nil ? true : false)
            
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

struct RecentNews : View {
    @ObservedObject var detailViewModel : DetailViewModel
    
    
    var body : some View {
        ForEach(detailViewModel.news){post in
            ZStack{
                NewsCard(post: post)
                    .padding(.bottom)
            }.listRowInsets(EdgeInsets())
        }
        
        
    }
}

struct NewsCard: View {
    var post : News
    
    
    
    var body: some View{
        
        ZStack(alignment: .top){
            VStack{
                Text(post.headline)
                    .font(.headline)
                    .frame(maxWidth : .infinity, alignment: .leading)
                Spacer()
                if((post.image) != nil && (post.image) != "null" ){
                    AsyncImage(url: URL(string : post.image ?? "")){image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }.frame(height: 200, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }
                HStack(alignment: .top){
                    VStack{
                        Text(post.summary ?? "")
                            .font(.subheadline)
                            .frame(maxWidth : .infinity, alignment: .leading)
                            .lineLimit(4)
                    }
                    
                    
                }
                Spacer()
                Text("\(post.datetime) ~ \(post.source)")
                    .font(.caption2)
                    .frame(maxWidth : .infinity, alignment: .leading)
            }
            
        }
        .padding()
        .background(.regularMaterial).cornerRadius(16)
    }
}

func getRelativeTime(_ rawString : String) -> String{
    let RFC3339DateFormatter = DateFormatter()
    RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
    RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    return RFC3339DateFormatter.date(from: rawString)?.timeAgoDisplay() ?? "Unknown"
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}


//struct StockDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        //StockDetailView()
//    }
//}
