import UIKit

class ProfesionalProfileViewController: UIViewController {

    private var profesional: Profesional?
    private var editarButton: UIButton!
    private var editarTitleLabel: UILabel!
    private var nombreLabel: UILabel!
    private var ratingLabel: UILabel!
    private var statsStack: UIStackView!
    private var contentStackLabels: [UILabel] = []
    private var resenasStack: UIStackView?
    private var trabajosCardValueLabel: UILabel?
    private var ingresosCardValueLabel: UILabel?

    private let headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 50
        v.layer.borderWidth = 4
        v.layer.borderColor = UIColor.white.cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarLabel: UILabel = {
        let l = UILabel()
        l.text = "JP"
        l.font = UIFont.boldSystemFont(ofSize: 40)
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

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        loadProfesionalData()
        loadReseñas()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    private func loadProfesionalData() {
        guard let currentUser = AuthManager.shared.currentUser else { return }
        let profesionalId = currentUser.id_profesional ?? 0

        APIManager.shared.getProfesional(id: profesionalId) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let response) = result {
                    self?.profesional = response.profesional
                    self?.updateUI()
                }
            }
        }

        APIManager.shared.getSolicitudesProfesional(profesionalId: profesionalId) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let response) = result {
                    let completadas = response.solicitudes.filter { $0.estado == "completada" }
                    let total = completadas.reduce(0.0) { $0 + ($1.servicio?.precioReferencia ?? 0) }
                    self?.trabajosCardValueLabel?.text = "\(completadas.count)"
                    self?.ingresosCardValueLabel?.text = String(format: "$%.0f", total)
                }
            }
        }
    }

    private func updateUI() {
        guard let profesional = profesional else { return }

        let nombre = profesional.usuario?.nombre ?? ""
        let initials = nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel?.text = nombre
        let rating = profesional.calificacionPromedio ?? 0.0
        let trabajos = profesional.totalCalificaciones ?? 0
        ratingLabel?.text = "⭐ \(String(format: "%.1f", rating)) · \(trabajos) trabajos"

        let ubicacion = profesional.usuario?.ubicacion ?? "No especificada"
        let telefono = profesional.usuario?.telefono ?? "No especificado"

        for label in contentStackLabels {
            switch label.tag {
            case 1001:
                label.text = "📞 \(telefono)"
            case 1002:
                label.text = "📧 \(profesional.usuario?.correo ?? "")"
            case 1003:
                label.text = "📍 \(ubicacion)"
            case 1004:
                label.text = profesional.biografia?.isEmpty == false ? profesional.biografia : "—"
            default:
                break
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // headerView above scrollView so content scrolls behind it, not in front
        view.addSubview(headerView)
        headerView.isUserInteractionEnabled = false
        view.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        view.addSubview(cameraButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            avatarView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -50),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            cameraButton.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 4),
            cameraButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 4),
            cameraButton.widthAnchor.constraint(equalToConstant: 28),
            cameraButton.heightAnchor.constraint(equalToConstant: 28),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])

        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)

        setupContent()
    }

    @objc private func cameraButtonTapped() {
        let alert = UIAlertController(title: "Foto de perfil", message: "Selecciona una opción", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default) { [weak self] _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Galería", style: .default) { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    private func setupContent() {
        nombreLabel = UILabel()
        nombreLabel.text = ""
        nombreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nombreLabel.textAlignment = .center
        nombreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nombreLabel)

        let tipoLabel = UILabel()
        tipoLabel.text = "Profesional"
        tipoLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        tipoLabel.textColor = .systemBlue
        tipoLabel.textAlignment = .center
        tipoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tipoLabel)

        ratingLabel = UILabel()
        ratingLabel.text = "⭐ 0.0 · 0 trabajos"
        ratingLabel.font = UIFont.systemFont(ofSize: 13)
        ratingLabel.textColor = .systemGray
        ratingLabel.textAlignment = .center
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingLabel)

        // Cards de estadísticas
        statsStack = UIStackView()
        statsStack.axis = .horizontal
        statsStack.spacing = 16
        statsStack.distribution = .fillEqually
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsStack)

        let (trabajosCard, tvLabel) = createStatCard(icon: "👔", title: "Trabajos", value: "0")
        trabajosCardValueLabel = tvLabel
        let (ingresosCard, ivLabel) = createStatCard(icon: "$", title: "Ingresos", value: "$0")
        ingresosCardValueLabel = ivLabel

        statsStack.addArrangedSubview(trabajosCard)
        statsStack.addArrangedSubview(ingresosCard)

        // Información de Contacto
        let contactoTitle = UILabel()
        contactoTitle.text = "Información de Contacto"
        contactoTitle.font = UIFont.boldSystemFont(ofSize: 16)
        contactoTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactoTitle)

        let telefonoLabel = UILabel()
        telefonoLabel.text = "📞 —"
        telefonoLabel.font = UIFont.systemFont(ofSize: 13)
        telefonoLabel.translatesAutoresizingMaskIntoConstraints = false
        telefonoLabel.tag = 1001
        contentView.addSubview(telefonoLabel)
        contentStackLabels.append(telefonoLabel)

        let emailLabel = UILabel()
        emailLabel.text = "📧 —"
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.tag = 1002
        contentView.addSubview(emailLabel)
        contentStackLabels.append(emailLabel)

        let ubicacionLabel = UILabel()
        ubicacionLabel.text = "📍 —"
        ubicacionLabel.font = UIFont.systemFont(ofSize: 13)
        ubicacionLabel.translatesAutoresizingMaskIntoConstraints = false
        ubicacionLabel.tag = 1003
        contentView.addSubview(ubicacionLabel)
        contentStackLabels.append(ubicacionLabel)

        // Acerca de mí
        let acercaTitle = UILabel()
        acercaTitle.text = "Acerca de mí"
        acercaTitle.font = UIFont.boldSystemFont(ofSize: 16)
        acercaTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(acercaTitle)

        let acercaLabel = UILabel()
        acercaLabel.text = ""
        acercaLabel.font = UIFont.systemFont(ofSize: 13)
        acercaLabel.textColor = .label
        acercaLabel.numberOfLines = 0
        acercaLabel.translatesAutoresizingMaskIntoConstraints = false
        acercaLabel.tag = 1004
        contentView.addSubview(acercaLabel)
        contentStackLabels.append(acercaLabel)

        // Botón Editar
        editarButton = UIButton(type: .system)
        editarButton.backgroundColor = .systemBlue
        editarButton.layer.cornerRadius = 14
        editarButton.layer.shadowColor = UIColor.systemBlue.cgColor
        editarButton.layer.shadowOpacity = 0.35
        editarButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        editarButton.layer.shadowRadius = 10
        editarButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(editarButton)

        let pencilIcon = UIImageView(image: UIImage(systemName: "pencil"))
        pencilIcon.tintColor = .white
        pencilIcon.contentMode = .scaleAspectFit
        pencilIcon.isUserInteractionEnabled = false
        pencilIcon.translatesAutoresizingMaskIntoConstraints = false

        editarTitleLabel = UILabel()
        editarTitleLabel.text = "Editar Perfil"
        editarTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        editarTitleLabel.textColor = .white
        editarTitleLabel.isUserInteractionEnabled = false
        editarTitleLabel.translatesAutoresizingMaskIntoConstraints = false

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

        // Configuración
        let configButton = UIButton(type: .system)
        configButton.backgroundColor = .white
        configButton.layer.cornerRadius = 14
        configButton.layer.shadowColor = UIColor.black.cgColor
        configButton.layer.shadowOpacity = 0.07
        configButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        configButton.layer.shadowRadius = 6
        configButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(configButton)

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

        configButton.addSubview(gearContainer)
        configButton.addSubview(configTitleLabel)
        configButton.addSubview(chevronIcon)

        NSLayoutConstraint.activate([
            gearContainer.leadingAnchor.constraint(equalTo: configButton.leadingAnchor, constant: 16),
            gearContainer.centerYAnchor.constraint(equalTo: configButton.centerYAnchor),
            gearContainer.widthAnchor.constraint(equalToConstant: 34),
            gearContainer.heightAnchor.constraint(equalToConstant: 34),

            gearIcon.centerXAnchor.constraint(equalTo: gearContainer.centerXAnchor),
            gearIcon.centerYAnchor.constraint(equalTo: gearContainer.centerYAnchor),
            gearIcon.widthAnchor.constraint(equalToConstant: 20),
            gearIcon.heightAnchor.constraint(equalToConstant: 20),

            configTitleLabel.leadingAnchor.constraint(equalTo: gearContainer.trailingAnchor, constant: 14),
            configTitleLabel.centerYAnchor.constraint(equalTo: configButton.centerYAnchor),

            chevronIcon.trailingAnchor.constraint(equalTo: configButton.trailingAnchor, constant: -16),
            chevronIcon.centerYAnchor.constraint(equalTo: configButton.centerYAnchor),
            chevronIcon.widthAnchor.constraint(equalToConstant: 10),
            chevronIcon.heightAnchor.constraint(equalToConstant: 16),
        ])

        configButton.addTarget(self, action: #selector(configuracionTapped), for: .touchUpInside)

        // Cerrar Sesión
        let logoutButton = UIButton(type: .system)
        var logoutConfig = UIButton.Configuration.plain()
        logoutConfig.image = UIImage(systemName: "power")
        logoutConfig.imagePadding = 12
        logoutButton.setAttributedTitle(NSAttributedString(string: "Cerrar Sesión", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.systemRed]), for: .normal)
        logoutButton.configuration = logoutConfig
        logoutButton.contentHorizontalAlignment = .left
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoutButton)

        // Calificaciones y Reseñas
        let resenasTitle = UILabel()
        resenasTitle.text = "Calificaciones y Reseñas"
        resenasTitle.font = UIFont.boldSystemFont(ofSize: 16)
        resenasTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(resenasTitle)

        let rs = UIStackView()
        rs.axis = .vertical
        rs.spacing = 12
        rs.translatesAutoresizingMaskIntoConstraints = false
        resenasStack = rs
        let sinResenasLabel = UILabel()
        sinResenasLabel.text = "Sin reseñas aún"
        sinResenasLabel.font = UIFont.systemFont(ofSize: 14)
        sinResenasLabel.textColor = .secondaryLabel
        sinResenasLabel.textAlignment = .center
        rs.addArrangedSubview(sinResenasLabel)
        contentView.addSubview(rs)

        NSLayoutConstraint.activate([
            nombreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 245),
            nombreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nombreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            tipoLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 4),
            tipoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            ratingLabel.topAnchor.constraint(equalTo: tipoLabel.bottomAnchor, constant: 4),
            ratingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            statsStack.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            statsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statsStack.heightAnchor.constraint(equalToConstant: 90),

            contactoTitle.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 20),
            contactoTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            telefonoLabel.topAnchor.constraint(equalTo: contactoTitle.bottomAnchor, constant: 12),
            telefonoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            emailLabel.topAnchor.constraint(equalTo: telefonoLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            ubicacionLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            ubicacionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            acercaTitle.topAnchor.constraint(equalTo: ubicacionLabel.bottomAnchor, constant: 20),
            acercaTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            acercaLabel.topAnchor.constraint(equalTo: acercaTitle.bottomAnchor, constant: 8),
            acercaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            acercaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            resenasTitle.topAnchor.constraint(equalTo: acercaLabel.bottomAnchor, constant: 24),
            resenasTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            rs.topAnchor.constraint(equalTo: resenasTitle.bottomAnchor, constant: 12),
            rs.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rs.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            editarButton.topAnchor.constraint(equalTo: rs.bottomAnchor, constant: 20),
            editarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            editarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editarButton.heightAnchor.constraint(equalToConstant: 50),

            configButton.topAnchor.constraint(equalTo: editarButton.bottomAnchor, constant: 16),
            configButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            configButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            configButton.heightAnchor.constraint(equalToConstant: 54),

            logoutButton.topAnchor.constraint(equalTo: configButton.bottomAnchor, constant: 4),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])

        editarButton.addTarget(self, action: #selector(editarTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        configButton.addTarget(self, action: #selector(configuracionTapped), for: .touchUpInside)

        for btn in [editarButton!, configButton] {
            btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
            btn.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
    }

    private func createStatCard(icon: String, title: String, value: String) -> (UIView, UILabel) {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.1
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 6
        card.translatesAutoresizingMaskIntoConstraints = false

        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.textColor = .systemBlue
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(iconLabel)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .systemGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 18)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            iconLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),

            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),

            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
        ])

        return (card, valueLabel)
    }

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
        guard let profesional = profesional,
              let currentUser = AuthManager.shared.currentUser else { return }
        let vc = EditarPerfilProfesionalViewController(profesional: profesional, currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func logoutTapped() {
        AuthManager.shared.clearSession()
        navigationController?.popToRootViewController(animated: false)
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }

    private func presentEditModal() {
        guard let profesional = profesional, let currentUser = AuthManager.shared.currentUser else { return }

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
            field.placeholder = "Especialidad"
            field.text = profesional.especialidad
        }

        alert.addTextField { field in
            field.placeholder = "Biografía"
            field.text = profesional.biografia
        }

        alert.addAction(UIAlertAction(title: "Guardar Cambios", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let nombre = alert.textFields?[0].text, !nombre.isEmpty else {
                self.showAlert(title: "Error", message: "El nombre no puede estar vacío")
                return
            }

            let telefono = alert.textFields?[1].text ?? ""
            let especialidad = alert.textFields?[2].text ?? ""
            let biografia = alert.textFields?[3].text ?? ""

            self.editarButton.isEnabled = false
            self.editarTitleLabel.text = "Guardando..."

            APIManager.shared.updatePerfil(userId: currentUser.userId ?? 0, nombre: nombre, telefono: telefono.isEmpty ? nil : telefono, correo: nil) { _ in }

            APIManager.shared.updateProfesionalPerfil(profesionalId: profesional.id, especialidad: especialidad.isEmpty ? nil : especialidad, descripcion: nil, experiencia: nil, biografia: biografia.isEmpty ? nil : biografia) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.editarButton.isEnabled = true
                    self.editarTitleLabel.text = "Editar Perfil"

                    switch result {
                    case .success:
                        self.showAlert(title: "Éxito", message: "Perfil actualizado correctamente")
                        self.loadProfesionalData()

                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        })

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

        present(alert, animated: true)
    }

    private func loadReseñas() {
        guard let profesionalId = AuthManager.shared.currentUser?.id_profesional else { return }
        APIManager.shared.getResenasProfesional(profesionalId: profesionalId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard case .success(let response) = result else { return }

                // Actualizar rating label con datos reales
                if let stats = response.estadisticas {
                    if stats.totalResenas == 0 {
                        self.ratingLabel?.text = "Sin calificaciones aún"
                    } else {
                        self.ratingLabel?.text = String(format: "⭐ %.1f · %d reseñas", stats.calificacionPromedio, stats.totalResenas)
                    }
                }

                // Mostrar reseñas individuales
                if !response.resenas.isEmpty {
                    self.resenasStack?.arrangedSubviews.forEach { $0.removeFromSuperview() }
                    for resena in response.resenas {
                        self.resenasStack?.addArrangedSubview(self.makeResenaCard(resena: resena))
                    }
                }
            }
        }
    }

    private func makeResenaCard(resena: Resena) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.07
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false

        let stars = String(repeating: "★", count: resena.calificacion)
                  + String(repeating: "☆", count: max(0, 5 - resena.calificacion))
        let starsLabel = UILabel()
        starsLabel.text = stars
        starsLabel.textColor = .systemYellow
        starsLabel.font = UIFont.systemFont(ofSize: 16)
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(starsLabel)

        let fechaLabel = UILabel()
        fechaLabel.text = resena.fechaResena ?? ""
        fechaLabel.font = UIFont.systemFont(ofSize: 11)
        fechaLabel.textColor = .secondaryLabel
        fechaLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(fechaLabel)

        let comentarioLabel = UILabel()
        comentarioLabel.text = resena.comentario?.isEmpty == false ? resena.comentario : "Sin comentario"
        comentarioLabel.font = UIFont.systemFont(ofSize: 13)
        comentarioLabel.textColor = .label
        comentarioLabel.numberOfLines = 0
        comentarioLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(comentarioLabel)

        NSLayoutConstraint.activate([
            starsLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            starsLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),

            fechaLabel.centerYAnchor.constraint(equalTo: starsLabel.centerYAnchor),
            fechaLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),

            comentarioLabel.topAnchor.constraint(equalTo: starsLabel.bottomAnchor, constant: 6),
            comentarioLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            comentarioLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            comentarioLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10),
        ])

        return card
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ProfesionalProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else { return }
        let initials = avatarLabel.text ?? ""
        avatarLabel.text = ""
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tag = 999
        avatarView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
        avatarView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: avatarView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor),
        ])
        _ = initials
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
