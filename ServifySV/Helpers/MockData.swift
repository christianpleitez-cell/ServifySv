import Foundation

struct MockData {

    // MARK: - Usuarios
    static let usuarioCliente = User(
        id: 1,
        nombre: "Carlos Martínez",
        correo: "carlos1@gmail.com",
        tipoUsuario: .cliente,
        fechaRegistro: Date(),
        fotoPerfil: nil
    )

    static let usuarioCliente2 = User(
        id: 2,
        nombre: "María López",
        correo: "maria@gmail.com",
        tipoUsuario: .cliente,
        fechaRegistro: Date(),
        fotoPerfil: nil
    )

    // MARK: - Servicios Mock
    static let servicios: [Servicio] = [
        Servicio(id: 1, idProfesional: 1, nombreServicio: "Instalación eléctrica", categoria: "electricidad", precioReferencia: 25.00, disponibilidad: true),
        Servicio(id: 2, idProfesional: 1, nombreServicio: "Reparación de cortocircuitos", categoria: "electricidad", precioReferencia: 15.00, disponibilidad: true),
        Servicio(id: 3, idProfesional: 2, nombreServicio: "Reparación de tuberías", categoria: "plomeria", precioReferencia: 20.00, disponibilidad: true),
        Servicio(id: 4, idProfesional: 2, nombreServicio: "Instalación de inodoros", categoria: "plomeria", precioReferencia: 35.00, disponibilidad: true),
        Servicio(id: 5, idProfesional: 3, nombreServicio: "Pintura interior", categoria: "pintura", precioReferencia: 40.00, disponibilidad: true),
        Servicio(id: 6, idProfesional: 4, nombreServicio: "Construcción de paredes", categoria: "albanileria", precioReferencia: 60.00, disponibilidad: true),
        Servicio(id: 7, idProfesional: 5, nombreServicio: "Poda de árboles", categoria: "jardineria", precioReferencia: 18.00, disponibilidad: false),
        Servicio(id: 8, idProfesional: 6, nombreServicio: "Limpieza profunda del hogar", categoria: "limpieza", precioReferencia: 30.00, disponibilidad: true),
    ]

    // MARK: - Profesionales Mock
    static let profesionales: [Profesional] = [
        Profesional(
            id: 1,
            usuario: User(id: 10, nombre: "Roberto Pérez", correo: "roberto@gmail.com", tipoUsuario: .profesional, fechaRegistro: Date(), fotoPerfil: nil),
            especialidad: "Electricista",
            descripcion: "Técnico eléctrico con más de 8 años de experiencia. Especialista en instalaciones residenciales y comerciales. Trabajo garantizado y materiales de calidad.",
            experiencia: 8,
            estadoVerificacion: "Verificado",
            calificacionPromedio: 4.8,
            totalCalificaciones: 47,
            servicios: [servicios[0], servicios[1]]
        ),
        Profesional(
            id: 2,
            usuario: User(id: 11, nombre: "Juan Hernández", correo: "juan@gmail.com", tipoUsuario: .profesional, fechaRegistro: Date(), fotoPerfil: nil),
            especialidad: "Plomero",
            descripcion: "Plomero profesional con 5 años de experiencia. Reparaciones de emergencia disponibles. Atención rápida y precios justos.",
            experiencia: 5,
            estadoVerificacion: "Verificado",
            calificacionPromedio: 4.5,
            totalCalificaciones: 31,
            servicios: [servicios[2], servicios[3]]
        ),
        Profesional(
            id: 3,
            usuario: User(id: 12, nombre: "Ana García", correo: "ana@gmail.com", tipoUsuario: .profesional, fechaRegistro: Date(), fotoPerfil: nil),
            especialidad: "Pintora",
            descripcion: "Especialista en pintura interior y exterior. Trabajo limpio y ordenado, con acabados de alta calidad. 10 años en el rubro.",
            experiencia: 10,
            estadoVerificacion: "Verificado",
            calificacionPromedio: 4.9,
            totalCalificaciones: 63,
            servicios: [servicios[4]]
        ),
        Profesional(
            id: 4,
            usuario: User(id: 13, nombre: "Mario Gutiérrez", correo: "mario@gmail.com", tipoUsuario: .profesional, fechaRegistro: Date(), fotoPerfil: nil),
            especialidad: "Albañil",
            descripcion: "Constructor con experiencia en construcción y remodelación. Trabajos de calidad garantizada con materiales de primera.",
            experiencia: 12,
            estadoVerificacion: "Verificado",
            calificacionPromedio: 4.3,
            totalCalificaciones: 28,
            servicios: [servicios[5]]
        ),
        Profesional(
            id: 5,
            usuario: User(id: 14, nombre: "Luis Castillo", correo: "luis@gmail.com", tipoUsuario: .profesional, fechaRegistro: Date(), fotoPerfil: nil),
            especialidad: "Jardinero",
            descripcion: "Experto en jardinería y paisajismo. Mantenimiento de jardines, poda y diseño de espacios verdes.",
            experiencia: 6,
            estadoVerificacion: "Pendiente",
            calificacionPromedio: 4.1,
            totalCalificaciones: 15,
            servicios: [servicios[6]]
        ),
        Profesional(
            id: 6,
            usuario: User(id: 15, nombre: "Carmen Morales", correo: "carmen@gmail.com", tipoUsuario: .profesional, fechaRegistro: Date(), fotoPerfil: nil),
            especialidad: "Limpieza",
            descripcion: "Servicio de limpieza profesional para hogares y oficinas. Personal capacitado y productos incluidos.",
            experiencia: 4,
            estadoVerificacion: "Verificado",
            calificacionPromedio: 4.7,
            totalCalificaciones: 52,
            servicios: [servicios[7]]
        ),
    ]

