//
//  AnswerView.swift
//  QcardsV2
//
//  Created by Richard Clark on 29/08/2021.
//

import SwiftUI

struct AnswerView: View {
    @Binding var isShown: Bool  //there's no init() so the order in which these two vars are declared determines how AnswerView should be called...
    var tappedQ: Query?
    
    var body: some View {
        ZStack {
            Image("blackboard")
                .resizable()
            VStack{
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

struct AnswerView_Previews: PreviewProvider {
    //struct TwoTextViews_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            AnswerView(isShown: .constant(true))
                //TwoTextViews(thisQuery: nil)
                .previewDevice("iPad Pro (9.7-inch)")
            //TwoTextViews(thisQuery: nil)
            AnswerView(isShown: .constant(true))
                .previewDevice("iPhone 6s")
            AnswerView(isShown: .constant(true))
                //TwoTextViews(thisQuery: nil)
                .previewDevice("iPhone SE")
        }
        
    }
}

