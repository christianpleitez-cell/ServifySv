import Foundation

struct Profesional: Codable {
    let id: Int
    let usuario: User?
    var especialidad: String?
    var descripcion: String?
    var experiencia: Int?
    var estadoVerificacion: String?
    var calificacionPromedio: Double?
    var totalCalificaciones: Int?
    var biografia: String?
    var servicios: [Servicio]?

    enum CodingKeys: String, CodingKey {
        case id = "id_profesional"
        case usuario
        case especialidad
        case descripcion
        case experiencia
        case estadoVerificacion = "estado_verificacion"
        case calificacionPromedio = "calificacion_promedio"
        case totalCalificaciones = "total_calificaciones"
        case biografia
        case servicios
    }
}
