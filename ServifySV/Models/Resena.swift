import Foundation

struct Resena: Codable {
    let id: Int
    let idSolicitud: Int
    let idCliente: Int
    let idProfesional: Int
    var calificacion: Int
    var comentario: String?
    var fechaResena: String?

    enum CodingKeys: String, CodingKey {
        case id = "id_resena"
        case idSolicitud = "id_solicitud"
        case idCliente = "id_cliente"
        case idProfesional = "id_profesional"
        case calificacion
        case comentario
        case fechaResena = "fecha_resena"
    }
}
