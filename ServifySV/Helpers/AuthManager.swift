import Foundation

final class AuthManager {
    static let shared = AuthManager()

    private let tokenKey = "jwt_token"
    private let userKey = "current_user"

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }

    var currentUser: LoginUser? {
        get {
            guard let data = UserDefaults.standard.data(forKey: userKey) else { return nil }
            return try? JSONDecoder().decode(LoginUser.self, from: data)
        }
        set {
            if let newValue = newValue,
               let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: userKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userKey)
            }
        }
    }

    var isProfessional: Bool {
        currentUser?.tipo_usuario == "profesional"
    }

    var isLoggedIn: Bool {
        token != nil && currentUser != nil
    }

    func saveSession(token: String, user: LoginUser) {
        self.token = token
        self.currentUser = user
    }

    func clearSession() {
        token = nil
        currentUser = nil
    }

    func authHeader() -> [String: String] {
        guard let token = token else { return [:] }
        return ["Authorization": "Bearer \(token)"]
    }
}
