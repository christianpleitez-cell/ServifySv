import UIKit

class ChatViewController: UIViewController {

    // MARK: - Properties
    private var chat: Chat

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
        scrollToBottom()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = chat.solicitud.profesional.usuario.nombre

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
        guard !chat.mensajes.isEmpty else { return }
        let indexPath = IndexPath(row: chat.mensajes.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }

    // MARK: - Actions
    @objc private func sendTapped() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        let nuevoMensaje = Mensaje(
            id: chat.mensajes.count + 1,
            idChat: chat.id,
            remitente: MockData.usuarioActual,
            contenido: text,
            fechaEnvio: Date(),
            esPropio: true
        )
        chat.mensajes.append(nuevoMensaje)
        messageTextField.text = ""
        tableView.reloadData()
        scrollToBottom()
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
        chat.mensajes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mensaje = chat.mensajes[indexPath.row]
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


// MARK: - ChatsListViewController
class ChatsListViewController: UIViewController {

    private var chats: [Chat] = MockData.chats

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .singleLine
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Mensajes"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.identifier)
    }
}

extension ChatsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.identifier, for: indexPath) as! ChatListCell
        cell.configure(with: chats[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = ChatViewController(chat: chats[indexPath.row])
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
