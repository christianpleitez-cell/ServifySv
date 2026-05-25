import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidRequest
    case decodingError
    case networkError(String)
    case serverError(Int, String)
    case unauthorized
    case notFound
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL es inválida"
        case .invalidRequest:
            return "La solicitud es inválida"
        case .decodingError:
            return "Error decodificando respuesta"
        case .networkError(let message):
            return "Error de red: \(message)"
        case .serverError(let code, let message):
            return "Error servidor (\(code)): \(message)"
        case .unauthorized:
            return "No autorizado. Por favor inicia sesión nuevamente"
        case .notFound:
            return "No encontrado"
        case .unknownError:
            return "Error desconocido"
        }
    }
}

final class APIManager {
    static let shared = APIManager()

    let baseURL = "https://servify-mobile.fly.dev/api/v1"

    // Generic request method
    private func request<T: Decodable>(
        method: String,
        path: String,
        body: [String: Any]? = nil,
        requiresAuth: Bool = false,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: baseURL + path) else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method

        // Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth {
            let headers = AuthManager.shared.authHeader()
            headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        }

        // Body
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(.invalidRequest))
                return
            }
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // Check network error
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }

            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }

            // Handle error status codes
            switch httpResponse.statusCode {
            case 200, 201:
                break
            case 401:
                completion(.failure(.unauthorized))
                return
            case 404:
                completion(.failure(.notFound))
                return
            case 400...599:
                let errorMsg = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(.serverError(httpResponse.statusCode, errorMsg)))
                return
            default:
                completion(.failure(.unknownError))
                return
            }

            // Decode response
            guard let data = data else {
                completion(.failure(.decodingError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    // MARK: - AUTH Endpoints

    func login(correo: String, contrasena: String, tipoUsuario: String, completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        let body: [String: Any] = [
            "correo": correo,
            "contraseña": contrasena
        ]
        request(method: "POST", path: "/auth/login", body: body, requiresAuth: false, completion: completion)
    }

    func register(nombre: String, correo: String, telefono: String, contrasena: String, tipoUsuario: String, completion: @escaping (Result<SuccessResponse, APIError>) -> Void) {
        let body: [String: Any] = [
            "nombre": nombre,
            "correo": correo,
            "contraseña": contrasena,
            "tipo_usuario": tipoUsuario
        ]
        request(method: "POST", path: "/auth/register", body: body, requiresAuth: false, completion: completion)
    }

    func getPerfil(userId: Int, completion: @escaping (Result<UserResponse, APIError>) -> Void) {
        request(method: "GET", path: "/auth/perfil/\(userId)", requiresAuth: true, completion: completion)
    }

    func updatePerfil(userId: Int, nombre: String?, telefono: String?, correo: String?, completion: @escaping (Result<SuccessResponse, APIError>) -> Void) {
        var body: [String: Any] = [:]
        if let nombre = nombre { body["nombre"] = nombre }
        if let telefono = telefono { body["telefono"] = telefono }
        if let correo = correo { body["correo"] = correo }

        request(method: "PUT", path: "/auth/perfil/\(userId)", body: body, requiresAuth: true, completion: completion)
    }

    // MARK: - SERVICIOS Endpoints

    func getServicios(completion: @escaping (Result<ServiciosListResponse, APIError>) -> Void) {
        request(method: "GET", path: "/servicios", requiresAuth: false, completion: completion)
    }

    func getProfesionalById(id: Int, completion: @escaping (Result<ProfesionalDetailResponse, APIError>) -> Void) {
        request(method: "GET", path: "/servicios/profesional/\(id)", requiresAuth: false, completion: completion)
    }

    func getMisServicios(profesionalId: Int, completion: @escaping (Result<MisServiciosResponse, APIError>) -> Void) {
        request(method: "GET", path: "/servicios/mis-servicios/\(profesionalId)", requiresAuth: true, completion: completion)
    }

    func createServicio(idProfesional: Int, nombreServicio: String, categoria: String, descripcion: String, precioReferencia: Double, disponibilidad: Bool, completion: @escaping (Result<CreateServicioResponse, APIError>) -> Void) {
        let body: [String: Any] = [
            "idProfesional": idProfesional,
            "nombreServicio": nombreServicio,
            "categoria": categoria,
            "descripcion": descripcion,
            "precioReferencia": precioReferencia,
            "disponibilidad": disponibilidad
        ]
        request(method: "POST", path: "/servicios", body: body, requiresAuth: true, completion: completion)
    }

    func updateServicio(servicioId: Int, nombreServicio: String?, categoria: String?, descripcion: String?, precioReferencia: Double?, disponibilidad: Bool?, completion: @escaping (Result<SuccessResponse, APIError>) -> Void) {
        var body: [String: Any] = [:]
        if let nombreServicio = nombreServicio { body["nombreServicio"] = nombreServicio }
        if let categoria = categoria { body["categoria"] = categoria }
        if let descripcion = descripcion { body["descripcion"] = descripcion }
        if let precioReferencia = precioReferencia { body["precioReferencia"] = precioReferencia }
        if let disponibilidad = disponibilidad { body["disponibilidad"] = disponibilidad }

        request(method: "PUT", path: "/servicios/\(servicioId)", body: body, requiresAuth: true, completion: completion)
    }

    func deleteServicio(servicioId: Int, completion: @escaping (Result<SuccessResponse, APIError>) -> Void) {
        request(method: "DELETE", path: "/servicios/\(servicioId)", requiresAuth: true, completion: completion)
    }

    // MARK: - PROFESIONALES Endpoints

    func getProfesionales(completion: @escaping (Result<ProfesionalesListResponse, APIError>) -> Void) {
        request(method: "GET", path: "/profesionales", requiresAuth: false, completion: completion)
    }

    func getProfesionalesByCategoria(categoria: String, completion: @escaping (Result<ProfesionalesListResponse, APIError>) -> Void) {
        request(method: "GET", path: "/profesionales/categoria/\(categoria)", requiresAuth: false, completion: completion)
    }

    func getProfesional(id: Int, completion: @escaping (Result<ProfesionalFullResponse, APIError>) -> Void) {
        request(method: "GET", path: "/profesionales/\(id)", requiresAuth: false, completion: completion)
    }

    func updateProfesionalPerfil(profesionalId: Int, especialidad: String?, descripcion: String?, experiencia: Int?, biografia: String?, completion: @escaping (Result<SuccessResponse, APIError>) -> Void) {
        var body: [String: Any] = [:]
        if let especialidad = especialidad { body["especialidad"] = especialidad }
        if let descripcion = descripcion { body["descripcion"] = descripcion }
        if let experiencia = experiencia { body["experiencia"] = experiencia }
        if let biografia = biografia { body["biografia"] = biografia }

        request(method: "PUT", path: "/profesionales/\(profesionalId)", body: body, requiresAuth: true, completion: completion)
    }

    // MARK: - SOLICITUDES Endpoints

    func createSolicitud(idCliente: Int, idProfesional: Int, idServicio: Int, descripcion: String, completion: @escaping (Result<CreateSolicitudResponse, APIError>) -> Void) {
        let body: [String: Any] = [
            "idCliente": idCliente,
            "idProfesional": idProfesional,
            "idServicio": idServicio,
            "descripcion": descripcion
        ]
        request(method: "POST", path: "/solicitudes", body: body, requiresAuth: true, completion: completion)
    }

    func getSolicitudesCliente(clienteId: Int, completion: @escaping (Result<SolicitudesResponse, APIError>) -> Void) {
        request(method: "GET", path: "/solicitudes/cliente/\(clienteId)", requiresAuth: true, completion: completion)
    }

    func getSolicitudesProfesional(profesionalId: Int, completion: @escaping (Result<SolicitudesResponse, APIError>) -> Void) {
        request(method: "GET", path: "/solicitudes/profesional/\(profesionalId)", requiresAuth: true, completion: completion)
    }

    func getSolicitud(solicitudId: Int, completion: @escaping (Result<SolicitudDetailResponse, APIError>) -> Void) {
        request(method: "GET", path: "/solicitudes/\(solicitudId)", requiresAuth: true, completion: completion)
    }

    func updateSolicitudEstado(solicitudId: Int, estado: String, completion: @escaping (Result<SuccessResponse, APIError>) -> Void) {
        let body: [String: Any] = ["estado": estado]
        request(method: "PATCH", path: "/solicitudes/\(solicitudId)/estado", body: body, requiresAuth: true, completion: completion)
    }

    // MARK: - CHAT Endpoints

    func getMensajes(solicitudId: Int, completion: @escaping (Result<MensajesResponse, APIError>) -> Void) {
        request(method: "GET", path: "/chat/mensajes/\(solicitudId)", requiresAuth: true, completion: completion)
    }

    func sendMensaje(solicitudId: Int, remitenteId: Int, contenido: String, completion: @escaping (Result<SuccessResponse, APIError>) -> Void) {
        let body: [String: Any] = [
            "idSolicitud": solicitudId,
            "idRemitente": remitenteId,
            "contenido": contenido
        ]
        request(method: "POST", path: "/chat/mensaje", body: body, requiresAuth: true, completion: completion)
    }

    func getChats(usuarioId: Int, completion: @escaping (Result<ChatsResponse, APIError>) -> Void) {
        request(method: "GET", path: "/chat/chats/\(usuarioId)", requiresAuth: true, completion: completion)
    }

    // MARK: - HISTORIAL Endpoints

    func getHistorialCliente(usuarioId: Int, completion: @escaping (Result<HistorialClienteResponse, APIError>) -> Void) {
        request(method: "GET", path: "/historial/cliente/\(usuarioId)", requiresAuth: true, completion: completion)
    }

    func getTrabajosProfesional(usuarioId: Int, completion: @escaping (Result<TrabajosProfesionalResponse, APIError>) -> Void) {
        request(method: "GET", path: "/historial/profesional/\(usuarioId)/trabajos", requiresAuth: true, completion: completion)
    }

    func getIngresosProfesional(usuarioId: Int, completion: @escaping (Result<IngresosProfesionalResponse, APIError>) -> Void) {
        request(method: "GET", path: "/historial/profesional/\(usuarioId)/ingresos", requiresAuth: true, completion: completion)
    }

    // MARK: - RESENAS Endpoints

    func createResena(idSolicitud: Int, idCliente: Int, idProfesional: Int, calificacion: Int, comentario: String, completion: @escaping (Result<CreateResenaResponse, APIError>) -> Void) {
        let body: [String: Any] = [
            "idSolicitud": idSolicitud,
            "idCliente": idCliente,
            "idProfesional": idProfesional,
            "calificacion": calificacion,
            "comentario": comentario
        ]
        request(method: "POST", path: "/resenas", body: body, requiresAuth: true, completion: completion)
    }

    func getResenasProfesional(profesionalId: Int, completion: @escaping (Result<ResenasProfesionalResponse, APIError>) -> Void) {
        request(method: "GET", path: "/resenas/profesional/\(profesionalId)", requiresAuth: false, completion: completion)
    }

    func getResenaBySolicitud(solicitudId: Int, completion: @escaping (Result<ResenaResponse, APIError>) -> Void) {
        request(method: "GET", path: "/resenas/solicitud/\(solicitudId)", requiresAuth: true, completion: completion)
    }

    func updateResena(resenaId: Int, calificacion: Int, comentario: String, completion: @escaping (Result<CreateResenaResponse, APIError>) -> Void) {
        let body: [String: Any] = ["calificacion": calificacion, "comentario": comentario]
        request(method: "PUT", path: "/resenas/\(resenaId)", body: body, requiresAuth: true, completion: completion)
    }
}

// MARK: - Response Models

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let token: String
    let usuario: LoginUser
}

struct SuccessResponse: Codable {
    let success: Bool
    let message: String
}

struct UserResponse: Codable {
    let success: Bool
    let usuario: User
}

struct ServiciosListResponse: Codable {
    let ok: Bool
    let servicios: [Servicio]
}

struct ProfesionalDetailResponse: Codable {
    let id: Int
    let especialidad: String?
    let descripcion: String?
    let experiencia: Int?
    let estadoVerificacion: String?
    let calificacionPromedio: Double?
    let totalCalificaciones: Int?
    let usuario: User?
    let servicios: [Servicio]?

    enum CodingKeys: String, CodingKey {
        case id
        case especialidad
        case descripcion
        case experiencia
        case estadoVerificacion = "estadoVerificacion"
        case calificacionPromedio = "calificacionPromedio"
        case totalCalificaciones = "totalCalificaciones"
        case usuario
        case servicios
    }
}

struct ProfesionalFullResponse: Codable {
    let success: Bool
    let profesional: Profesional
}

struct MisServiciosResponse: Codable {
    let success: Bool
    let servicios: [Servicio]
}

struct CreateServicioResponse: Codable {
    let success: Bool
    let message: String
    let servicio: Servicio
}

struct ProfesionalesListResponse: Codable {
    let ok: Bool
    let profesionales: [Profesional]
}

struct CreateSolicitudResponse: Codable {
    let success: Bool
    let message: String
    let solicitud: Solicitud
}

struct SolicitudesResponse: Codable {
    let success: Bool
    let solicitudes: [Solicitud]
}

struct SolicitudDetailResponse: Codable {
    let success: Bool
    let solicitud: Solicitud
}

struct MensajesResponse: Codable {
    let ok: Bool
    let mensajes: [Mensaje]
}

struct ChatsResponse: Codable {
    let ok: Bool
    let chats: [Chat]
}

struct HistorialClienteResponse: Codable {
    let ok: Bool
    let historial: [Solicitud]
}

struct TrabajosProfesionalResponse: Codable {
    let success: Bool
    let trabajos: [Solicitud]
    let total: Int
}

struct IngresosProfesionalResponse: Codable {
    let success: Bool
    let estadisticas: Estadisticas
    let ingresosPorCategoria: [IngresoPorCategoria]
    let ingresosPorMes: [IngresoPorMes]
}

struct Estadisticas: Codable {
    let ingresoTotal: Double
    let totalTrabajosCompletados: Int

    enum CodingKeys: String, CodingKey {
        case ingresoTotal = "ingresoTotal"
        case totalTrabajosCompletados = "totalTrabajosCompletados"
    }
}

struct IngresoPorCategoria: Codable {
    let categoria: String
    let cantidad: Int
    let total: Double
}

struct IngresoPorMes: Codable {
    let mes: String
    let total: Double
}

struct CreateResenaResponse: Codable {
    let success: Bool
    let message: String
    let resena: Resena
}

struct ResenasProfesionalResponse: Codable {
    let success: Bool
    let resenas: [Resena]
    let estadisticas: ResenaEstadisticas
}

struct ResenaEstadisticas: Codable {
    let totalResenas: Int
    let calificacionPromedio: Double

    enum CodingKeys: String, CodingKey {
        case totalResenas = "totalResenas"
        case calificacionPromedio = "calificacionPromedio"
    }
}

struct ResenaResponse: Codable {
    let success: Bool
    let resena: Resena?
    let message: String?
}
