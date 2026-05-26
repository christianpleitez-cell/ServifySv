import Foundation

struct Resena: Codable {
    let id: Int
    let idSolicitud: Int
    let idCliente: Int
    let idProfesional: Int
    var calificacion: Int
    var comentario: String?
    var fechaResena: String?
    var cliente: User?

    enum CodingKeys: String, CodingKey {
        case id = "id_resena"
        case idSolicitud = "id_solicitud"
        case idCliente = "id_cliente"
        case idProfesional = "id_profesional"
        case calificacion
        case comentario
        case fechaResena = "fecha_resena"
        case cliente
    }
}

extension Resena {
    private enum FallbackKeys: String, CodingKey { case id = "id" }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let resenaId = try? c.decode(Int.self, forKey: .id) {
            id = resenaId
        } else {
            let fb = try decoder.container(keyedBy: FallbackKeys.self)
            id = (try? fb.decode(Int.self, forKey: .id)) ?? 0
        }
        idSolicitud = (try? c.decode(Int.self, forKey: .idSolicitud)) ?? 0
        idCliente = (try? c.decode(Int.self, forKey: .idCliente)) ?? 0
        idProfesional = (try? c.decode(Int.self, forKey: .idProfesional)) ?? 0
        if let i = try? c.decode(Int.self, forKey: .calificacion) {
            calificacion = i
        } else if let s = try? c.decode(String.self, forKey: .calificacion), let i = Int(s) {
            calificacion = i
        } else {
            calificacion = 5
        }
        comentario = try? c.decodeIfPresent(String.self, forKey: .comentario)
        fechaResena = try? c.decodeIfPresent(String.self, forKey: .fechaResena)
        cliente = try? c.decodeIfPresent(User.self, forKey: .cliente)
    }
}
