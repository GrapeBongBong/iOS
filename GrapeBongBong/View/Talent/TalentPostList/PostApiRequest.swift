//
//  PostApiRequest.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/01.
//

import Foundation
import Combine

final class PostApiRequest: ObservableObject {
    @Published var posts = [Post]()
    @Published var isError = false
    @Published var responseMessage = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    func requestList(token: String, giveCategory: SearchCategory, takeCategory: SearchCategory) {
        let url = URL(string: URLList.baseURL + "/exchange/search")!
//        var tempGive: String? = nil
//        var tempTake: String? = nil
//        if giveCategory.rawValue != "전체" {
//            tempGive = giveCategory.rawValue
//        }
//        if takeCategory.rawValue != "전체" {
//            tempTake = giveCategory.rawValue
//        }
        
        let listRequest = TalentListRequest(giveCategory: giveCategory.rawValue, takeCategory: takeCategory.rawValue)
//        let listRequest = TalentListRequest(giveCategory: tempGive, takeCategory: tempTake)
        let json = try! JSONEncoder().encode(listRequest)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        print(String(data: json, encoding: .utf8))
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { (data, response) in
                if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
                    self.isError = true
                }
                
                if self.isError {
                    do {
                        let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                        self.responseMessage = json.message
                    } catch(let error) {
                        self.responseMessage = error.localizedDescription
                        print(error.localizedDescription)
                    }
                } else {
                    print(String(data: data, encoding: .utf8))
                    do {
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(dateFormater)
                        
                        let json = try decoder.decode([Post].self, from: data)
                        self.posts = json.sorted { $0.date > $1.date }
                        print(json.count)
                    } catch(let error) {
                        self.isError = true
                        self.responseMessage = error.localizedDescription
                    }
                }
            }
            .store(in: &subscriptions)
        
    }
    
    func requestList(token: String, urlStr: String) {
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
                
                print(String(data: data, encoding: .utf8))
                
                let apiResponse = try decoder.decode([Post].self, from: data)
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

struct TalentListRequest: Encodable {
//    let giveCategory: SearchCategory
//    let takeCategory: SearchCategory
    let giveCategory: String?
    let takeCategory: String?
    
    enum CodingKeys: String, CodingKey {
        case giveCategory = "giveCate"
        case takeCategory = "takeCate"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.giveCategory, forKey: .giveCategory)
        try container.encodeIfPresent(self.takeCategory, forKey: .takeCategory)
    }
}
