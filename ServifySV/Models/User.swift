import Foundation

enum UserType: String, Codable {
    case cliente = "cliente"
    case profesional = "profesional"
}

struct User {
    let id: Int
    var nombre: String
    var correo: String
    var tipoUsuario: UserType
    var fechaRegistro: Date
    var fotoPerfil: String?
}
