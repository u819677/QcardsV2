//
//  LinkView2.swift
//  QcardsV2
//
//  Created by Richard Clark on 01/08/2021.
//

import SwiftUI
import CoreData


struct LinkView2: View {
    var topic: Topic?
    var queries: [Query]? // = []
    @Environment(\.managedObjectContext) private var viewContext
    
  //  init() {
      //  let queries: [Query] = topic?.query
        
 //  }
    var body: some View {
        VStack{
        List {
            if queries != nil {
            ForEach(queries!) { query in
                //print("\(topic?.query)")
               // Text(topic?.name ?? "")
            
            Text("\(query.queryQuestion ?? "")")
           // Text("\(topic?.query ?? "")")
            }
            }
        }
        .navigationTitle(topic?.name ?? "No Topic yet")
        Button("Add Query") {
            print("query added here")
            let newQuery = Query(context: viewContext)
            newQuery.queryQuestion = "Question"
            topic?.addToQuery(newQuery)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }.padding()
        }
    }
}

struct LinkView2_Previews: PreviewProvider {
    static var previews: some View {
        LinkView2()
    }
}
