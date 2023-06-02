//
//  HomeViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/29.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var talentPosts = [Post]()
    @Published var commuPosts = [CommuPost]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    func requestTalentPosts(token: String) {
        let url = URL(string: URLList.baseURL + "/exchange/popular")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { (data, response) in
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    do {
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(dateFormater)
                        
                        let json = try decoder.decode([Post].self, from: data)
                        self.talentPosts = json
                    } catch(let error) {
                        print(error)
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    func requestCommuPosts(token: String) {
        let url = URL(string: URLList.baseURL + "/anonymous/popular")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { (data, response) in
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    do {
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(dateFormater)
                        
                        let json = try decoder.decode([CommuPost].self, from: data)
                        self.commuPosts = json
                    } catch(let error) {
                        print(error)
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
