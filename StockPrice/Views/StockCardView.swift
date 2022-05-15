//
//  StockCardView.swift
//  StockPrice
//
//  Created by Ivan Christian on 14/05/22.
//

import SwiftUI
import StockCharts

struct StockCardView: View {
    @State var openDetail = false
    @ObservedObject var vm : HomeViewModel
    
    var body: some View {
        ZStack{
            VStack{
                Text(vm.ticker)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Text("$\(String(Int((vm.quote?.c.compactMap{$0}.last ?? 0).rounded(.awayFromZero))))")
                VStack(alignment : .leading, spacing: 40){
                    
                    LineChartView(lineChartController: LineChartController(prices: (vm.quote?.c ?? [0]), dragGesture:false))
                    
                }.padding()
            }
            .padding()
            .frame(width: 160, height: 240)
            
            if(vm.quote != nil){
                NavigationLink("", isActive: $openDetail) {
                    StockDetailView(detailViewModel: DetailViewModel(vm.ticker, quote: vm.quote!))
                }.hidden()
            }
            
        }
        .background(RoundedRectangle(cornerRadius: 16).fill(.regularMaterial))
        .onTapGesture {
            if(vm.quote != nil){
                openDetail.toggle()
            }
            
        }
        
    }
}

//struct StockCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        StockCardView(ticker : "MSFT")
//    }
//}
