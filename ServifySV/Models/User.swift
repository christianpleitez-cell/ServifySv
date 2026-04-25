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
    var fechaRegistro: Date
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

// Respuesta del login sin timestamp (para POST /auth/login)
struct LoginUser: Codable {
    let id: Int
    let nombre: String
    let correo: String
    let tipo_usuario: String
}
