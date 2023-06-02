//
//  DetailCommuPostViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/21.
//

import Foundation
import Combine

final class DetailCommuPostViewModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var isRequestSuccess = false
    @Published var isRequestFailed = false
    @Published var liked = false
    @Published var likeCount = 0
    
    var responseTitle = ""
    var responseMessage = ""
    private var subscriptions = Set<AnyCancellable>()
    
    func requestDeletePost(token: String, postID: Int) {
        let url = URL(string: URLList.baseURL + "/anonymous/delete/\(postID)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.isRequestFailed = true
                    self.responseTitle = "삭제 실패"
                    self.responseMessage = "서버와 통신을 실패했습니다."
                }
            } receiveValue: { (data, response) in
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    self.isRequestSuccess = true
                } else {
                    self.isRequestFailed = true
                }
                
                print(String(data: data, encoding: .utf8))
                
                do {
                    let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                    self.responseMessage = json.message
                } catch {
                    self.responseMessage = "서버에서 메세지를 안보내준거 같아요."
                }
            }
            .store(in: &subscriptions)
    }
    
    func requestComments(token: String, postID: Int) {
        let url = URL(string: URLList.baseURL + "/\(postID)/comments")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.isRequestFailed = true
                    self.responseTitle = "댓글 조회 실패"
                    self.responseMessage = "서버와 통신이 실패한 것 같아요."
                case .finished:
                    break
                }
            } receiveValue: { (data, response) in
                if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
                    self.isRequestFailed = true
                    
                    do {
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(dateFormater)
                        
                        let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                        self.responseMessage = json.message
                        print(self.responseMessage)
                    } catch {
                        self.responseMessage = "서버에서 메세지를 안보내준거 같아요."
                    }
                }
                
                print(String(data: data, encoding: .utf8))
                
                do {
                    let json = try JSONDecoder().decode(TempComments.self, from: data)
                    self.comments = json.comments
                } catch {
                    self.responseMessage = "서버에서 메세지를 안보내준거 같아요."
                    print("변환실패")
                    print(error)
                }
            }
            .store(in: &subscriptions)
    }
    
    func requestAddComment(token: String, postID: Int, comment: String) {
        let url = URL(string: URLList.baseURL + "/\(postID)/comment")!
        let json = try? JSONEncoder().encode(RequestComment(content: comment))
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.isRequestFailed = true
                    self.responseMessage = "서버와 통신이 실패한 것 같아요."
                case .finished:
                    break
                }
            } receiveValue: { (data, response) in
                do {
                    let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                    self.responseMessage = json.message
                    print(self.responseMessage)
                } catch {
                    self.responseMessage = "서버에서 메세지를 안보내준거 같아요."
                }
                
                if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
                    self.isRequestFailed = true
                } else {
                    self.requestComments(token: token, postID: postID)
                }
            }
            .store(in: &subscriptions)
    }
    
    func requestDeleteComment(token: String, postID: Int, commentID: Int) {
        let url = URL(string: URLList.baseURL + "/\(postID)/comment/delete/\(commentID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(_):
                    self.isRequestFailed = true
                    self.responseMessage = "서버와 통신이 실패한 것 같아요."
                }
            } receiveValue: { (data, response) in
                do {
                    let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                    self.responseMessage = json.message
                } catch {
                    self.responseMessage = "서버에서 메세지를 안보내준거 같아요."
                    self.isRequestFailed = true
                }
                
                if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
                    self.isRequestFailed = true
                } else {
                    self.requestComments(token: token, postID: postID)
                }
            }
            .store(in: &subscriptions)
    }
    
    func requestLike(token: String, postID: Int) {
        var urlStr = "/anonymous/\(postID)/"
        
        if self.liked {
            urlStr += "unlike"
        } else {
            urlStr += "like"
        }
        
        let url = URL(string: URLList.baseURL + urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("completion")
                    print(error.localizedDescription)
                }
            } receiveValue: { (data, response) in
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                }
                
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    self.liked.toggle()
                    if self.liked {
                        self.likeCount += 1
                    } else {
                        self.likeCount -= 1
                    }
                } else {
                    self.isRequestFailed = true
                    self.responseTitle = "좋아요 실패"
                    do {
                        print(String(data: data, encoding: .utf8))
                        let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                        self.responseMessage = json.message
                    } catch(let error) {
                        print(String(data: data, encoding: .utf8))
                        print("response: \(error.localizedDescription)")
                        self.responseMessage = error.localizedDescription
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
