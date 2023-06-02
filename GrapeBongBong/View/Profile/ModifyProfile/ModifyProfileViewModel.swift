//
//  ModifyProfileViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/25.
//

import Foundation
import Combine
import UIKit

final class ModifyProfileViewModel: ObservableObject {
    @Published var isAlert = false
    @Published var isRequestSuccess = false
    @Published var profileImageURL: String? = nil
    
    var responseTitle = ""
    var responseMessage = ""
    
    private var subscription = Set<AnyCancellable>()
    
    func requestProfileModify(token: String, userID: String, nickname: String, email: String, phoneNum: String, password: String) {
        print(userID)
        
        let url = URL(string: URLList.baseURL + "/user/profile/\(userID)")!
        let modifyProfileRequest = ModifyProfileRequest(nickname: nickname, email: email, phoneNum: phoneNum, password: password)
        let json = try! JSONEncoder().encode(modifyProfileRequest)
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = json
        print(String(data: request.httpBody!, encoding: .utf8))
        
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
                    self.isRequestSuccess = true
                }
                
                do {
                    let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                    self.responseTitle = self.isRequestSuccess ? "수정 성공" : "수정 실패"
                    self.responseMessage = json.message
                    print("success")
                    print(json.message)
                } catch (let error) {
                    self.responseTitle = "수정 실패"
                    self.responseMessage = "데이터를 받아오는데 실패했습니다."
                    print(error)
                }
            }
            .store(in: &subscription)
    }
    
    func requestChangeProfileImg(token: String, imgData: Data?, userID: String) {
        guard let imgData = imgData, let uiImage = UIImage(data: imgData) else {
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let url = URL(string: URLList.baseURL + "/user/profile/image")!
        
        var httpBody = Data()
        let formData = createFormData(with: uiImage, forKey: "image", fileName: "\(userID)_profileImg", using: boundary)
        print(formData)
        httpBody.append(formData)
        httpBody.append("--\(boundary)--".data(using: .utf8)!)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        print("...>>> \(request.httpBody)")
        
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
                if let response = response as? HTTPURLResponse,
                   (200..<300).contains(response.statusCode) {
                    do {
                        let json = try JSONDecoder().decode(ProfileImageResponse.self, from: data)
                        self.profileImageURL = json.profileImage
                    } catch(let error) {
                        print(error)
                    }
                } else {
                    print(">>>>" + String(data: data, encoding: .utf8)!)
                    do {
                        let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                        print(json.message)
                    } catch(let error) {
                        print(error)
                    }
                }
            }
            .store(in: &subscription)
    }
}

extension ModifyProfileViewModel {
    private func createFormData(with image: UIImage, forKey key: String, fileName: String, using boundary: String) -> Data {
        let lineBreak = "\r\n"
        
        var body = Data()
        body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
                body.append(imageData)
                body.append(lineBreak.data(using: .utf8)!)
        }
        
        return body
    }
}

struct ModifyProfileRequest: Encodable {
    let nickname: String
    let email: String
    let phoneNum: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nickName"
        case email
        case phoneNum = "phoneNumber"
        case password
    }
}

struct ProfileImageResponse: Decodable {
    let profileImage: String
}
