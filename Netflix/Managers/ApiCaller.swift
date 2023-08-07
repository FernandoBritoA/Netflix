//
//  ApiCaller.swift
//  Netflix
//
//  Created by Fernando Brito on 06/08/23.
//

import Foundation

struct Constants {
    static let API_KEY = "c9ea1080f4be4c799e73132220531fdc"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToGetData
}

class ApiCaller {
    static let shared = ApiCaller()

    // enum Result<Success, Failure> where Failure : Error
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/all/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // This will print the raw JSON response
                //let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let response = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
