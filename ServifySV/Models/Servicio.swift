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
    let idProfesional: Int
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