    // MARK: - Calificaciones Mock
    static let calificaciones: [Calificacion] = [
        Calificacion(id: 1, idSolicitud: 1, puntuacion: 5, comentario: "Excelente trabajo, muy profesional y puntual.", fecha: Date()),
        Calificacion(id: 2, idSolicitud: 2, puntuacion: 4, comentario: "Buen servicio, llegó a tiempo y resolvió el problema.", fecha: Date()),
        Calificacion(id: 3, idSolicitud: 3, puntuacion: 5, comentario: "Muy satisfecha con el trabajo realizado.", fecha: Date()),
    ]

    // MARK: - Solicitudes Mock
    static let solicitudes: [Solicitud] = [
        Solicitud(
            id: 1,
            cliente: usuarioCliente,
            servicio: servicios[0],
            profesional: profesionales[0],
            fechaSolicitud: "2026-04-21",
            estado: "completada",
            descripcion: "Necesito instalación eléctrica en sala y dos habitaciones.",
            calificacion: nil
        ),
        Solicitud(
            id: 2,
            cliente: usuarioCliente,
            servicio: servicios[2],
            profesional: profesionales[1],
            fechaSolicitud: "2026-04-23",
            estado: "aceptada",
            descripcion: "Tubería con fuga en el baño principal.",
            calificacion: nil
        ),
        Solicitud(
            id: 3,
            cliente: usuarioCliente,
            servicio: servicios[4],
            profesional: profesionales[2],
            fechaSolicitud: "2026-04-24",
            estado: "pendiente",
            descripcion: "Pintura de sala y comedor, paredes blancas.",
            calificacion: nil
        ),
    ]

    // MARK: - Chats Mock
    static let chats: [Chat] = [
        Chat(
            id: 1,
            solicitud: solicitudes[0],
            mensajes: [
                Mensaje(id: 1, idSolicitud: 1, remitente: usuarioCliente, contenido: "Hola, necesito instalar electricidad en la sala.", fechaEnvio: "10:00", esPropio: true),
                Mensaje(id: 2, idSolicitud: 1, remitente: profesionales[0].usuario, contenido: "Buenos días, con gusto le ayudo. ¿A qué hora le queda bien?", fechaEnvio: "11:00", esPropio: false),
                Mensaje(id: 3, idSolicitud: 1, remitente: usuarioCliente, contenido: "Mañana a las 9am si puede.", fechaEnvio: "11:30", esPropio: true),
                Mensaje(id: 4, idSolicitud: 1, remitente: profesionales[0].usuario, contenido: "Perfecto, ahí estaré. Le mando mi ubicación cuando salga.", fechaEnvio: "11:45", esPropio: false),
            ]
        ),
        Chat(
            id: 2,
            solicitud: solicitudes[1],
            mensajes: [
                Mensaje(id: 5, idSolicitud: 2, remitente: usuarioCliente, contenido: "Tengo una fuga en el baño, ¿cuándo puede venir?", fechaEnvio: "09:00", esPropio: true),
                Mensaje(id: 6, idSolicitud: 2, remitente: profesionales[1].usuario, contenido: "Puedo ir esta tarde a las 3pm.", fechaEnvio: "10:00", esPropio: false),
            ]
        ),
    ]

    // MARK: - Historial Mock
    static let historial: [Historial] = [
        Historial(id: 1, profesional: profesionales[0], solicitud: solicitudes[0], estadoFinal: "Completado"),
        Historial(id: 2, profesional: profesionales[1], solicitud: solicitudes[1], estadoFinal: "En progreso"),
    ]

    // MARK: - Servicios del profesional actual
    static let serviciosProfesional: [Servicio] = [
        Servicio(id: 1, idProfesional: 1, nombreServicio: "Construcción y Remodelación", categoria: "albanileria", precioReferencia: 500.00, disponibilidad: true),
        Servicio(id: 2, idProfesional: 1, nombreServicio: "Reparación de Estructuras", categoria: "albanileria", precioReferencia: 350.00, disponibilidad: true),
    ]

    // MARK: - Usuario actual simulado
    static var usuarioActual: User = usuarioCliente
}
