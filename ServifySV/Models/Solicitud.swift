import Foundation

enum EstadoSolicitud: String, Codable {
    case pendiente = "pendiente"
    case aceptada = "aceptada"
    case rechazada = "rechazada"
    case completada = "completada"
    case cancelada = "cancelada"
}

struct Solicitud: Codable {
    let id: Int
    let cliente: User?
    let servicio: Servicio?
    let profesional: Profesional?
    var fechaSolicitud: String?
    var estado: String
    var descripcion: String
    var calificacion: Resena?

    enum CodingKeys: String, CodingKey {
        case id = "id_solicitud"
        case cliente
        case servicio
        case profesional
        case fechaSolicitud = "fecha"
        case estado
        case descripcion
        case calificacion
    }
}
