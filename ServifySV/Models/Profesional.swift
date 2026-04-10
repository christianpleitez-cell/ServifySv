import Foundation

struct Profesional {
    let id: Int
    let usuario: User
    var especialidad: String
    var descripcion: String
    var experiencia: Int
    var estadoVerificacion: String
    var calificacionPromedio: Double
    var totalCalificaciones: Int
    var servicios: [Servicio]
}
