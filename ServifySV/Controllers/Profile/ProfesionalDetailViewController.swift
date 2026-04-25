import UIKit

class ProfesionalDetailViewController: UIViewController {

    // MARK: - Properties
    private let profesional: Profesional
    private let isProfessionalProfile: Bool
    private var resenas: [Resena] = []

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .black
        btn.layer.cornerRadius = 20
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        v.layer.cornerRadius = 30
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.textColor = .systemBlue
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nombreLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let especialidadLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .systemBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descripcionTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Descripción"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descripcionLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let precioButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let reseniasTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Reseñas (3)"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let reseniasStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let solicitarTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Solicitar Servicio"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let solicitarTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Describe tu proyecto o necesidad..."
        tv.textColor = .systemGray
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let enviarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Enviar Solicitud", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 24
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init
    init(profesional: Profesional, isProfessionalProfile: Bool = false) {
        self.profesional = profesional
        self.isProfessionalProfile = isProfessionalProfile
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        loadResenas()
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

        contentView.addSubview(headerImageView)
        view.addSubview(backButton)

        avatarView.addSubview(avatarLabel)

        let infoStack = UIStackView(arrangedSubviews: [nombreLabel, especialidadLabel, ratingLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 2
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        let headerStack = UIStackView(arrangedSubviews: [avatarView, infoStack])
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .top
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerStack)

        contentView.addSubview(descripcionTitleLabel)
        contentView.addSubview(descripcionLabel)
        contentView.addSubview(precioButton)
        contentView.addSubview(contactoTitleLabel)
        contentView.addSubview(contactoStackView)
        contentView.addSubview(reseniasTitleLabel)
        contentView.addSubview(reseniasStackView)

        if !isProfessionalProfile {
            contentView.addSubview(solicitarTitleLabel)
            contentView.addSubview(solicitarTextView)
            contentView.addSubview(enviarButton)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 220),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            headerStack.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -18),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            descripcionTitleLabel.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 16),
            descripcionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            descripcionLabel.topAnchor.constraint(equalTo: descripcionTitleLabel.bottomAnchor, constant: 8),
            descripcionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descripcionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            precioButton.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 16),
            precioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            precioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            precioButton.heightAnchor.constraint(equalToConstant: 50),

            contactoTitleLabel.topAnchor.constraint(equalTo: precioButton.bottomAnchor, constant: 24),
            contactoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            contactoStackView.topAnchor.constraint(equalTo: contactoTitleLabel.bottomAnchor, constant: 12),
            contactoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contactoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            reseniasTitleLabel.topAnchor.constraint(equalTo: contactoStackView.bottomAnchor, constant: 24),
            reseniasTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            reseniasStackView.topAnchor.constraint(equalTo: reseniasTitleLabel.bottomAnchor, constant: 12),
            reseniasStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reseniasStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        if !isProfessionalProfile {
            NSLayoutConstraint.activate([
                solicitarTitleLabel.topAnchor.constraint(equalTo: reseniasStackView.bottomAnchor, constant: 24),
                solicitarTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

                solicitarTextView.topAnchor.constraint(equalTo: solicitarTitleLabel.bottomAnchor, constant: 12),
                solicitarTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                solicitarTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                solicitarTextView.heightAnchor.constraint(equalToConstant: 100),

                enviarButton.topAnchor.constraint(equalTo: solicitarTextView.bottomAnchor, constant: 16),
                enviarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                enviarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                enviarButton.heightAnchor.constraint(equalToConstant: 50),
                enviarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            ])
        } else {
            NSLayoutConstraint.activate([
                reseniasStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            ])
        }

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        if !isProfessionalProfile {
            enviarButton.addTarget(self, action: #selector(enviarTapped), for: .touchUpInside)
        }
    }

    private func configure() {
        let nombre = profesional.usuario?.nombre ?? ""
        let initials = nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel.text = nombre
        especialidadLabel.text = profesional.especialidad
        let rating = profesional.calificacionPromedio ?? 0.0
        let totalResenas = profesional.totalCalificaciones ?? 0
        ratingLabel.text = "⭐ \(String(format: "%.1f", rating)) • \(totalResenas) reseñas"
        descripcionLabel.text = profesional.descripcion

        if let servicio = profesional.servicios?.first {
            let precioText = String(format: "Tarifa por día\n$%.0f", servicio.precioReferencia)
            precioButton.setAttributedTitle(NSAttributedString(
                string: precioText,
                attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.white]
            ), for: .normal)
        }

        let categoriaStr = profesional.servicios?.first?.categoria
        headerImageView.image = getImageForCategory(categoriaStr.flatMap { CategoriaServicio(rawValue: $0) })

        addContactInfo()
    }

    private func loadResenas() {
        APIManager.shared.getResenasProfesional(profesionalId: profesional.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.resenas = response.resenas
                    self?.reseniasTitleLabel.text = "Reseñas (\(response.resenas.count))"
                    self?.reseniasStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                    self?.addResenas()

                case .failure:
                    self?.resenas = []
                    self?.reseniasTitleLabel.text = "Reseñas (0)"
                    self?.reseniasStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                }
            }
        }
    }

    private func addContactInfo() {
        let items = [
            ("📞", "+52 555 9876 5432"),
            ("📧", "juan.pérez@email.com"),
            ("📍", "Ciudad de México, CDMX"),
            ("⏰", "\(profesional.experiencia ?? 0)+ años de experiencia")
        ]

        for (icon, text) in items {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .label
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: icon + " "))
            attributedString.append(NSAttributedString(string: text, attributes: [.foregroundColor: UIColor.systemBlue]))
            label.attributedText = attributedString
            contactoStackView.addArrangedSubview(label)
        }
    }

    private func addResenas() {
        for resena in resenas {
            let nombre = "Usuario"
            let stars = String(repeating: "⭐", count: resena.calificacion) + String(repeating: "☆", count: 5 - resena.calificacion)
            let fecha = resena.fechaResena ?? ""
            let comentario = resena.comentario
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false

            let avatarReview = UILabel()
            avatarReview.text = String(nombre.prefix(1))
            avatarReview.font = UIFont.boldSystemFont(ofSize: 12)
            avatarReview.textColor = .white
            avatarReview.textAlignment = .center
            avatarReview.backgroundColor = .systemBlue
            avatarReview.layer.cornerRadius = 16
            avatarReview.clipsToBounds = true
            avatarReview.translatesAutoresizingMaskIntoConstraints = false
            avatarReview.widthAnchor.constraint(equalToConstant: 32).isActive = true
            avatarReview.heightAnchor.constraint(equalToConstant: 32).isActive = true

            let nombreLabel = UILabel()
            nombreLabel.text = nombre
            nombreLabel.font = UIFont.boldSystemFont(ofSize: 13)
            nombreLabel.translatesAutoresizingMaskIntoConstraints = false

            let fechaLabel = UILabel()
            fechaLabel.text = fecha
            fechaLabel.font = UIFont.systemFont(ofSize: 11)
            fechaLabel.textColor = .systemGray
            fechaLabel.translatesAutoresizingMaskIntoConstraints = false

            let starsLabel = UILabel()
            starsLabel.text = stars
            starsLabel.font = UIFont.systemFont(ofSize: 11)
            starsLabel.translatesAutoresizingMaskIntoConstraints = false

            let comentarioLabel = UILabel()
            comentarioLabel.text = comentario
            comentarioLabel.font = UIFont.systemFont(ofSize: 12)
            comentarioLabel.textColor = .label
            comentarioLabel.numberOfLines = 0
            comentarioLabel.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(avatarReview)
            container.addSubview(nombreLabel)
            container.addSubview(fechaLabel)
            container.addSubview(starsLabel)
            container.addSubview(comentarioLabel)

            NSLayoutConstraint.activate([
                avatarReview.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                avatarReview.topAnchor.constraint(equalTo: container.topAnchor),

                nombreLabel.leadingAnchor.constraint(equalTo: avatarReview.trailingAnchor, constant: 8),
                nombreLabel.topAnchor.constraint(equalTo: container.topAnchor),

                fechaLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                fechaLabel.topAnchor.constraint(equalTo: container.topAnchor),

                starsLabel.leadingAnchor.constraint(equalTo: avatarReview.trailingAnchor, constant: 8),
                starsLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 2),

                comentarioLabel.leadingAnchor.constraint(equalTo: avatarReview.trailingAnchor, constant: 8),
                comentarioLabel.topAnchor.constraint(equalTo: starsLabel.bottomAnchor, constant: 4),
                comentarioLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                comentarioLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            ])

            reseniasStackView.addArrangedSubview(container)
        }
    }

    private func getImageForCategory(_ categoria: CategoriaServicio?) -> UIImage? {
        guard let categoria = categoria else { return nil }

        let emoji: String
        switch categoria {
        case .electricidad:
            emoji = "⚡"
        case .plomeria:
            emoji = "🚰"
        case .albanileria:
            emoji = "👷"
        case .pintura:
            emoji = "🎨"
        case .carpinteria:
            emoji = "🪛"
        case .limpieza:
            emoji = "🧹"
        case .jardineria:
            emoji = "🌱"
        case .otro:
            emoji = "🔧"
        }

        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: 100)
        label.backgroundColor = UIColor.systemGray5
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: 220, height: 220)

        let renderer = UIGraphicsImageRenderer(size: label.frame.size)
        return renderer.image { context in
            UIColor.systemGray5.setFill()
            context.fill(label.bounds)
            label.layer.render(in: context.cgContext)
        }
    }

    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func enviarTapped() {
        let nuevaSolicitudVC = NuevaSolicitudViewController(profesional: profesional)
        navigationController?.pushViewController(nuevaSolicitudVC, animated: true)
    }
}
