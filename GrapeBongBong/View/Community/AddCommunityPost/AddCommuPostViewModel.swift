//
//  AddCommuPostViewModel.swift
//  GrapeBongBong
//
//  Created by 김준성 on 2023/05/21.
//

import Foundation
import Combine
import UIKit

final class AddCommuPostViewModel: ObservableObject {
    @Published var title = ""
    @Published var content = ""
    @Published var isAddSuccess = false
    @Published var isAddFailed = false
    
    var responseMessage = ""
    private var subscriptions = Set<AnyCancellable>()
    
    func sendRequestWithPhoto(with token: String, images: [UIImage]) {
        if content.count == 0 || title.count == 0 {
            responseMessage = "빠진 곳이 있나 다시 확인해주세요."
            isAddFailed = true
            return
        }
        
        let commuPostRequest = CommuPostRequest(title: title, content: content)
        
        guard let json = try? JSONEncoder().encode(commuPostRequest) else { return }
        guard let jsonString = String(data: json, encoding: .utf8) else { return }
        let textData = ["anonymousPostDTO": jsonString]
        
        let url = URL(string: URLList.baseURL + "/anonymous/post")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.httpBody = json
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        for (key, value) in textData {
            httpBody.append(convertFormField(named: key, value: value, using: boundary))
        }
        print("----------------------------------------")
        print("json만 >>> \(String(data: httpBody, encoding: .utf8))")
        print("----------------------------------------")
        
        var index = 1
        for image in images {
            let formData = createFormData(with: image, forKey: "images", fileName: "\(index).jpg", using: boundary)
            httpBody.append(formData)
            index += 1
        }
        
        httpBody.append("--\(boundary)--".data(using: .utf8)!)
        request.httpBody = httpBody
        
        URLSession.shared.dataTaskPublisher(for: request)
            .retry(1)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.isAddFailed = true
                    self.responseMessage = "통신 중 오류가 발생했어요."
                    return
                case .finished:
                    break
                }
            } receiveValue: { (data, response) in
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    self.isAddSuccess = true
                } else {
                    self.isAddFailed = true
                }
                
                print("포스트 추가>>> \(String(data: data, encoding: .utf8))")
                
                do {
                    let json = try JSONDecoder().decode(ResponseMessage.self, from: data)
                    self.responseMessage = json.message
                    print(json.message)
                } catch {
                    print(">>> \(String(data: data, encoding: .utf8))")
                    self.responseMessage = response.description
                }
            }
            .store(in: &subscriptions)
    }
}

extension AddCommuPostViewModel {
    private func convertFormField(named name: String, value: String, using boundary: String) -> Data {
        let mimeType = "application/json"
        
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: \(mimeType)\r\n\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString.data(using: .utf8)!
    }
    
    private func convertFileData(fieldName: String,
                                 fileName: String,
                                 mimeType: String,
                                 fileData: Data,
                                 using boundary: String) -> Data {
        print("fileData: \(String(data: fileData, encoding: .utf8))")
        
        var data = Data()
        var fieldString = "--\(boundary)\r\n"
        if fileName == "" {
            fieldString += "Content-Disposition: form-data; name=\"\(fieldName)\"\r\n"
        } else {
            fieldString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        }
        fieldString += "Content-Type: \(mimeType)\r\n\r\n"
        data.append(fieldString.data(using: .utf8)!)
        print("convertFileData1: \(data)")
        data.append(fileData)
        print("convertFileData2: \(data)")
        data.append("\r\n".data(using: .utf8)!)
        
        print("convertFileData3: \(data)")
        return data as Data
    }
    
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

struct CommuPostRequest: Codable {
    var title: String
    var content: String
}
