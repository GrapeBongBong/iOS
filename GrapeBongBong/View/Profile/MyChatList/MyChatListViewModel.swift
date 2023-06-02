//
//  MyChatListViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/26.
//

import Foundation
import Combine

final class MyChatListViewModel: ObservableObject {
    @Published var chatRoomList = [ChatRoom]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    func requestChatRoomList(token: String) {
        let url = URL(string: URLList.baseURL + "/profile/chatRoom")!
        
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
                print(String(data: data, encoding: .utf8))
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    do {
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(dateFormater)
                        
                        let json = try decoder.decode([ChatRoom].self, from: data)
                        self.chatRoomList = json
                    } catch(let error) {
                        print("decode Error: \(error)")
                    }
                } else {
                    print("status error")
                }
            }
            .store(in: &subscriptions)
    }
}
