//
//  SearchStockView.swift
//  StockPrice
//
//  Created by Ivan Christian on 15/05/22.
//

import SwiftUI

struct SearchStockView: View {
    @StateObject var vm : SearchViewModel = SearchViewModel()
    var body: some View {
        NavigationView{
            List{
                ForEach(vm.searchResult, id: \.self){res in
                    NavigationLink(destination: StockDetailView(detailViewModel: DetailViewModel(res.symbol))) {
                        HStack{
                            Text(res.description)
                            Text(res.symbol)
                                .italic()
                                .font(.caption)
                        }
                    }
                }
            }
            .searchable(text: $vm.keyword, prompt : "Company Name or Ticker")
            .onReceive(vm.$keyword.debounce(for: .seconds(1), scheduler: DispatchQueue.main)){
                guard !$0.isEmpty else { return }
                vm.getSearchResult()
            }
            
//            .onChange(of: keyword, perform: { newValue in
//                if(newValue != ""){
//                    vm.getSearchResult(keyword: newValue)
//                }else{
//                    vm.searchResult = []
//                }
//
//            })
            
            .navigationBarTitle("Search")
        }
        
    }
}

struct SearchStockView_Previews: PreviewProvider {
    static var previews: some View {
        SearchStockView()
    }
}
