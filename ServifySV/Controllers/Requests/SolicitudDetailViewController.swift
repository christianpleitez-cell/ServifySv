import UIKit

class SolicitudDetailViewController: UIViewController {

    // MARK: - Properties
    private var solicitud: Solicitud
    private var mensajes: [Mensaje] = []

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

    private let acceptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Aceptar", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let rejectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Rechazar", for: .normal)
        btn.backgroundColor = .systemRed
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let completarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Completar", for: .normal)
        btn.backgroundColor = .systemIndigo
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 8
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
        title = ""
        navigationController?.navigationBar.isHidden = true

        headerView.backgroundColor = UIColor.systemGray5
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

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

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)

        let isProfessional = AuthManager.shared.isProfessional
        let isPending = solicitud.estado == "pendiente"
        let isAceptada = solicitud.estado == "aceptada"

        if isProfessional && isPending {
            headerView.addSubview(acceptButton)
            headerView.addSubview(rejectButton)
        }

        if isProfessional && isAceptada {
            headerView.addSubview(completarButton)
        }

        view.addSubview(messagesTableView)
        view.addSubview(messageInputContainer)

        messageInputContainer.addSubview(messageTextField)
        messageInputContainer.addSubview(sendButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),

            avatarView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            avatarView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            clienteLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            clienteLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -12),

            servicioLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            servicioLabel.topAnchor.constraint(equalTo: clienteLabel.bottomAnchor, constant: 2),

            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
        ])

        if isProfessional && isPending {
            NSLayoutConstraint.activate([
                acceptButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
                acceptButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
                acceptButton.widthAnchor.constraint(equalToConstant: 80),
                acceptButton.heightAnchor.constraint(equalToConstant: 32),

                rejectButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
                rejectButton.leadingAnchor.constraint(equalTo: acceptButton.trailingAnchor, constant: 8),
                rejectButton.widthAnchor.constraint(equalToConstant: 80),
                rejectButton.heightAnchor.constraint(equalToConstant: 32),
            ])
        }

        if isProfessional && isAceptada {
            NSLayoutConstraint.activate([
                completarButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
                completarButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
                completarButton.widthAnchor.constraint(equalToConstant: 110),
                completarButton.heightAnchor.constraint(equalToConstant: 32),
            ])
        }

        NSLayoutConstraint.activate([
            messagesTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor),

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
        servicioLabel.text = solicitud.servicio?.nombreServicio ?? ""

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
    }

    private func loadMensajes() {
        APIManager.shared.getMensajes(solicitudId: solicitud.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    let currentUserId = AuthManager.shared.currentUser?.id
                    self.mensajes = response.mensajes.map { mensaje in
                        var m = mensaje
                        m.esPropio = (mensaje.remitente?.id == currentUserId)
                        return m
                    }
                    self.messagesTableView.reloadData()
                    if !self.mensajes.isEmpty {
                        self.messagesTableView.scrollToRow(
                            at: IndexPath(row: self.mensajes.count - 1, section: 0),
                            at: .bottom, animated: false
                        )
                    }
                case .failure:
                    break
                }
            }
        }
    }

    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sendTapped() {
        guard let text = messageTextField.text, !text.isEmpty,
              let userId = AuthManager.shared.currentUser?.id else { return }

        messageTextField.text = ""
        sendButton.isEnabled = false

        APIManager.shared.sendMensaje(solicitudId: solicitud.id, remitenteId: userId, contenido: text) { [weak self] result in
            DispatchQueue.main.async {
                self?.sendButton.isEnabled = true
                switch result {
                case .success:
                    self?.loadMensajes()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
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

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SolicitudDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mensajes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "messageCell")
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let mensaje = mensajes[indexPath.row]
        let esPropio = mensaje.esPropio

        let bubbleView = UIView()
        bubbleView.backgroundColor = esPropio ? .systemBlue : UIColor(white: 0.95, alpha: 1)
        bubbleView.layer.cornerRadius = 12
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(bubbleView)

        let textLabel = UILabel()
        textLabel.text = mensaje.contenido
        textLabel.textColor = esPropio ? .white : .label
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(textLabel)

        let horaLabel = UILabel()
        horaLabel.text = mensaje.fechaEnvio ?? ""
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
