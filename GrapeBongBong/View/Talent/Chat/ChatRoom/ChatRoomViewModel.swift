import Foundation
import Combine

final class ChatRoomViewModel: ObservableObject {
    @Published var chatMessages = [ChatMessageResponse]()
    @Published var isAlert = false
    @Published var isMatchSuccess = false
    
    var responseTitle = ""
    var responseMessage = ""
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var subscriptions = Set<AnyCancellable>()
    
    deinit {
        disconnect()
    }
    
    func connect(chatRoomID: Int) {
        guard webSocketTask == nil else {
            return
        }
        
        let url = URL(string: URLList.socketURL + "/ws/chat/\(chatRoomID)")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        //        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.receive(completionHandler: firstOnReceive)
        webSocketTask?.resume()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func firstOnReceive(result: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive)
        
        switch result {
        case .success(let messages):
            onMessageLists(message: messages)
        case .failure(let error):
            print("first on receive error: ", error)
            self.chatMessages = []
        }
    }
    
    func onReceive(result: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive)
        
        switch result {
        case .success(let message):
            onMessage(message: message)
        case .failure(let error):
            print("receive error: ", error)
        }
    }
    
    func onMessageLists(message: URLSessionWebSocketTask.Message) {
        if case .string(let text) = message {
            guard let data = text.data(using: .utf8),
                  let messageLists = try? JSONDecoder().decode([ChatMessageResponse].self, from: data)
            else {
                print("firstOnReceive: json 안됨.")
                return
            }
            DispatchQueue.main.async {
                self.chatMessages = messageLists
            }
        }
    }
    
    func onMessage(message: URLSessionWebSocketTask.Message) {
        if case .string(let text) = message {
            guard let data = text.data(using: .utf8),
                  let chatMessage = try? JSONDecoder().decode(ChatMessageResponse.self, from: data)
            else {
                print("onMessage: json 안됨.")
                print(text)
                return
            }
            DispatchQueue.main.async {
                self.chatMessages.append(chatMessage)
            }
        }
    }
    
    func send(roomID: Int, senderID: String, text: String) {
        let message = ChatMessage(roomID: roomID, senderID: senderID, message: text)
        guard let json = try? JSONEncoder().encode(message), let jsonString = String(data: json, encoding: .utf8) else {
            return
        }
        
        webSocketTask?.send(.string(jsonString), completionHandler: { error in
            if let error = error {
                print("send error: ", error)
            }
        })
    }
    
    func requestToMatch(token: String, postID: Int) {
        let url = URL(string: URLList.baseURL + "/match/\(postID)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.responseTitle = "교환 실패"
                    self.responseMessage = "통신에 실패 했습니다."
                    print(error)
                }
            } receiveValue: { (data, response) in
                self.isAlert = true
                
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    self.isMatchSuccess = true
                }
                
                do {
                    let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                    self.responseTitle = self.isMatchSuccess ? "교환 성공" : "교환 실패"
                    self.responseMessage = json.message
                } catch (let error) {
                    self.responseTitle = "교환 실패"
                    self.responseMessage = "데이터를 받아오는데 실패했습니다."
                    print(error)
                }
            }
            .store(in: &subscriptions)
    }
}


