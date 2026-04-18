import UIKit

class SolicitudDetailViewController: UIViewController {

    // MARK: - Properties
    private var solicitud: Solicitud
    private var mensajes: [(autor: String, contenido: String, hora: String, esCliente: Bool)] = []

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
        loadMockMessages()
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

        let initials = solicitud.cliente.nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(1))
        clienteLabel.text = solicitud.cliente.nombre
        servicioLabel.text = solicitud.servicio.nombreServicio

        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "messageCell")

        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }

    private func loadMockMessages() {
        mensajes = [
            (autor: "Cliente", contenido: "Hola, ¿podrías venir a ver la habitación mañana?", hora: "10:30 a.m.", esCliente: true),
            (autor: "Profesional", contenido: "Claro, ¿te parece bien a las 2pm?", hora: "10:45 a.m.", esCliente: false),
            (autor: "Cliente", contenido: "Perfecto, te espero entonces", hora: "10:50 a.m.", esCliente: true),
        ]
        messagesTableView.reloadData()
    }

    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sendTapped() {
        if let text = messageTextField.text, !text.isEmpty {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let hora = formatter.string(from: Date())
            mensajes.append((autor: "Cliente", contenido: text, hora: hora, esCliente: true))
            messageTextField.text = ""
            messagesTableView.reloadData()
            messagesTableView.scrollToRow(at: IndexPath(row: mensajes.count - 1, section: 0), at: .bottom, animated: true)
        }
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

        let bubbleView = UIView()
        bubbleView.backgroundColor = mensaje.esCliente ? .systemBlue : UIColor(white: 0.95, alpha: 1)
        bubbleView.layer.cornerRadius = 12
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(bubbleView)

        let textLabel = UILabel()
        textLabel.text = mensaje.contenido
        textLabel.textColor = mensaje.esCliente ? .white : .label
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(textLabel)

        let horaLabel = UILabel()
        horaLabel.text = mensaje.hora
        horaLabel.textColor = mensaje.esCliente ? .white.withAlphaComponent(0.7) : .systemGray
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

        if mensaje.esCliente {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Detalle de Solicitud"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let sections = [profesionalSection, servicioSection, descripcionSection, fechaSection, calificacionSection]
        sections.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        [estadoBadge, profesionalSection, servicioSection, descripcionSection,
         fechaSection, calificacionSection, chatButton, calificarButton].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            estadoBadge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            estadoBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            estadoBadge.widthAnchor.constraint(equalToConstant: 120),
            estadoBadge.heightAnchor.constraint(equalToConstant: 28),

            profesionalSection.topAnchor.constraint(equalTo: estadoBadge.bottomAnchor, constant: 20),
            profesionalSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profesionalSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            servicioSection.topAnchor.constraint(equalTo: profesionalSection.bottomAnchor, constant: 12),
            servicioSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            servicioSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descripcionSection.topAnchor.constraint(equalTo: servicioSection.bottomAnchor, constant: 12),
            descripcionSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descripcionSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            fechaSection.topAnchor.constraint(equalTo: descripcionSection.bottomAnchor, constant: 12),
            fechaSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fechaSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            calificacionSection.topAnchor.constraint(equalTo: fechaSection.bottomAnchor, constant: 12),
            calificacionSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            calificacionSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            chatButton.topAnchor.constraint(equalTo: calificacionSection.bottomAnchor, constant: 28),
            chatButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            chatButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chatButton.heightAnchor.constraint(equalToConstant: 50),

            calificarButton.topAnchor.constraint(equalTo: chatButton.bottomAnchor, constant: 12),
            calificarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            calificarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            calificarButton.heightAnchor.constraint(equalToConstant: 50),
            calificarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])

        chatButton.addTarget(self, action: #selector(chatTapped), for: .touchUpInside)
        calificarButton.addTarget(self, action: #selector(calificarTapped), for: .touchUpInside)
    }

    private func configure() {
        estadoBadge.text = " \(solicitud.estado.rawValue) "
        estadoBadge.backgroundColor = colorForEstado(solicitud.estado)

        profesionalSection.setValue(solicitud.profesional.usuario.nombre + " – " + solicitud.profesional.especialidad)
        servicioSection.setValue(solicitud.servicio.nombreServicio + " ($\(String(format: "%.2f", solicitud.servicio.precioReferencia)))")
        descripcionSection.setValue(solicitud.descripcion)

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        fechaSection.setValue(formatter.string(from: solicitud.fechaSolicitud))

        if let cal = solicitud.calificacion {
            let stars = String(repeating: "★", count: cal.puntuacion) + String(repeating: "☆", count: 5 - cal.puntuacion)
            calificacionSection.setValue("\(stars)\n\"\(cal.comentario)\"")
        } else {
            calificacionSection.setValue("Sin calificación aún")
        }

        calificarButton.isHidden = !(solicitud.estado == .completada && solicitud.calificacion == nil)
    }

    private func colorForEstado(_ estado: EstadoSolicitud) -> UIColor {
        switch estado {
        case .pendiente: return .systemOrange
        case .aceptada: return .systemBlue
        case .enProgreso: return .systemPurple
        case .completada: return .systemGreen
        case .cancelada: return .systemRed
        }
    }

    // MARK: - Actions
    @objc private func chatTapped() {
        if let chat = MockData.chats.first(where: { $0.solicitud.id == solicitud.id }) {
            let chatVC = ChatViewController(chat: chat)
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }

    @objc private func calificarTapped() {
        let calVC = CalificarViewController(solicitud: solicitud)
        navigationController?.pushViewController(calVC, animated: true)
    }
}
