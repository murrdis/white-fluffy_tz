//
//  NetworkService.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 14.02.2024.
//

import Foundation
import Alamofire

class NetworkService {
    
    
    func getRandomPhotos(completion: @escaping ([Photo]?) -> Void) {
        let randomURL = "https://api.unsplash.com/photos/random"
        let params: Parameters = [
            "count" : 50
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID FJiN20I1MLldtQ5GXjBFTQ1EHJIzegaA_-pWDzc2aJc"
        ]
        
        AF.request(randomURL, method: .get, parameters: params, headers: headers).responseData { response in
            if let error = response.error {
                print("Error in searchPhotos: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let data = response.data {
                    print(response.response)
                    let responseData = try? JSONDecoder().decode([Photo].self, from: data)
                    DispatchQueue.main.async {
                        print(responseData)
                        completion(responseData)
                    }
                }
            }
        }
    }
    
    func getPhotos(searchText: String, completion: @escaping (SearchResults?) -> Void) {
        let searchURL = "https://api.unsplash.com/search/photos"
        
        let params: Parameters = [
            "query" : searchText,
            "page" : String(1),
            "per_page" : String(50)
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID FJiN20I1MLldtQ5GXjBFTQ1EHJIzegaA_-pWDzc2aJc"
        ]
        
        AF.request(searchURL, method: .get, parameters: params, headers: headers).responseData { response in
            if let error = response.error {
                print("Error in searchPhotos: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let data = response.data {
                    let responseData = try? JSONDecoder().decode(SearchResults.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseData)
                    }
                }
            }
        }
    }
    
    func getPhoto(withID id: String, completion: @escaping (DetailPhoto?) -> Void) {
        let url = "https://api.unsplash.com/photos/\(id)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID FJiN20I1MLldtQ5GXjBFTQ1EHJIzegaA_-pWDzc2aJc"
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            if let error = response.error {
                print("Error in searchPhotos: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let data = response.data {
                    do {
                        let responseData = try JSONDecoder().decode(DetailPhoto.self, from: data)
                        DispatchQueue.main.async {
                            print(responseData)
                            completion(responseData)
                        }
                    } catch {
                        print("Decoding error: \(error)")

                    }
                }
            }
        }
    }
}
