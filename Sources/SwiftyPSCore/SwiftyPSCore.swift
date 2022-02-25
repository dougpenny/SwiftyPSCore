//
//    SwiftyPSCore.swift
//
//    Copyright (c) 2018 Cooper Edmunds & Doug Penny – North Raleigh Christian Academy
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol Pagable: Codable {
    associatedtype Model: Codable
    var data: [Model]? { get set }
}

public class SwiftyPSCore {
    let baseURL: URL?
    let clientID: String
    let clientSecret: String
    var token: Token?
    fileprivate var metadata: Metadata?

    public init(_ baseURL: String, clientID: String, clientSecret: String) {
        self.baseURL = URL(string: baseURL)
        self.clientID = clientID
        self.clientSecret = clientSecret
    }

    public func metadata() async throws -> Metadata? {
        if self.metadata != nil {
            return self.metadata
        } else {
            let path = (baseURL?.absoluteString)! + "/ws/v1/metadata"
            return try await self.fetchData(path: path, model: Metadata.self)
        }
    }

    public func fetchData<Model: Pagable>(path: String,
                                          model: Model.Type,
                                          method: String = "GET",
                                          params: [String: Any]? = nil) async throws -> Model? {
        var allData: [Model.Model] = []
        if let resourceCount = try await resourceCount(path: path) {
            let pageSize = 50
            let numberOfPages = (resourceCount + pageSize - 1)/pageSize
            for page in 1...numberOfPages {
                let fullPath = path + "?pagesize=\(pageSize)&page=\(page)"
                var dataObj = try await self.genericFetchData(path: fullPath, model: model)
                let data = dataObj?.data
                allData += data ?? []
                if allData.count == resourceCount {
                    dataObj?.data = allData
                    return dataObj
                }
            }
        }

        return nil
    }

    public func fetchData<Model: Codable>(path: String,
                                          model: Model.Type,
                                          method: String = "GET",
                                          params: [String: Any]? = nil) async throws -> Model? {
        return try await genericFetchData(path: path, model: model, method: method, params: params)
    }

    fileprivate func genericFetchData<Model: Codable>(path: String,
                                                      model: Model.Type,
                                                      method: String = "GET",
                                                      params: [String: Any]? = nil) async throws -> Model? {
        let request = try await clientURLRequest(path: path, method: method, params: params)
        let data = try await dataTask(request: request, method: method)

        return try JSONDecoder().decode(model.self, from: data)
    }

    fileprivate func requestAuthToken() async throws -> Bool {
        let concatCreds = self.clientID + ":" + self.clientSecret
        if let utf8Creds = concatCreds.data(using: .utf8) {
            let base64Creds = utf8Creds.base64EncodedString()
            var request = URLRequest(url: URL(string: "/oauth/access_token/", relativeTo: self.baseURL)!)
            request.setValue("Basic " + base64Creds, forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = "grant_type=client_credentials".data(using: .utf8)!

            let tokenData = try await dataTask(request: request, method: "POST")
            let authToken = try JSONDecoder().decode(Token.self, from: tokenData)
            self.token = authToken
            return true
        } else {
            print("An error occured creating credential string.")
            return false
        }
    }

    fileprivate func dataTask(request: URLRequest, method: String) async throws -> Data {
        var request = request
        request.httpMethod = method

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }

    fileprivate func clientURLRequest(path: String, method: String, params: [String: Any]? = nil) async throws -> URLRequest {
        let requestURL = URL(string: path, relativeTo: self.baseURL)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let params = params {
            var paramString = "{"
            let numOfParams = params.count
            var index = 0
            for (key, value) in params {
                if value is [Any] {
                    paramString += "\"\(key)\":\(value)"
                } else {
                    paramString += "\"\(key)\":\"\(value)\""
                }
                index += 1
                if index != numOfParams {
                    paramString += ","
                }
            }
            paramString += "}"
            request.httpBody = paramString.data(using: .utf8)
        }

        if let token = self.token, !token.isExpired {
            request.setValue(token.tokenType + " " + token.accessToken, forHTTPHeaderField: "Authorization")
        } else {
            if try await self.requestAuthToken() {
                if let token = self.token {
                    request.setValue(token.tokenType + " " + token.accessToken, forHTTPHeaderField: "Authorization")
                }
            }
        }

        return request
    }
}

#if canImport(FoundationNetworking)
// All async APIs aren't available yet in FoundationNetworking; code was pulled from
// this thread: https://forums.swift.org/t/how-to-use-async-await-w-docker/49591
extension URLSession {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return try await withUnsafeThrowingContinuation { continuation in
            let sessionDataTask = self.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                switch (data, response, error) {
                case (nil, nil, let error?): continuation.resume(throwing: error)
                case (let data?, let response?, nil): continuation.resume(returning: (data, response))
                default: fatalError("The data and response should be non-nil if there's no error!")
                }
            }

            sessionDataTask.resume()
        }
    }
}
#endif
