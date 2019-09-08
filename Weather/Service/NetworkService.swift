//
//  ParseJSON.swift
//  jsonparse
//
//  Created by yauheni prakapenka on 30/08/2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit

class NetworkService {
    
    func getWeather(city: String, completion: @escaping (_ weather: Weather?) -> Void) {
        let urlString = "http://api.apixu.com/v1/current.json?key=293cadfcdcb0484faff155128192608&q=\(city)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                print(weather)
                DispatchQueue.main.async {
                    completion(weather)
                }
            } catch let error { print(error) }
        }.resume()
    }
    
    
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParaments(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        print(url)
    }
    
    private func prepareParaments(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID a6f6b570ac1ba98a65aedbe3406accc565fab9b623e053b3e25c401d2e579e6f"
        return headers
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error)  in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
}
