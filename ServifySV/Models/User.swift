import Foundation

enum UserType: String, Codable {
    case cliente = "cliente"
    case profesional = "profesional"
}

struct User: Codable {
    let id: Int
    var nombre: String
    var correo: String
    var tipoUsuario: UserType
    var telefono: String?
    var ubicacion: String?
    var fechaRegistro: String?
    var fotoPerfil: String?

    enum CodingKeys: String, CodingKey {
        case id = "id_usuario"
        case nombre
        case correo
        case tipoUsuario = "tipo_usuario"
        case telefono
        case ubicacion
        case fechaRegistro = "fecha_registro"
        case fotoPerfil = "foto_perfil"
    }
}

extension User {
    private enum FallbackKeys: String, CodingKey { case id = "id" }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let userId = try? c.decode(Int.self, forKey: .id) {
            id = userId
        } else {
            let fb = try decoder.container(keyedBy: FallbackKeys.self)
            id = (try? fb.decode(Int.self, forKey: .id)) ?? 0
        }
        nombre = (try? c.decode(String.self, forKey: .nombre)) ?? ""
        correo = (try? c.decode(String.self, forKey: .correo)) ?? ""
        tipoUsuario = (try? c.decodeIfPresent(UserType.self, forKey: .tipoUsuario)) ?? .cliente
        telefono = try? c.decodeIfPresent(String.self, forKey: .telefono)
        ubicacion = try? c.decodeIfPresent(String.self, forKey: .ubicacion)
        fechaRegistro = try? c.decodeIfPresent(String.self, forKey: .fechaRegistro)
        fotoPerfil = try? c.decodeIfPresent(String.self, forKey: .fotoPerfil)
    }
}

// Respuesta del login sin timestamp (para POST /auth/login)
struct LoginUser: Codable {
    let id: Int?
    let id_usuario: Int?
    let id_profesional: Int?
    let nombre: String
    let correo: String
    let tipo_usuario: String

    var userId: Int? { id_usuario ?? id }
}
