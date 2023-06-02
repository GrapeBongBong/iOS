//
//  CommuPostListViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/21.
//

import Foundation
import Combine

final class CommuPostListViewModel: ObservableObject {
    @Published var posts = [CommuPost]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    func requestData(token: String) {
        let url = URL(string: URLList.baseURL + "/anonymous/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { (data, response) in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                    self.posts = []
                    return
                }
                
                do{
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormater)
                    
                    let apiResponse = try decoder.decode([CommuPost].self, from: data)
                    DispatchQueue.main.async {
                        self.posts = apiResponse.reversed()
                        print(apiResponse.count)
                    }
                } catch(let err) {
                    print(err)
                    print("디코딩과정: \(err.localizedDescription)")
                }
            }
            .store(in: &subscriptions)
        
        
    }
    
    func requestData(token: String, urlStr: String) {
        let url = URL(string: URLList.baseURL + urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error{
                print("에러있음: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                self?.posts = []
                return
            }
            guard let data = data else{
                return
            }
            
            do{
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormater)
                
                let apiResponse = try decoder.decode([CommuPost].self, from: data)
                DispatchQueue.main.async {
                    self?.posts = apiResponse.reversed()
                    print(apiResponse.count)
                }
            } catch(let err) {
                print(err)
                print("디코딩과정: \(err.localizedDescription)")
            }
        }
        task.resume()
    }
}
