import Foundation


class User: Codable {
    let id: String
    var password: String
    let name: String
    var nickName: String
    let birth: String
    var email, phoneNum, address: String
    let activated: Bool
    let gender: String
    var temperature: Double
    var profileImg: String?
    let roles: [String]
    let uid: Int

    enum CodingKeys: String, CodingKey {
        case id, password, name, nickName, birth, email
        case phoneNum = "phone_num"
        case address, activated, gender, temperature
        case profileImg = "profile_img"
        case roles, uid
    }

    init(id: String, password: String, name: String, nickName: String, birth: String, email: String, phoneNum: String, address: String, activated: Bool, gender: String, temperature: Double, profileImg: String?, roles: [String], uid: Int) {
        self.id = id
        self.password = password
        self.name = name
        self.nickName = nickName
        self.birth = birth
        self.email = email
        self.phoneNum = phoneNum
        self.address = address
        self.activated = activated
        self.gender = gender
        self.temperature = temperature
        self.profileImg = profileImg
        self.roles = roles
        self.uid = uid
    }
}

extension User {
    static func mock() -> User {
        return User(id: "abcd", password: "1234", name: "홍길동", nickName: "홍길동닉네임", birth: "1500-01-05", email: "알아서 뭐하게", phoneNum: "01012344567", address: "서울시 성북구", activated: false, gender: "남", temperature: 36.5, profileImg: nil, roles: [], uid: 100001)
    }
}
