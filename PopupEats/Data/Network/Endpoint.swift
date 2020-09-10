//
//  Endpoint.swift
//  PopupEats
//
//  Created by Innocent Magagula on 2020/09/06.
//  Copyright © 2020 Innocent Magagula. All rights reserved.
//

import Foundation

public enum HTTPMethodType: String {
    case get     = "GET"
    case post    = "POST"
}

public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

public class Endpoint<R>: ResponseRequestable {

    public typealias Response = R

    public var path: String
    public var method: HTTPMethodType
    public var queryParametersEncodable: Encodable? = nil
    public var queryParameters: [String: Any]
    public var responseDecoder: ResponseDecoder

    init(path: String,
         method: HTTPMethodType,
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String: Any] = [:],
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.method = method
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.responseDecoder = responseDecoder
    }
}

public protocol Requestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }

    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

public protocol ResponseRequestable: Requestable {
    associatedtype Response

    var responseDecoder: ResponseDecoder { get }
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {

    func url(with config: NetworkConfigurable) throws -> URL {

        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString
        let endpoint = baseURL.appending(path)

        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }

    public func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {

        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    private func encodeBody(bodyParamaters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParamaters)
        case .stringEncodingAscii:
            return bodyParamaters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String : Any]
    }
}
