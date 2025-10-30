//
//  NetworkError.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case server(status: Int,  Data?)
    case decoding(Error)
    case notConnected
}

public enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE"
}

public struct VoidBody: Encodable {}
