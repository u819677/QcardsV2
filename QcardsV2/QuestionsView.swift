//
//  QuestionsView.swift
//  QcardsV2
//
//  Created by Richard Clark on 12/08/2021.
//

import SwiftUI
import CoreData

struct QuestionsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    let persistenceController = PersistenceController.shared
    @StateObject var queryStore: QueryStore
    let topic: Topic?   ///this is the inbound selected topic used to create the queries
    @State var optionalQuery: Query?    ///this is a selected query for editing
    @State var showQueryEntry: Bool = false
    @State var showingAlert = false
    @State var showAnswer: Bool = false
    @State var selectedQuery: Query?
    @State var hidingGrades: Bool = false
    
    init(topic: Topic?) {
        self.topic = topic
        let managedObjectContext = persistenceController.container.viewContext
        let storage = QueryStore(managedObjectContext: managedObjectContext, topic: topic)
        self._queryStore = StateObject(wrappedValue: storage)   ///and bingo, the queryStore of all relevant queries is ready
    }
    
    var body: some View {
        ZStack { ///this is used to allow the AnswerView to animate up over QuestionsView.
            TableView($queryStore.queries, background: background) {query in
                QuestionView(query: query, hidingGrades: $hidingGrades)
                    .blur(radius: showAnswer ? 3 : 0)
            }
            .onSelect {query in
                print("\(query) was selected")
                selectedQuery = query
                showAnswer = true
            }
            .onDelete { index in    // no topic variable  is required, because .onDelete uses the index
                showingAlert = true ///this is the warning to ask user to confirm delete. Control flow gets rather complex here. See TableView delegate functions.
                let queryToDelete = queryStore.queries[index]
                queryStore.queries.remove(at: index)
                viewContext.delete(queryToDelete)
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            .onMore { query in
                print("query to edit is \(query)" )
                optionalQuery = query
            }
            .sheet(item: $optionalQuery) { item in    ///edit View animation triggered when optionalQuery is not nil, ie: in edit mode
                withAnimation {
                    QueryEntryView(optionalQuery: item)
                }
            }
            //MARK:- Navigation Bar
            .navigationTitle(self.topic?.topicName ?? "nil" )
            .navigationBarItems(trailing:
                                    HStack{
                                        Button(action: {
                                            hidingGrades.toggle()
                                            print("grade button was tapped")
                                        }
                                        )
                                        {Text(Image(systemName: "list.bullet"))
                                            .padding()
                                            .imageScale(.large)
                                            .disabled(hidingGrades ? true : false) ///only disabling the Image, not the button!
                                        }
                                        
                                        Button(action: {
                                            withAnimation {
                                                showQueryEntry = true
                                            }
                                        })
                                        {Text(Image(systemName: "plus"))///Button expects a label (?) so need to use Text
                                            .padding()
                                            .imageScale(.large)
                                        }
                                    }
                                
            )
            .sheet(isPresented: $showQueryEntry){
                QueryEntryView(selectedTopic: topic!)   ///there will always be an inbound topic so force-unwrap should be safe!
            }
            if showAnswer { 
                AnswerView(isShown: $showAnswer, tappedQ: selectedQuery!).zIndex(1)//needs this to subsequently animate away properly but set to 1 not zero! otherwise whole raft of issues with navigation bar size etc...
                    .transition(.move(edge: .bottom))   //this view is temporarily on top of the ZStack
                    .animation(.easeOut)
            }
        }//end ZStack
    }//end of View
    
    var background: some View {
        Image("blackboard")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
}

//MARK:- QuestionView
struct QuestionView: View {    //this is the view used for each line of the Questions table
    @ObservedObject var query: Query       //not sure why not use @Binding here but it works!
    @Binding var hidingGrades: Bool
    
    var body: some View {
        ZStack{
            if !hidingGrades {
                HStack{
                  //  gradeImage(grade: query.grade)
                    Circle()
                        .fill(gradeColor(grade: query.grade))   ///just one missing ) and the compiler is freaked out!
                        //.resizable()
                        .frame(width: 10, height: 10, alignment: .center)
                        .padding(.leading,2)
                    Spacer()    ///pushes the color patch over to the left edge
                }
            }
            HStack{
            Text(query.question)
                .font(.custom("Noteworthy Bold", size: 26 )) //may need to use system font size eg: font(.largeTitle)
                .foregroundColor(.white) //may need to use Color.primary to enable accessibility here.
                .padding(.leading, 10)  ///this is to try to avoid color patch overlapping with text 
            }
        }//end of ZStack
    }
}
//MARK:- gradeImage
func gradeImage(grade: Int16) -> Image {
    switch grade {
    case 1:
        return Image("redPatch")
    case 2:
        return Image("orangePatch")
    case 3:
        return Image("greenPatch")
    default:
        return Image(systemName: "hammer")
    }
}
func gradeColor(grade: Int16) -> Color {
    switch grade {
    case 1:
        return .red
    case 2:
        return .orange
    case 3:
        return .green
    default:
        return .black
    }
}
//struct QuestionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionsView()
//    }
//}
