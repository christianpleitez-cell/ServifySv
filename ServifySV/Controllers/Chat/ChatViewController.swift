import UIKit

class ChatViewController: UIViewController {

    // MARK: - Properties
    private var chat: Chat
    private var mensajes: [Mensaje] = []

    // MARK: - UI Components
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .systemGroupedBackground
        tv.keyboardDismissMode = .interactive
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let messageContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.borderColor = UIColor.separator.cgColor
        v.layer.borderWidth = 0.5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Escribe un mensaje..."
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        btn.tintColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private var messageContainerBottomConstraint: NSLayoutConstraint!

    // MARK: - Init
    init(chat: Chat) {
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        loadMensajes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMensajes()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = chat.solicitud?.profesional?.usuario?.nombre ?? "Chat"

        messageContainerView.addSubview(messageTextField)
        messageContainerView.addSubview(sendButton)
        view.addSubview(tableView)
        view.addSubview(messageContainerView)

        messageContainerBottomConstraint = messageContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            messageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageContainerBottomConstraint,
            messageContainerView.heightAnchor.constraint(equalToConstant: 60),

            messageTextField.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 12),
            messageTextField.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),

            sendButton.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageContainerView.topAnchor),
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MensajeCell.self, forCellReuseIdentifier: MensajeCell.identifier)
        tableView.register(MensajeRecibidoCell.self, forCellReuseIdentifier: MensajeRecibidoCell.identifier)

        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func scrollToBottom() {
        guard !mensajes.isEmpty else { return }
        let indexPath = IndexPath(row: mensajes.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }

    private func loadMensajes() {
        guard let solicitudId = chat.solicitud?.id else { return }
        APIManager.shared.getMensajes(solicitudId: solicitudId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.mensajes = response.mensajes
                    self?.tableView.reloadData()
                    self?.scrollToBottom()
                case .failure:
                    self?.mensajes = []
                    self?.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func sendTapped() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        guard let remitenteId = AuthManager.shared.currentUser?.id else { return }

        sendButton.isEnabled = false

        guard let solicitudId = chat.solicitud?.id else { return }
        APIManager.shared.sendMensaje(
            solicitudId: solicitudId,
            remitenteId: remitenteId,
            contenido: text
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.sendButton.isEnabled = true

                switch result {
                case .success:
                    self?.messageTextField.text = ""
                    self?.loadMensajes()

                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            messageContainerBottomConstraint.constant = -keyboardFrame.height + view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        messageContainerBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mensajes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mensaje = mensajes[indexPath.row]
        if mensaje.esPropio {
            let cell = tableView.dequeueReusableCell(withIdentifier: MensajeCell.identifier, for: indexPath) as! MensajeCell
            cell.configure(with: mensaje)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MensajeRecibidoCell.identifier, for: indexPath) as! MensajeRecibidoCell
            cell.configure(with: mensaje)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
