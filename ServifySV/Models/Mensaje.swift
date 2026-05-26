import Foundation

struct Mensaje: Codable {
    let id: Int
    let idSolicitud: Int?
    let remitente: User?
    var contenido: String
    var fechaEnvio: String?
    var esPropio: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "id_mensaje"
        case idSolicitud = "id_solicitud"
        case remitente
        case contenido
        case fechaEnvio = "fecha_envio"
    }

    init(id: Int, idSolicitud: Int?, remitente: User?, contenido: String, fechaEnvio: String?, esPropio: Bool = false) {
        self.id = id
        self.idSolicitud = idSolicitud
        self.remitente = remitente
        self.contenido = contenido
        self.fechaEnvio = fechaEnvio
        self.esPropio = esPropio
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        idSolicitud = try container.decodeIfPresent(Int.self, forKey: .idSolicitud)
        remitente = try container.decodeIfPresent(User.self, forKey: .remitente)
        contenido = try container.decode(String.self, forKey: .contenido)
        fechaEnvio = try container.decodeIfPresent(String.self, forKey: .fechaEnvio)
        esPropio = false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(idSolicitud, forKey: .idSolicitud)
        try container.encodeIfPresent(remitente, forKey: .remitente)
        try container.encode(contenido, forKey: .contenido)
        try container.encodeIfPresent(fechaEnvio, forKey: .fechaEnvio)
    }
}

struct Chat: Codable {
    let id: Int
    let solicitud: Solicitud?
    var mensajes: [Mensaje]?
}
