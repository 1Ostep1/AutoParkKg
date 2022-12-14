//
//  NetworkConstants.swift
//  AutoParkKg
//
//  Created by Iusupov Ramazan on 14/12/22.
//

import Foundation
import Combine
import SwiftUI

enum NetworkEnvironment: String {
    case openWeather = "https://api.openweathermap.org/data/2.5"
}

protocol NetworkViewModel: ObservableObject {
    associatedtype NetworkResource: Decodable

    var objectWillChange: ObservableObjectPublisher { get }
    var resource: Resource<NetworkResource> { get set }
    var network: Network { get set }
    var route: NetworkRoute { get }
    var bag: Set<AnyCancellable> { get set }

    func onAppear()
}

extension NetworkViewModel {
    func fetch(route: NetworkRoute) {
        (network.fetch(route: route) as AnyPublisher<NetworkResource, Error>)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.resource = .error(error)
                    self.objectWillChange.send()
                default:
                    break
                }
            }, receiveValue: { decodable in
                self.resource = .success(decodable)
                self.objectWillChange.send()
            })
            .store(in: &bag)
    }

    func onAppear() {
        fetch(route: route)
    }
}

// MARK: - Exmaple of network usage
struct OpenWeatherNetwork: Network {
    var decoder: JSONDecoder = JSONDecoder()
    var environment: NetworkEnvironment = .openWeather
}

enum OpenWeatherRoute {
    case weather
}

extension OpenWeatherRoute: NetworkRoute {
    var path: String {
        switch self {
        case .weather:
            return "/weather?q={City}&units=metric&APPID={APPID}"
        }
    }

    var method: NetworkMethod {
        switch self {
        case .weather:
            return .get
        }
    }
}

//class WeatherViewModel: NetworkViewModel, ObservableObject {
//    typealias NetworkResource = Weather
//
//    var resource: Resource<NetworkResource> = .loading
//    var network: Network
//    var route: NetworkRoute = OpenWeatherRoute.weather
//    var bag: Set<AnyCancellable> = Set<AnyCancellable>()
//
//    init(with network: Network) {
//        self.network = network
//    }
//}
//
//struct WeatherContainerView: View {
//
//    @EnvironmentObject var viewModel: WeatherViewModel
//
//    var body: some View {
//
//        VStack {
//            viewModel.resource.isLoading() {
//                Group  {
//                    Spacer()
//                    LoadingView()
//                    Spacer()
//                }
//            }
//
//            viewModel.resource.hasError() {
//                ErrorView(error: $0)
//            }
//
//            viewModel.resource.hasResource() { weather in
//                Group {
//                    Spacer()
//                    WeatherStatusView(weather: weather)
//                    Spacer(minLength: 8)
//                    WeatherView(weather: weather)
//                }
//            }
//
//        }
//        .onAppear(perform: viewModel.onAppear)
//    }
//}
