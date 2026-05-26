import Foundation

enum CategoriaServicio: String, CaseIterable, Codable {
    case electricidad = "electricidad"
    case plomeria = "plomeria"
    case albanileria = "albanileria"
    case pintura = "pintura"
    case carpinteria = "carpinteria"
    case limpieza = "limpieza"
    case jardineria = "jardineria"
    case otro = "otro"
}

struct Servicio: Codable {
    let id: Int
    let idProfesional: Int?
    var nombreServicio: String
    var categoria: String
    var descripcion: String?
    var precioReferencia: Double
    var disponibilidad: Bool
    var fechaCreacion: String?

    enum CodingKeys: String, CodingKey {
        case id = "id_servicio"
        case idProfesional = "id_profesional"
        case nombreServicio = "nombre_servicio"
        case categoria
        case descripcion
        case precioReferencia = "precio_referencia"
        case disponibilidad
        case fechaCreacion = "fecha_creacion"
    }
}

extension Servicio {
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        idProfesional = try c.decodeIfPresent(Int.self, forKey: .idProfesional)
        nombreServicio = try c.decode(String.self, forKey: .nombreServicio)
        categoria = (try? c.decodeIfPresent(String.self, forKey: .categoria)) ?? ""
        descripcion = try c.decodeIfPresent(String.self, forKey: .descripcion)
        fechaCreacion = try c.decodeIfPresent(String.self, forKey: .fechaCreacion)

        // El servidor devuelve precio como String ("2500.00") o Double
        if let d = try? c.decode(Double.self, forKey: .precioReferencia) {
            precioReferencia = d
        } else if let s = try? c.decode(String.self, forKey: .precioReferencia), let d = Double(s) {
            precioReferencia = d
        } else {
            precioReferencia = 0
        }

        // El servidor devuelve disponibilidad como Int (1/0), Bool, o puede estar ausente
        if let b = try? c.decode(Bool.self, forKey: .disponibilidad) {
            disponibilidad = b
        } else if let i = try? c.decode(Int.self, forKey: .disponibilidad) {
            disponibilidad = i != 0
        } else {
            disponibilidad = true
        }
    }
}
