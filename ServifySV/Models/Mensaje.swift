import Foundation

struct Mensaje {
    let id: Int
    let idChat: Int
    let remitente: User
    var contenido: String
    var fechaEnvio: Date
    var esPropio: Bool
}

struct Chat {
    let id: Int
    let solicitud: Solicitud
    var mensajes: [Mensaje]
}
