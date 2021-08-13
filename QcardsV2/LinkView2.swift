//
//  LinkView2.swift
//  QcardsV2
//
//  Created by Richard Clark on 01/08/2021.
//

import SwiftUI
import CoreData


struct LinkView2: View {
   var topic: Topic?        //seems to work with or without @State
  var queries: [Query]? // = []     //using @State here stops the list updating
    @Environment(\.managedObjectContext) private var viewContext
    
  //  init() {
       // let queries: [Query] = topic?.queryArray
        
 //  }
    var body: some View {
        VStack{
            
        List {
           // if queries != nil {
           // if topic?.queryArray != nil {
         //  ForEach(topic!.queryArray, id: \.id) { query in
                ForEach(queries!, id: \.id) { query in
                //print("\(topic?.query)")
               // Text(topic?.name ?? "")
            
            Text("\(query.queryQuestion ?? "")")
           // Text("\(topic?.query ?? "")")
            }
          //  }
        }
        .navigationTitle(topic?.name ?? "No Topic yet")
        Button("Add Query") {
            print("query added here")
            let newQuery = Query(context: viewContext)
            let randomInt = Int.random(in: 0...10)
            newQuery.queryQuestion = "Question\(randomInt)"
            newQuery.id = UUID()    //maybe the id property is necessary?
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
            Button("print last item") {
               // print(topic?.queryArray ?? "nothing there")
                print("last item is \(String(describing: topic!.queryArray.last))")
                
            }.padding()
            Button("delete last item") {
                viewContext.delete(topic!.queryArray.last!)
                do {
                    try viewContext.save()
                }
                catch {
                    // Handle Error
                }
            }
        .padding()
        }
    }
}

struct LinkView2_Previews: PreviewProvider {
    static var previews: some View {
        LinkView2()
    }
}
