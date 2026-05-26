import Foundation
import FirebaseDatabase

final class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Database.database().reference()

    private init() {}

    func sendMensaje(idSolicitud: Int, idRemitente: Int, nombreRemitente: String, contenido: String) {
        let data: [String: Any] = [
            "contenido": contenido,
            "idRemitente": idRemitente,
            "nombreRemitente": nombreRemitente,
            "fechaEnvio": ServerValue.timestamp()
        ]
        db.child("chats").child("\(idSolicitud)").childByAutoId().setValue(data)
    }

    func observeMensajes(idSolicitud: Int, onChange: @escaping ([[String: Any]]) -> Void) -> DatabaseHandle {
        db.child("chats").child("\(idSolicitud)").observe(.value) { snapshot in
            var mensajes: [[String: Any]] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = snap.value as? [String: Any] {
                    mensajes.append(data)
                }
            }
            mensajes.sort {
                ($0["fechaEnvio"] as? Double ?? 0) < ($1["fechaEnvio"] as? Double ?? 0)
            }
            onChange(mensajes)
        }
    }

    func removeObserver(idSolicitud: Int, handle: DatabaseHandle) {
        db.child("chats").child("\(idSolicitud)").removeObserver(withHandle: handle)
    }
}
