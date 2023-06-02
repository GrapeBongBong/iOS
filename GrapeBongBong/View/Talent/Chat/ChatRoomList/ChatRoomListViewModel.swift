//
//  ChatRoomListViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/15.
//

import Foundation
import Combine

final class ChatRoomListViewModel: ObservableObject {
    @Published var chatRoomList = [ChatRoom]()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var isRequestFailed = false
    var responseMessage = ""
    
    func requestChatRoomList(token: String, postID: Int) {
        let url = URL(string: URLList.baseURL + "/chat/rooms/\(postID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished z")
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { (data, response) in
                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode)
                else {
                    print("오류1")
                    do {
                        let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                        self.responseMessage = json.message
                        print(json.message)
                    } catch(let error) {
                        print("오류2")
                        self.responseMessage = "데이터를 안보내준 것 같아요."
                        print("responseMessage decode: \(error)")
                    }
                    self.isRequestFailed = true
                    return
                }
                
                print("gogogo")
                do {
                    print(String(data: data, encoding: .utf8))
                    
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormater)
                    let json = try decoder.decode([ChatRoom].self, from: data)
                    self.chatRoomList = json
                    print("chatroomListView>>>>> \(json)")
                } catch {
                    self.chatRoomList = []
                    print("erwarfwaefweaf")
                }
                print(self.chatRoomList.count)
            }
            .store(in: &subscriptions)
    }
}
