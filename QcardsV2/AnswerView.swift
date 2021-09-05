//
//  AnswerView.swift
//  QcardsV2
//
//  Created by Richard Clark on 29/08/2021.
//

import SwiftUI

struct AnswerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isShown: Bool  //there's no init() so the order in which these two vars are declared determines how AnswerView should be called...
    var tappedQ: Query
    @State var grade: Int16
    init(isShown: Binding<Bool>, tappedQ: Query){
        _isShown = isShown
        
        self.tappedQ = tappedQ
        
        grade = tappedQ.grade
    }
    
    
    
    
    var body: some View {
        ZStack {
            Image("blackboard")
                .resizable()
            VStack{
                HStack{
                    //Image("redPatch")
                    gradeImage(grade: grade)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(25)
                        .onTapGesture {
                            print("color patch was tapped")
                            if grade < 3 {
                                grade += 1
                                                } else {
                                                    grade = 1
                                                }

                        }
                    Spacer()
                }
                Spacer()
                Text("OK")
                    .foregroundColor(.blue)
                    .font(.title3)
                    .padding(20)
            }
            
            TwoTextViews(thisQuery: tappedQ)
        }
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.black,lineWidth: 8)
                    .shadow(color: .white, radius: 5)
                    .cornerRadius(5)
        )
        .aspectRatio(1.0, contentMode: .fit)
        .padding(4)
        .frame(minWidth: 100, idealWidth: 300, maxWidth: 500, minHeight: 100, idealHeight: 300, maxHeight: 500, alignment: .center)
        .onTapGesture {
            self.isShown = false
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { _ in
                    self.isShown = false
                }
        )
        //MARK:- onDisappear
        .onDisappear(){
         print("AnswerView is deciding whether to save before leaving the room")
//            if tappedQ.grade != grade {
//                tappedQ.grade = Int16(grade)
//                print(" change to grade so run a save")
//
//                do {
//                    try viewContext.save()
//                } catch {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    let nsError = error as NSError
//                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                }
//            }
        }
    }
    
}

struct TwoTextViews: View {
    var currentQuery: Query?
    init(thisQuery: Query?){
        self.currentQuery = thisQuery
    }
    var body: some View {
        VStack {
            Spacer()
            Group {
                Text(currentQuery?.answer ?? "Test answer would go here and take up 2 lines  only or maybe 3 would be ok and what about if it went to four? Hmm ti cold be interesting")
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .font(.custom("Noteworthy Bold", size: 25))
                    .padding(.horizontal,15)
                    .padding(.bottom,15)
                Text(currentQuery?.extra ?? "Test extra would go here and take up 2 lines  only or maybe 3 would be ok and what about if it went to four? Hmm ti cold be interesting")
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .font(.custom("Noteworthy Bold", size: 20))
                    .padding(.horizontal,15)
                Spacer()
            }
        }
    }
}

//struct AnswerView_Previews: PreviewProvider {
//    //struct TwoTextViews_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        Group {
//            AnswerView(isShown: .constant(true))
//                //TwoTextViews(thisQuery: nil)
//                .previewDevice("iPad Pro (9.7-inch)")
//            //TwoTextViews(thisQuery: nil)
//            AnswerView(isShown: .constant(true))
//                .previewDevice("iPhone 6s")
//            AnswerView(isShown: .constant(true))
//                //TwoTextViews(thisQuery: nil)
//                .previewDevice("iPhone SE")
//        }
//        
//    }
//}
