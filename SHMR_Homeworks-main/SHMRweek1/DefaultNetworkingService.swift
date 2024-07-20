//
//  DefaultNetworkingService.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 19.07.2024.
//

import Foundation

class DefaultNetworkingService: NetworkingService {    
    
    private let networkingClient: NetworkingClient
    
    init(networkingClient: NetworkingClient) {
        self.networkingClient = networkingClient
    }
    
    func getTodoItem(revision: Int, at id: String, completion: @escaping (Result<SingleTodoItemQuery, Error>) -> Void) {
        networkingClient.processRequest(request: buildGetTodoItemRequest(id), completion: completion)
    }
    
    func addTodoItem(revision: Int, _ item: TodoItem, completion: @escaping (Result<SingleTodoItemQuery, Error>) -> Void) {
        guard let request = try? buildAddTodoItemRequest(revision: revision, item) else {
            completion(.failure(HTTPError.failedDecoding))
            return
        }
        networkingClient.processRequest(request: request, completion: completion)
    }
    
    func editTodoItem(revision: Int, _ item: TodoItem, completion: @escaping (Result<SingleTodoItemQuery, Error>) -> Void) {
        guard let request = try? buildEditTodoItemRequest(revision: revision, item) else {
            completion(.failure(HTTPError.failedDecoding))
            return
        }
        networkingClient.processRequest(request: request, completion: completion)
    }
    
    func deleteTodoItem(revision: Int, at id: String, completion: @escaping (Result<SingleTodoItemQuery, Error>) -> Void) {
        networkingClient.processRequest(request: buildDeleteTodoItemRequest(revision: revision, id), completion: completion)
    }
    
    func getAllTodoItems(revision: Int, completion: @escaping (Result<TodoItemListQuery, Error>) -> Void) {
        networkingClient.processRequest(request: buildGetAllTodoItemsRequest(), completion: completion)
    }
    
    func updateAllTodoItems(revision: Int, _ items: [TodoItem], completion: @escaping (Result<TodoItemListQuery, Error>) -> Void) {
        guard let request = try? buildUpdateAllTodoItemsRequest(revision: revision, items) else {
            completion(.failure(HTTPError.failedDecoding))
            return
        }
        networkingClient.processRequest(request: request, completion: completion)
    }
    
    private func buildGetAllTodoItemsRequest() -> HTTPRequest {
            HTTPRequest(
                route: "\(Constants.baseurl)/list",
                headers: [Constants.authorizationKey: Constants.authorizationValue])
    }

    private func buildUpdateAllTodoItemsRequest(revision: Int, _ items: [TodoItem]) throws -> HTTPRequest {
        let encoder = JSONEncoder()

        let extendedItems = items.map { ExtendedTodoItem(from: $0) }
        let body = TodoItemListQuery(list: extendedItems)
        let data = try encoder.encode(body)

        return HTTPRequest(
            route: "\(Constants.baseurl)/list",
            headers: [
                Constants.authorizationKey: Constants.authorizationValue,
                Constants.lastRevisionKey: "\(revision)",
                Constants.contentTypeKey: Constants.contentTypeValue
            ],
            body: data,
            httpHandler: .patch
        )
    }


    private func buildAddTodoItemRequest(revision: Int, _ item: TodoItem) throws -> HTTPRequest {
        let extendedItem = ExtendedTodoItem(from: item)
        let requestBody = SingleTodoItemQuery(status: "ok", item: extendedItem)
        let encoder = JSONEncoder()
        let data = try encoder.encode(requestBody)

        return HTTPRequest(
            route: "\(Constants.baseurl)/list",
            headers: [
                Constants.authorizationKey: Constants.authorizationValue,
                Constants.lastRevisionKey: "\(revision)",
                Constants.contentTypeKey: Constants.contentTypeValue
            ],
            body: data,
            httpHandler: .post
        )
    }


    private func buildGetTodoItemRequest(_ id: String) -> HTTPRequest {
        HTTPRequest(
            route: "\(Constants.baseurl)/list/\(id)",
            headers: [Constants.authorizationKey: Constants.authorizationValue]
        )
    }

    private func buildEditTodoItemRequest(revision: Int, _ item: TodoItem) throws -> HTTPRequest {
        let extendedItem = ExtendedTodoItem(from: item)
        let requestBody = SingleTodoItemQuery(status: "ok", item: extendedItem)
        let encoder = JSONEncoder()
        let data = try encoder.encode(requestBody)

        return HTTPRequest(
            route: "\(Constants.baseurl)/list/\(item.id)",
            headers: [
                Constants.authorizationKey: Constants.authorizationValue,
                Constants.lastRevisionKey: "\(revision)",
                Constants.contentTypeKey: Constants.contentTypeValue
            ],
            body: data,
            httpHandler: .put
        )
    }

    private func buildDeleteTodoItemRequest(revision: Int, _ id: String) -> HTTPRequest {
        HTTPRequest(
            route: "\(Constants.baseurl)/list/\(id)",
            headers: [
                Constants.authorizationKey: Constants.authorizationValue,
                Constants.lastRevisionKey: "\(revision)",
                Constants.contentTypeKey: Constants.contentTypeValue
                     ],
            httpHandler: .delete
        )
    }
}

extension DefaultNetworkingService {
    enum Constants {
        static let baseurl: String = "https://beta.mrdekk.ru/todo"
        static let authorizationKey: String = "Authorization"
        static let authorizationValue: String = "Bearer VolatileFlowers"
        static let lastRevisionKey: String = "X-Last-Known-Revision"
        static let contentTypeKey: String = "Content-type"
        static let contentTypeValue: String = "application/json"
    }
}
