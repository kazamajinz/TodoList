//
//  TodoFetch.swift
//  DQWidgetExtension
//
//  Created by 이정환 on 2021/01/06.
//

import UIKit

// TODO: Codable과 Equatable 추가
struct Todo: Codable, Equatable {
    let id: Int
    var isDone: Bool
    var detail: String
    var isToday: Bool
    
    mutating func update(isDone: Bool, detail: String, isToday: Bool) {
        // [x] TODO: update 로직 추가
        self.isDone = isDone
        self.detail = detail
        self.isToday = isToday
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        // [x]TODO: 동등 조건 추가
        return lhs.id == rhs.id
    }
}

class TodoManager {
    
    static let shared = TodoManager()
    
    static var lastId: Int = 0
    
    var todos: [Todo] = []
    
    func createTodo(detail: String, isToday: Bool) -> Todo {
        // [x] TODO: create로직 추가
        let nextId = TodoManager.lastId + 1
        TodoManager.lastId = nextId
        return Todo(id: nextId, isDone: false, detail: detail, isToday: isToday)
    }
    
    func addTodo(_ todo: Todo) {
        // [x] TODO: add로직 추가
        todos.append(todo)
        saveTodo()
       // print("여기add")
    }
    
    func deleteTodo(_ todo: Todo) {
        // [x] TODO: delete 로직 추가
        todos = todos.filter { $0.id != todo.id }
//        if let index = todos.firstIndex(of: todo) {
//            todos.remove(at: index)
//        }
        saveTodo()
       // print("여기delete")
    }
    
    func editTodo(_ todo : Todo) {
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].update(isDone: todo.isDone, detail: todo.detail, isToday: !todo.isToday)
        saveTodo()
        //print("여기edit")
    }
    
    
    func updateTodo(_ todo: Todo) {
        // [x] TODO: updatee 로직 추가
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].update(isDone: todo.isDone, detail: todo.detail, isToday: todo.isToday)
        saveTodo()
            //print("여기update")
    }
    
    func saveTodo() {
        Storage.store(todos, to: .documents, as: "todos.json")
    }
    
    func retrieveTodo() {
        todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
        
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
    }
}

class TodoViewModel {
    
    enum Section: Int, CaseIterable {
        case today
        case upcoming
        
        var title: String {
            let plist = UserDefaults.standard
            switch self {
            case .today:
                if plist.bool(forKey: "KorOn") == true {
                    return "오늘의 할일"
                }else {
                    return "Today"
                }
            default:
                if plist.bool(forKey: "KorOn") == true {
                    return "다음에 할일"
                }else {
                    return "Upcoming"
                }
            }
        }
    }
    
    private let manager = TodoManager.shared
    
    var todos: [Todo] {
        return manager.todos
    }
    
    var todayTodos: [Todo] {
        return todos.filter { $0.isToday == true }
    }
    
    var upcompingTodos: [Todo] {
        return todos.filter { $0.isToday == false }
    }
    
    var todayTodosNotDone: [Todo] {
        return todos.filter {$0.isToday == true && $0.isDone == false}
    }
    
    
    var numOfSection: Int {
        return Section.allCases.count
    }
    
    func addTodo(_ todo: Todo) {
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    func editTodo(_ todo: Todo) {
        manager.editTodo(todo)
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    }
}

