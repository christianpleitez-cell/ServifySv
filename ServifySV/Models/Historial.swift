import Foundation

struct Historial: Codable {
    let id: Int
    let profesional: Profesional?
    let solicitud: Solicitud?
    var estadoFinal: String?

    enum CodingKeys: String, CodingKey {
        case id = "id_historial"
        case profesional
        case solicitud
        case estadoFinal = "estado_final"
    }
}
