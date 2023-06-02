//
//  ModifyCommuPostViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/22.
//

import Foundation
import Combine

final class ModifyCommuPostViewModel: ObservableObject {
    @Published var isModifySuccess = false
    @Published var isModifyFailed = false
    
    private var subscriptions = Set<AnyCancellable>()
    var responseMessage = ""
    
    func sendRequest(with post: CommuPost, token: String) {
        guard let json = try? JSONEncoder().encode(post) else { return }
        
        let url = URL(string: URLList.baseURL + "/anonymous/post/\(post.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.isModifyFailed = true
                    self.responseMessage = "통신 중 오류가 발생했어요."
                    return
                case .finished:
                    break
                }
            } receiveValue: { (data, response) in
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    self.isModifySuccess = true
                } else {
                    self.isModifyFailed = true
                }
                
                do {
                    let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                    self.responseMessage = json.message
                } catch {
                    self.responseMessage = response.description
                }
            }
            .store(in: &subscriptions)
    }
}
