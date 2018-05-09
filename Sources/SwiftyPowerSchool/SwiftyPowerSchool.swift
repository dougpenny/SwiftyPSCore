//
//    SwiftyPowerSchool.swift
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

protocol Pagable: Codable {
    associatedtype Model: Codable
    var data: [Model]? { get set }
}

public class SwiftyPowerSchool {
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

    func metadata(completion: @escaping (Metadata?, Error?) -> Void) {
        if self.metadata != nil {
            completion(self.metadata, nil)
        } else {
            let path = (baseURL?.absoluteString)! + "/ws/v1/metadata"
            self.fetchData(path: path, model: Metadata.self) { metadataObject, error in
                if let metadataObject = metadataObject {
                    self.metadata = metadataObject
                    completion(self.metadata, error)
                } else {
                    completion(nil, error)
                }
            }
        }
    }

    func fetchData<Model: Pagable>(path: String,
                                   model: Model.Type,
                                   method: String = "GET",
                                   params: [String: Any]? = nil,
                                   completion: @escaping (Model?, Error?) -> Void) {
        var allData: [Model.Model] = []
        resourceCount(path: path) { resourceCount, error in
            if let resourceCount = resourceCount {
                let pageSize = 50
                let numberOfPages = (resourceCount + pageSize - 1)/pageSize
                for page in 1...numberOfPages {
                    let fullPath = path + "?pagesize=\(pageSize)&page=\(page)"
                    self.genericFetchData(path: fullPath, model: model) { dataObj, error in
                        let data = dataObj?.data
                        var dataObj = dataObj
                        allData += data ?? []
                        if allData.count == resourceCount {
                            dataObj?.data = allData
                            completion(dataObj, nil)
                        }
                    }
                }
            } else {
                completion(nil, error)
            }
        }
    }

    func fetchData<Model: Codable>(path: String,
                                   model: Model.Type,
                                   method: String = "GET",
                                   params: [String: Any]? = nil,
                                   completion: @escaping (Model?, Error?) -> Void) {
        genericFetchData(path: path, model: model, method: method, params: params, completion: completion)
    }

    fileprivate func genericFetchData<Model: Codable>(path: String,
                                                      model: Model.Type,
                                                      method: String = "GET",
                                                      params: [String: Any]? = nil,
                                                      completion: @escaping (Model?, Error?) -> Void) {
        clientURLRequest(path: path, method: method, params: params) { request, error in
            if let request = request {
                self.dataTask(request: request, method: method) { data, error in
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let object = try decoder.decode(model.self, from: data)
                            completion(object, nil)
                        } catch let parseError {
                            completion(nil, parseError)
                        }
                    } else {
                        completion(nil, error)
                    }
                }
            } else {
                completion(nil, error)
            }
        }
    }

    private func requestAuthToken(completion: @escaping (Bool, Error?) -> Void) {
        let concatCreds = self.clientID + ":" + self.clientSecret
        guard let utf8Creds = concatCreds.data(using: .utf8) else {
            completion(false, nil)
            return
        }
        let base64Creds = utf8Creds.base64EncodedString()
        var request = URLRequest(url: URL(string: "/oauth/access_token/", relativeTo: self.baseURL)!)
        request.setValue("Basic " + base64Creds, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)!
        dataTask(request: request, method: "POST") { tokenData, error in
            if let tokenData = tokenData {
                let decoder = JSONDecoder()
                do {
                    let authToken = try decoder.decode(Token.self, from: tokenData)
                    self.token = authToken
                    completion(true, nil)
                } catch let parseError {
                    completion(false, parseError)
                }
            } else {
                completion(false, error)
            }
        }
    }

    internal func dataTask(request: URLRequest,
                           method: String,
                           completion: @escaping (Data?, Error?) -> Void) {
        var request = request
        request.httpMethod = method
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, error)
                return
            }
            completion(data, error)
        }
        task.resume()
    }

    internal func clientURLRequest(path: String,
                                   method: String,
                                   params: [String: Any]? = nil,
                                   completion: @escaping (URLRequest?, Error?) -> Void) {
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
            completion(request, nil)
        } else {
            self.requestAuthToken(completion: { success, error in
                if success {
                    if let token = self.token {
                        request.setValue(token.tokenType + " " + token.accessToken, forHTTPHeaderField: "Authorization")
                        completion(request, nil)
                    } else {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error)
                }
            })
        }
    }
}
