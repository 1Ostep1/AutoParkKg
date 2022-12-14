//
//  NetworkService.swift
//  AutoParkKg
//
//  Created by Iusupov Ramazan on 14/12/22.
//

import Foundation
import SwiftUI
import Combine

enum NetworkMethod: String { case get, post, put, patch, delete }

protocol NetworkRoute {
    var path: String { get }
    var method: NetworkMethod { get }
    var headers: [String: String]? { get }
}

extension NetworkRoute {
    var headers: [String : String]? { return nil }

    func create(for enviroment: NetworkEnvironment) -> URLRequest {
        var request = URLRequest(url: URL(string: enviroment.rawValue + path)!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue.uppercased()
        return request
    }
}

enum Resource<T> {
    case loading
    case success(T)
    case error(Error)
}

extension Resource {
    var loading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var error: Error? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }

    var value: T? {
        if case .success(let t) = self {
            return t
        }
        return nil
    }
}

extension Resource {
    /**
    Transform a `Resource<T>` to a `Resource<S>`
    */
    func transform<S>(_ t: @escaping (T) -> S) -> Resource<S> {
        switch self {
        case .loading: return .loading
        case .error(let error): return .error(error)
        case .success(let value): return .success(t(value))
        }
    }

    func isLoading<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Content? { loading ? content() : nil }

    func hasResource<Content: View>(@ViewBuilder content: @escaping (T) -> Content) -> Content? { value != nil ? content(value!) : nil }

    func hasError<Content: View>(@ViewBuilder content: @escaping (Error) -> Content) -> Content? { error != nil ? content(error!) : nil }
}

protocol Network {
    var decoder: JSONDecoder { get set }
    var environment: NetworkEnvironment { get set }
}

extension Network {
    func fetch<T: Decodable>(route: NetworkRoute) -> AnyPublisher<T, Error> {
        let request = route.create(for: environment)
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryCompactMap { result in
                try self.decoder.decode(T.self, from: result.data)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
