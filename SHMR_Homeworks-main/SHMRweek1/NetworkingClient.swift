//
//  NetworkingClient.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 19.07.2024.
//

import Foundation

protocol NetworkingClient {
    @discardableResult
    func processRequest<T: Decodable>(
        request: HTTPRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Cancellable?
}

protocol Cancellable {
    func cancel()
}
