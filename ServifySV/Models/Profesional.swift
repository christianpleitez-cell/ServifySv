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

extension Profesional {
    // Some endpoints return camelCase keys, others snake_case — handle both
    private enum FallbackKeys: String, CodingKey {
        case id = "id"
        case calificacionPromedio = "calificacionPromedio"
        case totalCalificaciones = "totalCalificaciones"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let fb = try? decoder.container(keyedBy: FallbackKeys.self)

        if let pid = try? c.decode(Int.self, forKey: .id) {
            id = pid
        } else {
            id = (try? fb?.decode(Int.self, forKey: .id)) ?? 0
        }
        usuario = try? c.decodeIfPresent(User.self, forKey: .usuario)
        especialidad = try? c.decodeIfPresent(String.self, forKey: .especialidad)
        descripcion = try? c.decodeIfPresent(String.self, forKey: .descripcion)
        experiencia = try? c.decodeIfPresent(Int.self, forKey: .experiencia)
        estadoVerificacion = try? c.decodeIfPresent(String.self, forKey: .estadoVerificacion)
        biografia = try? c.decodeIfPresent(String.self, forKey: .biografia)
        servicios = try? c.decodeIfPresent([Servicio].self, forKey: .servicios)

        // totalCalificaciones: snake_case or camelCase
        if let t = try? c.decodeIfPresent(Int.self, forKey: .totalCalificaciones) {
            totalCalificaciones = t
        } else {
            totalCalificaciones = try? fb?.decodeIfPresent(Int.self, forKey: .totalCalificaciones)
        }

        // calificacionPromedio: snake_case or camelCase, Double or String
        if let d = try? c.decodeIfPresent(Double.self, forKey: .calificacionPromedio) {
            calificacionPromedio = d
        } else if let s = try? c.decodeIfPresent(String.self, forKey: .calificacionPromedio), let d = Double(s) {
            calificacionPromedio = d
        } else if let d = try? fb?.decodeIfPresent(Double.self, forKey: .calificacionPromedio) {
            calificacionPromedio = d
        } else if let s = try? fb?.decodeIfPresent(String.self, forKey: .calificacionPromedio), let d = Double(s) {
            calificacionPromedio = d
        } else {
            calificacionPromedio = nil
        }
    }
}
