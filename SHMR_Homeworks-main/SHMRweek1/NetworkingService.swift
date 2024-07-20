//
//  NetworkingService.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 17.07.2024.
//

import Foundation

protocol NetworkingService {
    func getAllTodoItems(
        revision: Int,
        completion: @escaping (Result<TodoItemListQuery, Error>) -> Void
    )
    
    func updateAllTodoItems(
        revision: Int,
        _ items: [TodoItem],
        completion: @escaping (Result<TodoItemListQuery, Error>) -> Void
    )
    
    func getTodoItem(
        revision: Int,
        at id: String,
        completion: @escaping (Result<SingleTodoItemQuery, Error>) -> Void
    )
    
    func addTodoItem(
        revision: Int,
        _ item: TodoItem,
        completion: @escaping (Result<SingleTodoItemQuery, Error>) -> Void
    )
    
    func editTodoItem(
        revision: Int,
        _ item: TodoItem,
        completion: @escaping (Result<SingleTodoItemQuery, Error>) -> Void
    )
    
    func deleteTodoItem(
        revision: Int,
        at id: String,
        completion: @escaping (Result<SingleTodoItemQuery, Error>) -> Void
    )
}
