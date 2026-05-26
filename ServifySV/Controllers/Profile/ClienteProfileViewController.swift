import UIKit

class ClienteProfileViewController: UIViewController {

    // MARK: - Properties
    private var usuario: User?
    private var telefono: String = ""
    private var ubicacion: String = ""

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 60
        v.layer.borderWidth = 4
        v.layer.borderColor = UIColor.white.cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 48)
        l.textColor = .systemBlue
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let cameraButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemBlue
        btn.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let nombreLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let tipoLabel: UILabel = {
        let l = UILabel()
        l.text = "Cliente"
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = .systemBlue
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let contactoTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Información de Contacto"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let contactoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let editarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 14
        btn.layer.shadowColor = UIColor.systemBlue.cgColor
        btn.layer.shadowOpacity = 0.35
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let editarTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Editar Perfil"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textColor = .white
        l.isUserInteractionEnabled = false
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let configuracionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 14
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.07
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 12
        config.image = UIImage(systemName: "power")
        btn.setAttributedTitle(NSAttributedString(string: "Cerrar Sesión", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.systemRed]), for: .normal)
        btn.configuration = config
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        configure()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        headerView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        view.addSubview(cameraButton)

        contentView.addSubview(nombreLabel)
        contentView.addSubview(tipoLabel)
        contentView.addSubview(contactoTitleLabel)
        contentView.addSubview(contactoStackView)
        contentView.addSubview(editarButton)
        contentView.addSubview(configuracionButton)
        contentView.addSubview(logoutButton)

        view.insertSubview(headerView, belowSubview: scrollView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            avatarView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            avatarView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 120),
            avatarView.heightAnchor.constraint(equalToConstant: 120),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            cameraButton.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 4),
            cameraButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 4),
            cameraButton.widthAnchor.constraint(equalToConstant: 28),
            cameraButton.heightAnchor.constraint(equalToConstant: 28),

            nombreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 150),
            nombreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nombreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            tipoLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 4),
            tipoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            contactoTitleLabel.topAnchor.constraint(equalTo: tipoLabel.bottomAnchor, constant: 20),
            contactoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            contactoStackView.topAnchor.constraint(equalTo: contactoTitleLabel.bottomAnchor, constant: 12),
            contactoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contactoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            editarButton.topAnchor.constraint(equalTo: contactoStackView.bottomAnchor, constant: 20),
            editarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            editarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editarButton.heightAnchor.constraint(equalToConstant: 50),

            configuracionButton.topAnchor.constraint(equalTo: editarButton.bottomAnchor, constant: 16),
            configuracionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            configuracionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            configuracionButton.heightAnchor.constraint(equalToConstant: 54),

            logoutButton.topAnchor.constraint(equalTo: configuracionButton.bottomAnchor, constant: 4),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])

        // Contenido del botón Editar Perfil
        let pencilIcon = UIImageView(image: UIImage(systemName: "pencil"))
        pencilIcon.tintColor = .white
        pencilIcon.contentMode = .scaleAspectFit
        pencilIcon.isUserInteractionEnabled = false
        pencilIcon.translatesAutoresizingMaskIntoConstraints = false

        let editarStack = UIStackView(arrangedSubviews: [pencilIcon, editarTitleLabel])
        editarStack.axis = .horizontal
        editarStack.spacing = 10
        editarStack.alignment = .center
        editarStack.isUserInteractionEnabled = false
        editarStack.translatesAutoresizingMaskIntoConstraints = false

        editarButton.addSubview(editarStack)
        NSLayoutConstraint.activate([
            editarStack.centerXAnchor.constraint(equalTo: editarButton.centerXAnchor),
            editarStack.centerYAnchor.constraint(equalTo: editarButton.centerYAnchor),
            pencilIcon.widthAnchor.constraint(equalToConstant: 18),
            pencilIcon.heightAnchor.constraint(equalToConstant: 18),
        ])

        // Subviews del botón configuración
        let gearContainer = UIView()
        gearContainer.backgroundColor = UIColor.systemGray5
        gearContainer.layer.cornerRadius = 8
        gearContainer.isUserInteractionEnabled = false
        gearContainer.translatesAutoresizingMaskIntoConstraints = false

        let gearIcon = UIImageView(image: UIImage(systemName: "gearshape.fill"))
        gearIcon.tintColor = .systemGray
        gearIcon.contentMode = .scaleAspectFit
        gearIcon.isUserInteractionEnabled = false
        gearIcon.translatesAutoresizingMaskIntoConstraints = false
        gearContainer.addSubview(gearIcon)

        let configTitleLabel = UILabel()
        configTitleLabel.text = "Configuración"
        configTitleLabel.font = UIFont.systemFont(ofSize: 16)
        configTitleLabel.textColor = .label
        configTitleLabel.isUserInteractionEnabled = false
        configTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let chevronIcon = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronIcon.tintColor = .systemGray3
        chevronIcon.contentMode = .scaleAspectFit
        chevronIcon.isUserInteractionEnabled = false
        chevronIcon.translatesAutoresizingMaskIntoConstraints = false

        configuracionButton.addSubview(gearContainer)
        configuracionButton.addSubview(configTitleLabel)
        configuracionButton.addSubview(chevronIcon)

        NSLayoutConstraint.activate([
            gearContainer.leadingAnchor.constraint(equalTo: configuracionButton.leadingAnchor, constant: 16),
            gearContainer.centerYAnchor.constraint(equalTo: configuracionButton.centerYAnchor),
            gearContainer.widthAnchor.constraint(equalToConstant: 34),
            gearContainer.heightAnchor.constraint(equalToConstant: 34),

            gearIcon.centerXAnchor.constraint(equalTo: gearContainer.centerXAnchor),
            gearIcon.centerYAnchor.constraint(equalTo: gearContainer.centerYAnchor),
            gearIcon.widthAnchor.constraint(equalToConstant: 20),
            gearIcon.heightAnchor.constraint(equalToConstant: 20),

            configTitleLabel.leadingAnchor.constraint(equalTo: gearContainer.trailingAnchor, constant: 14),
            configTitleLabel.centerYAnchor.constraint(equalTo: configuracionButton.centerYAnchor),

            chevronIcon.trailingAnchor.constraint(equalTo: configuracionButton.trailingAnchor, constant: -16),
            chevronIcon.centerYAnchor.constraint(equalTo: configuracionButton.centerYAnchor),
            chevronIcon.widthAnchor.constraint(equalToConstant: 10),
            chevronIcon.heightAnchor.constraint(equalToConstant: 16),
        ])

        editarButton.addTarget(self, action: #selector(editarTapped), for: .touchUpInside)
        configuracionButton.addTarget(self, action: #selector(configuracionTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        for btn in [editarButton, configuracionButton] {
            btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
            btn.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
    }

    private func configure() {
        guard let currentUser = AuthManager.shared.currentUser else { return }

        let initials = currentUser.nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel.text = currentUser.nombre

        contactoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        addContactoItems()
    }

    private func addContactoItems() {
        let items = [
            ("📞", telefono),
            ("📧", AuthManager.shared.currentUser?.correo ?? ""),
            ("📍", ubicacion)
        ]

        for (icon, text) in items {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .label
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: icon + " "))
            attributedString.append(NSAttributedString(string: text, attributes: [.foregroundColor: UIColor.systemGray2]))
            label.attributedText = attributedString
            contactoStackView.addArrangedSubview(label)
        }
    }

    // MARK: - Actions
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }

    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: []) {
            sender.transform = .identity
        }
    }

    @objc private func configuracionTapped() {
        let alert = UIAlertController(title: "Configuración", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Notificaciones", style: .default))
        alert.addAction(UIAlertAction(title: "Privacidad", style: .default))
        alert.addAction(UIAlertAction(title: "Acerca de Servify", style: .default))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func editarTapped() {
        presentEditModal()
    }

    @objc private func logoutTapped() {
        AuthManager.shared.clearSession()
        navigationController?.popToRootViewController(animated: false)
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }

    private func presentEditModal() {
        guard let currentUser = AuthManager.shared.currentUser else { return }

        let alert = UIAlertController(title: "Editar Perfil", message: nil, preferredStyle: .alert)
        alert.view.tintColor = .systemBlue

        alert.addTextField { field in
            field.placeholder = "Nombre"
            field.text = currentUser.nombre
        }

        alert.addTextField { field in
            field.placeholder = "Teléfono"
            field.text = ""
        }

        alert.addTextField { field in
            field.placeholder = "Ubicación"
            field.text = ""
        }

        alert.addAction(UIAlertAction(title: "Guardar Cambios", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let nombre = alert.textFields?[0].text, !nombre.isEmpty else {
                self.showAlert(title: "Error", message: "El nombre no puede estar vacío")
                return
            }

            let telefono = alert.textFields?[1].text ?? ""
            let ubicacion = alert.textFields?[2].text ?? ""

            self.editarButton.isEnabled = false
            self.editarTitleLabel.text = "Guardando..."

            APIManager.shared.updatePerfil(userId: currentUser.userId ?? 0, nombre: nombre, telefono: telefono.isEmpty ? nil : telefono, correo: nil) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.editarButton.isEnabled = true
                    self.editarTitleLabel.text = "Editar Perfil"

                    switch result {
                    case .success:
                        self.configure()
                        self.showAlert(title: "Éxito", message: "Perfil actualizado correctamente")

                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        })

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

        present(alert, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
