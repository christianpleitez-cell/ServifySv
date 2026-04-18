import UIKit

class ProfesionalProfileViewController: UIViewController {

    private var profesional = (
        nombre: "Juan Pérez",
        telefono: "+52 555 1234 5678",
        email: "Nel500@gmail.com",
        ubicacion: "Ciudad de México, CDMX",
        biografia: "Profesional con más de 10 años de experiencia en construcción y remodelación. Especializado en trabajos de albañilería, acabados y proyectos completos de remodelación residencial y comercial.",
        trabajos: 127,
        ingresos: "$45.680",
        rating: 4.8
    )

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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
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
        let nombreLabel = UILabel()
        nombreLabel.text = profesional.nombre
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

        let ratingLabel = UILabel()
        ratingLabel.text = "⭐ \(profesional.rating) · \(profesional.trabajos) trabajos"
        ratingLabel.font = UIFont.systemFont(ofSize: 13)
        ratingLabel.textColor = .systemGray
        ratingLabel.textAlignment = .center
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingLabel)

        // Cards de estadísticas
        let statsStack = UIStackView()
        statsStack.axis = .horizontal
        statsStack.spacing = 16
        statsStack.distribution = .fillEqually
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsStack)

        let trabajosCard = createStatCard(icon: "👔", title: "Trabajos", value: "\(profesional.trabajos)")
        let ingresosCard = createStatCard(icon: "$", title: "Ingresos", value: profesional.ingresos)

        statsStack.addArrangedSubview(trabajosCard)
        statsStack.addArrangedSubview(ingresosCard)

        // Información de Contacto
        let contactoTitle = UILabel()
        contactoTitle.text = "Información de Contacto"
        contactoTitle.font = UIFont.boldSystemFont(ofSize: 16)
        contactoTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactoTitle)

        let telefonoLabel = UILabel()
        telefonoLabel.text = "📞 \(profesional.telefono)"
        telefonoLabel.font = UIFont.systemFont(ofSize: 13)
        telefonoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(telefonoLabel)

        let emailLabel = UILabel()
        emailLabel.text = "📧 \(profesional.email)"
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailLabel)

        let ubicacionLabel = UILabel()
        ubicacionLabel.text = "📍 \(profesional.ubicacion)"
        ubicacionLabel.font = UIFont.systemFont(ofSize: 13)
        ubicacionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ubicacionLabel)

        // Acerca de mí
        let acercaTitle = UILabel()
        acercaTitle.text = "Acerca de mí"
        acercaTitle.font = UIFont.boldSystemFont(ofSize: 16)
        acercaTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(acercaTitle)

        let acercaLabel = UILabel()
        acercaLabel.text = profesional.biografia
        acercaLabel.font = UIFont.systemFont(ofSize: 13)
        acercaLabel.textColor = .label
        acercaLabel.numberOfLines = 0
        acercaLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(acercaLabel)

        // Botón Editar
        let editarButton = UIButton(type: .system)
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
        navigationController?.popToRootViewController(animated: false)
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }

    private func presentEditModal() {
        let alert = UIAlertController(title: "Editar Perfil", message: nil, preferredStyle: .alert)
        alert.view.tintColor = .systemBlue

        let nombreField = UITextField()
        nombreField.placeholder = "Nombre"
        nombreField.text = profesional.nombre
        nombreField.borderStyle = .roundedRect
        alert.addTextField { _ in }
        alert.textFields?[0] = nombreField

        let telefonoField = UITextField()
        telefonoField.placeholder = "Teléfono"
        telefonoField.text = profesional.telefono
        telefonoField.borderStyle = .roundedRect
        alert.addTextField { _ in }
        alert.textFields?[1] = telefonoField

        let emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.text = profesional.email
        emailField.borderStyle = .roundedRect
        alert.addTextField { _ in }
        alert.textFields?[2] = emailField

        let biografiaField = UITextField()
        biografiaField.placeholder = "Biografía"
        biografiaField.text = profesional.biografia
        biografiaField.borderStyle = .roundedRect
        alert.addTextField { _ in }
        alert.textFields?[3] = biografiaField

        alert.addAction(UIAlertAction(title: "Guardar Cambios", style: .default) { _ in
            if let nombre = nombreField.text {
                self.profesional.nombre = nombre
            }
        })

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

        present(alert, animated: true)
    }
}
