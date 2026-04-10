import UIKit

class SolicitudDetailViewController: UIViewController {

    // MARK: - Properties
    private var solicitud: Solicitud

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let estadoBadge: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.textColor = .white
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let profesionalSection = SectionView(title: "Profesional")
    private let servicioSection = SectionView(title: "Servicio")
    private let descripcionSection = SectionView(title: "Descripción")
    private let fechaSection = SectionView(title: "Fecha de solicitud")
    private let calificacionSection = SectionView(title: "Calificación")

    private let chatButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Abrir Chat", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let calificarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Calificar Servicio", for: .normal)
        btn.backgroundColor = .systemYellow
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 12
        btn.isHidden = true
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
