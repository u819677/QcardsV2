//
//  LinkView2.swift
//  QcardsV2
//
//  Created by Richard Clark on 01/08/2021.
//

import SwiftUI

struct LinkView2: View {
    var topic: Topic?
    var queries: [Query]? // = []
        
    
  //  init() {
      //  let queries: [Query] = topic?.query
        
 //  }
    var body: some View {
        List {
            if queries != nil {
            ForEach(queries!) { query in
                //print("\(topic?.query)")
               // Text(topic?.name ?? "")
            
            Text("\(query.question ?? "")")
           // Text("\(topic?.query ?? "")")
            }
            }
        }
        .navigationTitle(topic?.name ?? "No Topic yet")
    }
}

struct LinkView2_Previews: PreviewProvider {
    static var previews: some View {
        LinkView2()
    }
}
