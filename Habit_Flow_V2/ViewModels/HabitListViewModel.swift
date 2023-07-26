////
////  HabitListViewModel.swift
////  Habit_Flow_V2
////
////  Created by Marc Bachmann on 06.07.23.
////
//
//import Foundation
//
//class HabitListViewModel: ObservableObject {
//
//    @Published var items: [HabitModel] = [] {
//        didSet {
//            saveItems()
//        }
//    }
//    let itemsKey: String = "items_list"
//
//    init() {
//        getItems()
//    }
//
//    func getItems() {
//        guard
//            let data = (UserDefaults.standard.data(forKey: itemsKey)),
//            let savedItems = try? JSONDecoder().decode([HabitModel].self, from: data)
//        else { return }
//
//        self.items = savedItems
//    }
//
//    func deleteItems(indexSet: IndexSet) {
//        items.remove(atOffsets: indexSet)
//    }
//
//    func saveItems() {
//        if let encodedData = try? JSONEncoder().encode(items) {
//            UserDefaults.standard.set(encodedData, forKey: itemsKey)
//        }
//    }
//}
