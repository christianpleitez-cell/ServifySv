import UIKit

class ProfesionalDetailViewController: UIViewController {

    // MARK: - Properties
    private let profesional: Profesional

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        v.layer.cornerRadius = 50
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 36)
        l.textColor = .systemBlue
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nombreLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 22)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let especialidadLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let verifiedBadge: UILabel = {
        let l = UILabel()
        l.text = "✓ Verificado"
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = .white
        l.backgroundColor = .systemGreen
        l.layer.cornerRadius = 10
        l.clipsToBounds = true
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let starsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descripcionLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let experienciaLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let serviciosLabel: UILabel = {
        let l = UILabel()
        l.text = "Servicios ofrecidos"
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let serviciosStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let solicitarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Solicitar Servicio", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init
    init(profesional: Profesional) {
        self.profesional = profesional
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Perfil"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        avatarView.addSubview(avatarLabel)
        contentView.addSubview(avatarView)
        contentView.addSubview(nombreLabel)
        contentView.addSubview(especialidadLabel)
        contentView.addSubview(verifiedBadge)
        contentView.addSubview(starsLabel)
        contentView.addSubview(descripcionLabel)
        contentView.addSubview(experienciaLabel)
        contentView.addSubview(serviciosLabel)
        contentView.addSubview(serviciosStack)
        contentView.addSubview(solicitarButton)

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

            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nombreLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            nombreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nombreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            especialidadLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 4),
            especialidadLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            especialidadLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            verifiedBadge.topAnchor.constraint(equalTo: especialidadLabel.bottomAnchor, constant: 8),
            verifiedBadge.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            verifiedBadge.widthAnchor.constraint(equalToConstant: 100),
            verifiedBadge.heightAnchor.constraint(equalToConstant: 24),

            starsLabel.topAnchor.constraint(equalTo: verifiedBadge.bottomAnchor, constant: 10),
            starsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            starsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descripcionLabel.topAnchor.constraint(equalTo: starsLabel.bottomAnchor, constant: 20),
            descripcionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descripcionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            experienciaLabel.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 8),
            experienciaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            serviciosLabel.topAnchor.constraint(equalTo: experienciaLabel.bottomAnchor, constant: 24),
            serviciosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            serviciosStack.topAnchor.constraint(equalTo: serviciosLabel.bottomAnchor, constant: 12),
            serviciosStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            serviciosStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            solicitarButton.topAnchor.constraint(equalTo: serviciosStack.bottomAnchor, constant: 32),
            solicitarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            solicitarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            solicitarButton.heightAnchor.constraint(equalToConstant: 52),
            solicitarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])

        solicitarButton.addTarget(self, action: #selector(solicitarTapped), for: .touchUpInside)
    }

    private func configure() {
        let initials = profesional.usuario.nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel.text = profesional.usuario.nombre
        especialidadLabel.text = profesional.especialidad
        verifiedBadge.isHidden = profesional.estadoVerificacion != "Verificado"
        starsLabel.text = starsString(for: profesional.calificacionPromedio) + " \(profesional.calificacionPromedio) (\(profesional.totalCalificaciones) reseñas)"
        descripcionLabel.text = profesional.descripcion
        experienciaLabel.text = "Experiencia: \(profesional.experiencia) años"

        profesional.servicios.forEach { servicio in
            let card = ServicioCardView(servicio: servicio)
            serviciosStack.addArrangedSubview(card)
        }
    }

    private func starsString(for rating: Double) -> String {
        let full = Int(rating)
        return String(repeating: "★", count: full) + String(repeating: "☆", count: 5 - full)
    }

    // MARK: - Actions
    @objc private func solicitarTapped() {
        let solicitudVC = NuevaSolicitudViewController(profesional: profesional)
        navigationController?.pushViewController(solicitudVC, animated: true)
    }
}
