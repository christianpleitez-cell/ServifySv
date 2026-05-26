import UIKit
import FirebaseDatabase

class SolicitudDetailViewController: UIViewController {

    // MARK: - Properties
    private var solicitud: Solicitud
    private var mensajesData: [[String: Any]] = []
    private var firebaseHandle: DatabaseHandle?

    // MARK: - UI Components
    private let headerView = UIView()
    private let avatarLabel = UILabel()
    private let clienteLabel = UILabel()
    private let servicioLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    private let messagesTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .systemGroupedBackground
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let messageInputContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Escribe un mensaje..."
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Enviar", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let actionsContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let acceptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Aceptar", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let rejectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Rechazar", for: .normal)
        btn.backgroundColor = .systemRed
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let completarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Marcar como completado", for: .normal)
        btn.backgroundColor = .systemIndigo
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let calificarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Calificar Servicio", for: .normal)
        btn.backgroundColor = .systemYellow
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init
    init(solicitud: Solicitud) {
        self.solicitud = solicitud
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMensajes()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        navigationController?.navigationBar.isHidden = true

        let isProfessional = AuthManager.shared.isProfessional
        let isPending = solicitud.estado == "pendiente"
        let isAceptada = solicitud.estado == "aceptada"
        let isCompletada = solicitud.estado == "completada"

        // MARK: Header
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.06
        headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerView.layer.shadowRadius = 4
        view.addSubview(headerView)

        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        closeButton.tintColor = .systemBlue
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)

        let avatarView = UIView()
        avatarView.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        avatarView.layer.cornerRadius = 20
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(avatarView)

        avatarLabel.font = UIFont.boldSystemFont(ofSize: 16)
        avatarLabel.textColor = .systemBlue
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addSubview(avatarLabel)

        clienteLabel.font = UIFont.boldSystemFont(ofSize: 16)
        clienteLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(clienteLabel)

