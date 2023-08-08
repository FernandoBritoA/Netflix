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
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    static let YouTubeAPI_KEY = "AIzaSyBCiF3hH7Q-iYa0_GGsHOrC70dwzc6mIDk"
    static let YouTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search"
}

enum APIError: Error {
    case failedToGetData
}

enum MovieCollectionType: String {
    case upcoming
    case topRated = "top_rated"
    case popular
}

class ApiCaller {
    static let shared = ApiCaller()

    // enum Result<Success, Failure> where Failure : Error
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // This will print the raw JSON response
                // let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let response = try JSONDecoder().decode(FetchTitlesResponse.self, from: data)
                
                completion(.success(response.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getTrendingTVSeries(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // This will print the raw JSON response
                // let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let response = try JSONDecoder().decode(FetchTitlesResponse.self, from: data)
                
                completion(.success(response.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getMoviesCollection(type: MovieCollectionType, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(type.rawValue)?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // This will print the raw JSON response
                // let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let response = try JSONDecoder().decode(FetchTitlesResponse.self, from: data)
                
                completion(.success(response.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&sort_by=popularity.desc&include_adult=false&include_video=false&with_watch_monetization_types=flatrate&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // This will print the raw JSON response
                // let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let response = try JSONDecoder().decode(FetchTitlesResponse.self, from: data)
                
                completion(.success(response.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        // Returns a new string made from the receiver by replacing all characters not in the specified set with percent-encoded characters.
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&include_adult=false&language=en-US&query=\(safeQuery)&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // This will print the raw JSON response
                // let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let response = try JSONDecoder().decode(FetchTitlesResponse.self, from: data)
                
                completion(.success(response.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getMovieTrailer(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        let trailerQuery = "\(query) trailer"
        // Returns a new string made from the receiver by replacing all characters not in the specified set with percent-encoded characters.
        guard let urlQuery = trailerQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.YouTubeBaseURL)?q=\(urlQuery)&key=\(Constants.YouTubeAPI_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                let bestMatch = response.items[0]
                
                completion(.success(bestMatch))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
