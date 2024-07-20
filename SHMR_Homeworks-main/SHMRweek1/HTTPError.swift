//
//  HTTPError.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 19.07.2024.
//

import Foundation

public enum HTTPError: String, Error {
    case badRequest = "Error: bad request"
    case serverSideError = "Error: server side error"
    case failed = "Error: network request failed"
    case failedToUnwrapResponce = "Error: failed to unwrap responce"
    case failedAuthentication = "Error: authentication failed"
    case notFound = "Error: element was not presented on server"
    case noURL = "Error: no URL provided"
    case noURLComponents = "Error: no URL components provided"
    case failedDecoding = "Error: failed to decode data"
    case wrongRequest = "Error: wrong request, invalid URL or unsynced data"
}
