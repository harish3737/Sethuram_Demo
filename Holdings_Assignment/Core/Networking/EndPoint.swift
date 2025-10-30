//
//  EndPoint.swift
//  Holdings_Assignment
//
//  Created by Sethuram Vijayakumar on 29/10/25.
//

import Foundation

@MainActor
public struct Endpoint<RequestBody: Encodable> {
    public let baseURL: URL
    public let path: String
    public let method: HTTPMethod
    public var headers: [String: String]
    public var query: [URLQueryItem]
    public var body: RequestBody?

    public init(
        baseURL: URL,
        path: String = "",
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        query: [URLQueryItem] = [],
        body: RequestBody? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.query = query
        self.body = body
    }

    public func urlRequest(encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        let baseURL = self.baseURL
        let path = self.path
        let method = self.method
        let headers = self.headers
        let query = self.query
        let body = self.body
        
        var comps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) ?? URLComponents()
        comps.path = comps.path + path
        if !query.isEmpty {
            comps.queryItems = (comps.queryItems ?? []) + query
        }
        guard let url = comps.url else { throw NetworkError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        headers.forEach { req.setValue($0.value, forHTTPHeaderField: $0.key) }
        if let body = body {
            req.httpBody = try encoder.encode(body)
            if req.value(forHTTPHeaderField: "Content-Type") == nil {
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        return req
    }
}
