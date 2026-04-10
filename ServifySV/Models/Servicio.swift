import Foundation

enum CategoriaServicio: String, CaseIterable {
    case electricidad = "Electricidad"
    case plomeria = "Plomería"
    case albanileria = "Albañilería"
    case pintura = "Pintura"
    case carpinteria = "Carpintería"
    case limpieza = "Limpieza"
    case jardineria = "Jardinería"
    case otro = "Otro"
}

struct Servicio {
    let id: Int
    let idProfesional: Int
    var nombreServicio: String
    var categoria: CategoriaServicio
    var precioReferencia: Double
    var disponibilidad: String
}
