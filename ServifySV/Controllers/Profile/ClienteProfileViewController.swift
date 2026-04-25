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
        btn.setTitle("Editar Perfil", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 24
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let configuracionButton: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 12
        config.image = UIImage(systemName: "gearshape")
        btn.setAttributedTitle(NSAttributedString(string: "Configuración", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.label]), for: .normal)
        btn.configuration = config
        btn.contentHorizontalAlignment = .left
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

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

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

            nombreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
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

            configuracionButton.topAnchor.constraint(equalTo: editarButton.bottomAnchor, constant: 12),
            configuracionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            configuracionButton.heightAnchor.constraint(equalToConstant: 44),

            logoutButton.topAnchor.constraint(equalTo: configuracionButton.bottomAnchor, constant: 4),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])

        editarButton.addTarget(self, action: #selector(editarTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
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
            let originalTitle = self.editarButton.title(for: .normal)
            self.editarButton.setTitle("Guardando...", for: .normal)

            APIManager.shared.updatePerfil(userId: currentUser.id, nombre: nombre, telefono: telefono.isEmpty ? nil : telefono, correo: nil) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.editarButton.isEnabled = true
                    self.editarButton.setTitle(originalTitle, for: .normal)

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
