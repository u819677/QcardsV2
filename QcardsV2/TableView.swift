//
//  TableView.swift
//  Qcards
//
//  Created by Richard Clark on 19/07/2021.
//

import Foundation
import SwiftUI
import CoreData


//MARK: TableView
struct TableView<Data, Content, Background>: UIViewRepresentable
where Data: RandomAccessCollection,  Content: View, Data.Index == Int, Background: View
{
    typealias SelectAction = (Data.Element) -> Void
    typealias DeleteAction = (Data.Index) -> Void
    typealias MoreAction = (Data.Element) -> Void
    
    @Binding var data: Data
    let background: Background
    private var content: (Data.Element) -> Content
    private var onSelect: SelectAction
    private var onDelete: DeleteAction
    private var onMore: MoreAction
    
    var allowRefresh: Bool = true
    
    init(
        _ data: Binding<Data>,
        background: Background,
        @ViewBuilder content: @escaping (Data.Element) -> Content,
        onSelect: @escaping SelectAction = { _ in },
        onDelete: @escaping DeleteAction = { _ in },
        onMore: @escaping MoreAction = { _ in }
    ) {
        _data = data
        self.content = content
        self.background = background
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.onMore = onMore
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    //MARK:- updateUIView
    func updateUIView(_ uiView: UITableView, context: Context) {
        if allowRefresh {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            uiView.reloadData()
            print("reloadData()")
            print("allowRefresh is \(allowRefresh)")
        }
        }
    }
    //MARK:- makeUIView
    func makeUIView(context: Context) ->  UITableView {
        let tableView = UITableView()
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.register(HostingCell<Content>.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundView = UIHostingController(rootView: self.background).view
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        return tableView
    }
    
    func onSelect(perform action: @escaping SelectAction) -> Self {
        .init($data, background: background, content: content, onSelect: action, onDelete: onDelete, onMore: onMore)
    }
    func onDelete(perform action: @escaping DeleteAction) -> Self {
        .init($data, background: background, content: content, onSelect: onSelect, onDelete: action, onMore: onMore)
    }
    func onMore(perform action: @escaping MoreAction) -> Self {
        .init($data, background: background, content: content, onSelect: onSelect, onDelete: onDelete, onMore: action)
    }
    
    //MARK:- Coordinator
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        var parent: TableView
        init(_ parent: TableView) {
            self.parent = parent
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            parent.data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HostingCell<Content> else {
                return  UITableViewCell()
            }
            let data = parent.data[indexPath.row]
            let view = parent.content(data)
            tableViewCell.setup(with: view)
           
            return tableViewCell
        }
        
        //MARK:- Delegate functions
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("onSelect called from delegate function")
            self.parent.onSelect(parent.data[indexPath.row])
        }
        func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
            false
        }
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let deleteAction = UIContextualAction(  //this action is expanded from original to include the alert
                style: .destructive,
                title: "Delete"
                
            ) { [unowned self] action, sourceView, actionPerformed in   //break point here steps through the delete/edit options display
                /// the alert sheet is displayed here, and the delete operation is paused until alert OK is pressed
               
                let rowData  = parent.data[indexPath.row] //this is attempting to access the topicName details to display in the alert. Failing so far.
                print("rowData is: \(rowData)") ///How to access topicName here? rowData.topicName doesn't compile - "Data.Element has no member..."

                let alert = UIAlertController(title: "Confirm delete this topic and all its queries?",
                               message: "",
                               preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (handler) in
                            }
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (handler) in
                    self.parent.onDelete(indexPath.row) ///these 3 rows have been moved into this alert block so they don't run until alert OK is pressed
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    actionPerformed(true)
                            }
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                let rootViewController = UIApplication.shared.keyWindow?.rootViewController ///deprecated but still works, need to find how to access rootView
                rootViewController?.present(alert, animated: true, completion: nil)
                //self.present(alert, animated: true) // this doesn't work hence need to access rootView, as above.
                parent.allowRefresh = false
            }
 
            let moreAction = UIContextualAction(
                style: .normal,
                title: "Edit"
            ) { [unowned self] action, sourceView, actionPerformed in
                print("onMore called from delegate function")
                self.parent.onMore(parent.data[indexPath.row])
//                func updateUIView(_ uiView: UIView, context: Coordinator)
//                {}
                actionPerformed(true)
            }
            moreAction.backgroundColor = .systemPurple
            let actions = [deleteAction, moreAction]
            let configuration = UISwipeActionsConfiguration(actions: actions)
            configuration.performsFirstActionWithFullSwipe = true
            return configuration 
        }
    }
}
//MARK: Hosting Cell
//private
class HostingCell<Content: View>: UITableViewCell {
    var host: UIHostingController<Content>?
    
    func setup(with view: Content) {
        if host == nil {
            let controller = UIHostingController(rootView: view)
            host = controller
            
            guard let content = controller.view else { return }
            content.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(content)
            content.backgroundColor = .clear
            backgroundColor = .clear
            
            content.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            content.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        } else {
            host?.rootView = view
        }
        setNeedsLayout()
        //setNeedsUpdateConstraints() //no difference
        //invalidateIntrinsicContentSize()    //no difference
        layoutIfNeeded()    //seems to have fixed it!
    }
}
