import Foundation

enum EstadoSolicitud: String {
    case pendiente = "Pendiente"
    case aceptada = "Aceptada"
    case enProgreso = "En Progreso"
    case completada = "Completada"
    case cancelada = "Cancelada"
}

struct Solicitud {
    let id: Int
    let cliente: User
    let servicio: Servicio
    let profesional: Profesional
    var fechaSolicitud: Date
    var estado: EstadoSolicitud
    var descripcion: String
    var calificacion: Calificacion?
}