        servicioLabel.font = UIFont.systemFont(ofSize: 13)
        servicioLabel.textColor = .systemGray
        servicioLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(servicioLabel)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 90),

            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            avatarView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            avatarView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            clienteLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            clienteLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),

            servicioLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            servicioLabel.topAnchor.constraint(equalTo: clienteLabel.bottomAnchor, constant: 2),
        ])

        // MARK: Messages
        view.addSubview(messagesTableView)

        // MARK: Actions container (entre mensajes e input)
        view.addSubview(actionsContainer)

        if isProfessional && isPending {
            actionsContainer.addSubview(acceptButton)
            actionsContainer.addSubview(rejectButton)
            NSLayoutConstraint.activate([
                acceptButton.topAnchor.constraint(equalTo: actionsContainer.topAnchor, constant: 10),
                acceptButton.leadingAnchor.constraint(equalTo: actionsContainer.leadingAnchor, constant: 16),
                acceptButton.bottomAnchor.constraint(equalTo: actionsContainer.bottomAnchor, constant: -10),
                acceptButton.heightAnchor.constraint(equalToConstant: 44),

                rejectButton.topAnchor.constraint(equalTo: actionsContainer.topAnchor, constant: 10),
                rejectButton.leadingAnchor.constraint(equalTo: acceptButton.trailingAnchor, constant: 12),
                rejectButton.trailingAnchor.constraint(equalTo: actionsContainer.trailingAnchor, constant: -16),
                rejectButton.bottomAnchor.constraint(equalTo: actionsContainer.bottomAnchor, constant: -10),
                rejectButton.widthAnchor.constraint(equalTo: acceptButton.widthAnchor),
                rejectButton.heightAnchor.constraint(equalToConstant: 44),
            ])
        } else if isProfessional && isAceptada {
            actionsContainer.addSubview(completarButton)
            NSLayoutConstraint.activate([
                completarButton.topAnchor.constraint(equalTo: actionsContainer.topAnchor, constant: 10),
                completarButton.leadingAnchor.constraint(equalTo: actionsContainer.leadingAnchor, constant: 16),
                completarButton.trailingAnchor.constraint(equalTo: actionsContainer.trailingAnchor, constant: -16),
                completarButton.bottomAnchor.constraint(equalTo: actionsContainer.bottomAnchor, constant: -10),
                completarButton.heightAnchor.constraint(equalToConstant: 44),
            ])
        } else if !isProfessional && isCompletada {
            actionsContainer.addSubview(calificarButton)
            NSLayoutConstraint.activate([
                calificarButton.topAnchor.constraint(equalTo: actionsContainer.topAnchor, constant: 10),
                calificarButton.leadingAnchor.constraint(equalTo: actionsContainer.leadingAnchor, constant: 16),
                calificarButton.trailingAnchor.constraint(equalTo: actionsContainer.trailingAnchor, constant: -16),
                calificarButton.bottomAnchor.constraint(equalTo: actionsContainer.bottomAnchor, constant: -10),
                calificarButton.heightAnchor.constraint(equalToConstant: 44),
            ])
        }

        let actionsHeight: CGFloat
        if isProfessional && (isPending || isAceptada) {
            actionsHeight = 64
        } else if !isProfessional && isCompletada {
            actionsHeight = 64
        } else {
            actionsHeight = 0
        }

        // MARK: Input
        view.addSubview(messageInputContainer)
        messageInputContainer.addSubview(messageTextField)
        messageInputContainer.addSubview(sendButton)

        NSLayoutConstraint.activate([
            messagesTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: actionsContainer.topAnchor),

            actionsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionsContainer.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor),
            actionsContainer.heightAnchor.constraint(equalToConstant: actionsHeight),

            messageInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageInputContainer.heightAnchor.constraint(equalToConstant: 60),

            messageTextField.leadingAnchor.constraint(equalTo: messageInputContainer.leadingAnchor, constant: 12),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),

            sendButton.trailingAnchor.constraint(equalTo: messageInputContainer.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 70),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
        ])

        let nombre = solicitud.cliente?.nombre ?? ""
        let initials = nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(1))
        clienteLabel.text = nombre
        servicioLabel.text = solicitud.servicio?.nombreServicio ?? solicitud.descripcion

        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "messageCell")

        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        if isProfessional && isPending {
            acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
            rejectButton.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)
        }
        if isProfessional && isAceptada {
            completarButton.addTarget(self, action: #selector(completarTapped), for: .touchUpInside)
        }
        if !isProfessional && isCompletada {
            calificarButton.addTarget(self, action: #selector(calificarTapped), for: .touchUpInside)
        }
    }

    private func loadMensajes() {
        firebaseHandle = FirebaseManager.shared.observeMensajes(idSolicitud: solicitud.id) { [weak self] data in
            guard let self = self else { return }
            self.mensajesData = data
            self.messagesTableView.reloadData()
            if !self.mensajesData.isEmpty {
                self.messagesTableView.scrollToRow(
                    at: IndexPath(row: self.mensajesData.count - 1, section: 0),
                    at: .bottom, animated: false
                )
            }
        }
    }

    deinit {
        if let handle = firebaseHandle {
            FirebaseManager.shared.removeObserver(idSolicitud: solicitud.id, handle: handle)
        }
    }

    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sendTapped() {
        guard let text = messageTextField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty,
              let currentUser = AuthManager.shared.currentUser,
              let userId = currentUser.userId else { return }

        messageTextField.text = ""
        FirebaseManager.shared.sendMensaje(
            idSolicitud: solicitud.id,
            idRemitente: userId,
            nombreRemitente: currentUser.nombre,
            contenido: text
        )
    }

    @objc private func acceptTapped() {
        acceptButton.isEnabled = false
        let originalTitle = acceptButton.title(for: .normal)
        acceptButton.setTitle("Aceptando...", for: .normal)

        APIManager.shared.updateSolicitudEstado(solicitudId: solicitud.id, estado: "aceptada") { [weak self] result in
            DispatchQueue.main.async {
                self?.acceptButton.isEnabled = true
                self?.acceptButton.setTitle(originalTitle, for: .normal)

                switch result {
                case .success:
                    self?.showAlert(title: "Éxito", message: "Solicitud aceptada")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.navigationController?.popViewController(animated: true)
                    }

                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    @objc private func rejectTapped() {
        rejectButton.isEnabled = false
        let originalTitle = rejectButton.title(for: .normal)
        rejectButton.setTitle("Rechazando...", for: .normal)

        APIManager.shared.updateSolicitudEstado(solicitudId: solicitud.id, estado: "cancelada") { [weak self] result in
            DispatchQueue.main.async {
                self?.rejectButton.isEnabled = true
                self?.rejectButton.setTitle(originalTitle, for: .normal)

                switch result {
                case .success:
                    self?.showAlert(title: "Éxito", message: "Solicitud rechazada")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.navigationController?.popViewController(animated: true)
                    }

                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    @objc private func completarTapped() {
        let confirm = UIAlertController(
            title: "Completar trabajo",
            message: "¿Confirmas que el trabajo ha sido completado?",
            preferredStyle: .alert
        )
        confirm.addAction(UIAlertAction(title: "Sí, completar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.completarButton.isEnabled = false
            self.completarButton.setTitle("Completando...", for: .normal)

            APIManager.shared.updateSolicitudEstado(solicitudId: self.solicitud.id, estado: "completada") { [weak self] result in
                DispatchQueue.main.async {
                    self?.completarButton.isEnabled = true
                    self?.completarButton.setTitle("Completar", for: .normal)

                    switch result {
                    case .success:
                        self?.showAlert(title: "¡Trabajo completado!", message: "La solicitud ha sido marcada como completada.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        })
        confirm.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(confirm, animated: true)
    }

    @objc private func calificarTapped() {
        calificarButton.isEnabled = false
        APIManager.shared.getResenaBySolicitud(solicitudId: solicitud.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.calificarButton.isEnabled = true
                let vc: CalificarViewController
                if case .success(let response) = result, let resena = response.resena {
                    vc = CalificarViewController(solicitud: self.solicitud, resena: resena)
                } else {
                    vc = CalificarViewController(solicitud: self.solicitud)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func formatTimestamp(_ value: Any?) -> String {
        guard let ts = value as? Double else { return "" }
        let date = Date(timeIntervalSince1970: ts / 1000)
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}

extension SolicitudDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mensajesData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "messageCell")
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let data = mensajesData[indexPath.row]
        let currentUserId = AuthManager.shared.currentUser?.userId
        let esPropio = (data["idRemitente"] as? Int) == currentUserId

        let bubbleView = UIView()
        bubbleView.backgroundColor = esPropio ? .systemBlue : UIColor(white: 0.95, alpha: 1)
        bubbleView.layer.cornerRadius = 12
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(bubbleView)

        let textLabel = UILabel()
        textLabel.text = data["contenido"] as? String ?? ""
        textLabel.textColor = esPropio ? .white : .label
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(textLabel)

        let horaLabel = UILabel()
        horaLabel.text = formatTimestamp(data["fechaEnvio"])
        horaLabel.textColor = esPropio ? .white.withAlphaComponent(0.7) : .systemGray
        horaLabel.font = UIFont.systemFont(ofSize: 12)
        horaLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(horaLabel)

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),

            horaLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4),
            horaLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            horaLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
        ])

        if esPropio {
            NSLayoutConstraint.activate([
                bubbleView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: cell.contentView.leadingAnchor, constant: 60),
            ])
        } else {
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor, constant: -60),
            ])
        }

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
