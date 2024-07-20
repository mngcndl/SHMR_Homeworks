//
//  URLSession.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 12.07.2024.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                guard let data = data, let response = response else {
                    let error = NSError(domain: "URLSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "No responce or no data received"])
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: (data, response))
            }
            if Task.isCancelled {
                print("task has been canceled")
                task.cancel()
            }
            else {
                print("resume task")
                task.resume()
            }
        }
    }
}
