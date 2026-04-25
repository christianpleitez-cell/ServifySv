import UIKit

class ProfesionalProfileViewController: UIViewController {

    private var profesional: Profesional?
    private var estadisticas: (trabajos: Int, ingresos: Double, rating: Double) = (0, 0, 0)
    private var editarButton: UIButton!
    private var nombreLabel: UILabel!
    private var ratingLabel: UILabel!
    private var statsStack: UIStackView!
    private var contentStackLabels: [UILabel] = []

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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    private func loadProfesionalData() {
        guard let currentUser = AuthManager.shared.currentUser else { return }

        APIManager.shared.getProfesionalById(id: currentUser.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.profesional = Profesional(
                        id: response.id,
                        usuario: response.usuario,
                        especialidad: response.especialidad,
                        descripcion: response.descripcion,
                        experiencia: response.experiencia,
                        estadoVerificacion: response.estadoVerificacion,
                        calificacionPromedio: response.calificacionPromedio,
                        totalCalificaciones: response.totalCalificaciones,
                        biografia: nil,
                        servicios: response.servicios
                    )
                    self?.updateUI()

                case .failure:
                    self?.profesional = nil
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
                label.text = profesional.biografia
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

        view.insertSubview(headerView, belowSubview: scrollView)
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

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        setupContent()
    }

    private func setupContent() {
        nombreLabel = UILabel()
        nombreLabel.text = "Cargando..."
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

        let trabajosCard = createStatCard(icon: "👔", title: "Trabajos", value: "0")
        let ingresosCard = createStatCard(icon: "$", title: "Ingresos", value: "$0.00")

        statsStack.addArrangedSubview(trabajosCard)
        statsStack.addArrangedSubview(ingresosCard)

        // Información de Contacto
        let contactoTitle = UILabel()
        contactoTitle.text = "Información de Contacto"
        contactoTitle.font = UIFont.boldSystemFont(ofSize: 16)
        contactoTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactoTitle)

        let telefonoLabel = UILabel()
        telefonoLabel.text = "📞 Cargando..."
        telefonoLabel.font = UIFont.systemFont(ofSize: 13)
        telefonoLabel.translatesAutoresizingMaskIntoConstraints = false
        telefonoLabel.tag = 1001
        contentView.addSubview(telefonoLabel)
        contentStackLabels.append(telefonoLabel)

        let emailLabel = UILabel()
        emailLabel.text = "📧 Cargando..."
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.tag = 1002
        contentView.addSubview(emailLabel)
        contentStackLabels.append(emailLabel)

        let ubicacionLabel = UILabel()
        ubicacionLabel.text = "📍 Cargando..."
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
        acercaLabel.text = "Cargando..."
        acercaLabel.font = UIFont.systemFont(ofSize: 13)
        acercaLabel.textColor = .label
        acercaLabel.numberOfLines = 0
        acercaLabel.translatesAutoresizingMaskIntoConstraints = false
        acercaLabel.tag = 1004
        contentView.addSubview(acercaLabel)
        contentStackLabels.append(acercaLabel)

        // Botón Editar
        editarButton = UIButton(type: .system)
        editarButton.setTitle("Editar Perfil", for: .normal)
        editarButton.backgroundColor = .systemBlue
        editarButton.setTitleColor(.white, for: .normal)
        editarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        editarButton.layer.cornerRadius = 24
        editarButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(editarButton)

        // Configuración
        let configButton = UIButton(type: .system)
        var configConfig = UIButton.Configuration.plain()
        configConfig.image = UIImage(systemName: "gearshape")
        configConfig.imagePadding = 12
        configButton.setAttributedTitle(NSAttributedString(string: "Configuración", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.label]), for: .normal)
        configButton.configuration = configConfig
        configButton.contentHorizontalAlignment = .left
        configButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(configButton)

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

        NSLayoutConstraint.activate([
            nombreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
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

            editarButton.topAnchor.constraint(equalTo: acercaLabel.bottomAnchor, constant: 20),
            editarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            editarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editarButton.heightAnchor.constraint(equalToConstant: 50),

            configButton.topAnchor.constraint(equalTo: editarButton.bottomAnchor, constant: 12),
            configButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            configButton.heightAnchor.constraint(equalToConstant: 44),

            logoutButton.topAnchor.constraint(equalTo: configButton.bottomAnchor, constant: 4),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])

        editarButton.addTarget(self, action: #selector(editarTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    private func createStatCard(icon: String, title: String, value: String) -> UIView {
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

        return card
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
            let originalTitle = self.editarButton.title(for: .normal)
            self.editarButton.setTitle("Guardando...", for: .normal)

            APIManager.shared.updatePerfil(userId: currentUser.id, nombre: nombre, telefono: telefono.isEmpty ? nil : telefono, correo: nil) { _ in }

            APIManager.shared.updateProfesionalPerfil(profesionalId: profesional.id, especialidad: especialidad.isEmpty ? nil : especialidad, descripcion: nil, experiencia: nil, biografia: biografia.isEmpty ? nil : biografia) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.editarButton.isEnabled = true
                    self.editarButton.setTitle(originalTitle, for: .normal)

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

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
