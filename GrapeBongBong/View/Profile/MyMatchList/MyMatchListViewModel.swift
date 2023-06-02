import Foundation
import Combine

final class MyMatchListViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isSuccess = false
    @Published var isRequested = false
    @Published var title = ""
    @Published var message = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    func requestList(token: String) {
        let url = URL(string: URLList.baseURL + "/user/profile/completed-matches")!
        
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
                    print("completion Error: \(error.localizedDescription)")
                }
            } receiveValue: { (data, response) in
                
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                
                if (200..<300).contains(response.statusCode) {
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormater)
                    
                    do {
                        let json = try decoder.decode([Post].self, from: data)
                        self.posts = json
                        print(self.posts.count)
                    } catch(let error) {
                        print(error.localizedDescription)
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    func requestScore(token: String, postID: Int, score: Int) {
        let url = URL(string: URLList.baseURL + "/match/\(postID)/rating/\(score)")!
        
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
                    print("completion Error: \(error.localizedDescription)")
                }
            } receiveValue: { (data, response) in
                
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                
                self.isRequested = true
                
                if (200..<300).contains(response.statusCode) {
                    self.isSuccess = true
                    self.title = "평점 매기기 성공"
                } else {
                    self.isSuccess = false
                    self.title = "평점 매기기 성공"
                }
                do {
                    let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                    self.message = json.message
                } catch(let error) {
                    self.message = "알 수 없는 오류가 발생했어요."
                    print(error.localizedDescription)
                }
            }
            .store(in: &subscriptions)
    }
}
