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
        l.text = "Reseñas"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let ratingOverviewCard: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.07)
        v.layer.cornerRadius = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let ratingStarsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 28)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let ratingTextLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
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
        ratingOverviewCard.addSubview(ratingStarsLabel)
        ratingOverviewCard.addSubview(ratingTextLabel)

        contentView.addSubview(reseniasTitleLabel)
        contentView.addSubview(ratingOverviewCard)
        contentView.addSubview(loadingIndicator)
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

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

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

            ratingOverviewCard.topAnchor.constraint(equalTo: reseniasTitleLabel.bottomAnchor, constant: 12),
            ratingOverviewCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingOverviewCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ratingStarsLabel.topAnchor.constraint(equalTo: ratingOverviewCard.topAnchor, constant: 14),
            ratingStarsLabel.centerXAnchor.constraint(equalTo: ratingOverviewCard.centerXAnchor),

            ratingTextLabel.topAnchor.constraint(equalTo: ratingStarsLabel.bottomAnchor, constant: 4),
            ratingTextLabel.centerXAnchor.constraint(equalTo: ratingOverviewCard.centerXAnchor),
            ratingTextLabel.bottomAnchor.constraint(equalTo: ratingOverviewCard.bottomAnchor, constant: -14),

            loadingIndicator.topAnchor.constraint(equalTo: ratingOverviewCard.bottomAnchor, constant: 20),
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            reseniasStackView.topAnchor.constraint(equalTo: ratingOverviewCard.bottomAnchor, constant: 16),
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
        let rating = profesional.calificacionPromedio ?? 0.0
        let totalResenas = profesional.totalCalificaciones ?? 0
        ratingLabel.text = "⭐ \(String(format: "%.1f", rating)) • \(totalResenas) reseñas"

        if let servicio = profesional.servicios?.first {
            especialidadLabel.text = servicio.nombreServicio
            descripcionLabel.text = servicio.descripcion ?? profesional.descripcion ?? "Sin descripción"
            let precioText = String(format: "Tarifa por día  $%.0f", servicio.precioReferencia)
            precioButton.setTitle(precioText, for: .normal)
            precioButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        } else {
            especialidadLabel.text = profesional.especialidad
            descripcionLabel.text = profesional.descripcion ?? "Sin descripción"
        }

        headerImageView.image = nil
        headerImageView.backgroundColor = UIColor(red: 0.72, green: 0.88, blue: 0.98, alpha: 1)

        solicitarTextView.delegate = self
        addContactInfo()
    }

    private func loadResenas() {
        loadingIndicator.startAnimating()
        reseniasStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Mostrar rating inicial desde el objeto profesional mientras carga
        updateRatingCard(promedio: profesional.calificacionPromedio ?? 0,
                         total: profesional.totalCalificaciones ?? 0)

        APIManager.shared.getResenasProfesional(profesionalId: profesional.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()

                switch result {
                case .success(let response):
                    self.resenas = response.resenas
                    self.reseniasTitleLabel.text = "Reseñas (\(response.resenas.count))"
                    if let stats = response.estadisticas {
                        self.updateRatingCard(promedio: stats.calificacionPromedio,
                                             total: stats.totalResenas)
                    }
                    self.reseniasStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                    self.addResenas()

                case .failure:
                    self.resenas = []
                    self.reseniasTitleLabel.text = "Reseñas"
                    self.reseniasStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                    self.addResenas()
                }
            }
        }
    }

    private func updateRatingCard(promedio: Double, total: Int) {
        let filled = min(5, max(0, Int(promedio.rounded())))
        ratingStarsLabel.text = String(repeating: "★", count: filled)
                              + String(repeating: "☆", count: 5 - filled)
        if total == 0 {
            ratingTextLabel.text = "Sin calificaciones aún"
        } else {
            ratingTextLabel.text = String(format: "%.1f de 5 · %d %@",
                                          promedio, total,
                                          total == 1 ? "reseña" : "reseñas")
        }
    }

    private func addContactInfo() {
        var items: [(String, String)] = []

        if let telefono = profesional.usuario?.telefono, !telefono.isEmpty {
            items.append(("📞", telefono))
        }
        if let correo = profesional.usuario?.correo, !correo.isEmpty {
            items.append(("📧", correo))
        }
        if let ubicacion = profesional.usuario?.ubicacion, !ubicacion.isEmpty {
            items.append(("📍", ubicacion))
        }
        items.append(("⏰", "\(profesional.experiencia ?? 0)+ años de experiencia"))

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
        guard !resenas.isEmpty else {
            let empty = UILabel()
            empty.text = "Aún no tiene reseñas"
            empty.font = UIFont.systemFont(ofSize: 14)
            empty.textColor = .secondaryLabel
            empty.textAlignment = .center
            reseniasStackView.addArrangedSubview(empty)
            return
        }

        for resena in resenas {
            reseniasStackView.addArrangedSubview(makeResenaCard(resena: resena))
        }
    }

    private func makeResenaCard(resena: Resena) -> UIView {
        let nombre = resena.cliente?.nombre ?? "Cliente"
        let initial = String(nombre.prefix(1)).uppercased()
        let filled = min(5, max(0, resena.calificacion))
        let stars = String(repeating: "★", count: filled)
                  + String(repeating: "☆", count: 5 - filled)

        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.07
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false

        let avatarView = UILabel()
        avatarView.text = initial
        avatarView.font = UIFont.boldSystemFont(ofSize: 13)
        avatarView.textColor = .white
        avatarView.textAlignment = .center
        avatarView.backgroundColor = .systemBlue
        avatarView.layer.cornerRadius = 17
        avatarView.clipsToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        let nombreLabel = UILabel()
        nombreLabel.text = nombre
        nombreLabel.font = UIFont.boldSystemFont(ofSize: 13)
        nombreLabel.translatesAutoresizingMaskIntoConstraints = false

        let fechaLabel = UILabel()
        fechaLabel.text = resena.fechaResena ?? ""
        fechaLabel.font = UIFont.systemFont(ofSize: 11)
        fechaLabel.textColor = .secondaryLabel
        fechaLabel.translatesAutoresizingMaskIntoConstraints = false

        let starsLabel = UILabel()
        starsLabel.text = stars
        starsLabel.font = UIFont.systemFont(ofSize: 14)
        starsLabel.textColor = .systemYellow
        starsLabel.translatesAutoresizingMaskIntoConstraints = false

        let comentarioLabel = UILabel()
        let hasComentario = !(resena.comentario?.isEmpty ?? true)
        comentarioLabel.text = hasComentario ? resena.comentario : "Sin comentario"
        comentarioLabel.font = UIFont.systemFont(ofSize: 13)
        comentarioLabel.textColor = hasComentario ? .label : .secondaryLabel
        comentarioLabel.numberOfLines = 0
        comentarioLabel.translatesAutoresizingMaskIntoConstraints = false

        [avatarView, nombreLabel, fechaLabel, starsLabel, comentarioLabel].forEach { card.addSubview($0) }

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            avatarView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            avatarView.widthAnchor.constraint(equalToConstant: 34),
            avatarView.heightAnchor.constraint(equalToConstant: 34),

            nombreLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            nombreLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),

            fechaLabel.centerYAnchor.constraint(equalTo: nombreLabel.centerYAnchor),
            fechaLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),

            starsLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 2),
            starsLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),

            comentarioLabel.topAnchor.constraint(equalTo: starsLabel.bottomAnchor, constant: 6),
            comentarioLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            comentarioLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            comentarioLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
        ])

        return card
    }

    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func enviarTapped() {
        guard let texto = solicitarTextView.text,
              !texto.isEmpty,
              texto != "Describe tu proyecto o necesidad..." else {
            showAlert(title: "Error", message: "Por favor describe lo que necesitas")
            return
        }

        if let u = AuthManager.shared.currentUser {
            print("[Debug] currentUser id=\(u.id ?? -1) id_usuario=\(u.id_usuario ?? -1) id_profesional=\(u.id_profesional ?? -1) tipo=\(u.tipo_usuario)")
        } else {
            print("[Debug] currentUser es nil")
        }

        guard let clienteId = AuthManager.shared.currentUser?.userId else {
            showAlert(title: "Error", message: "Debes iniciar sesión para enviar una solicitud")
            return
        }

        guard let servicio = profesional.servicios?.first else { return }

        enviarButton.isEnabled = false
        enviarButton.setTitle("Enviando...", for: .normal)

        APIManager.shared.createSolicitud(
            idCliente: clienteId,
            idProfesional: profesional.id,
            idServicio: servicio.id,
            descripcion: texto
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.enviarButton.isEnabled = true
                self?.enviarButton.setTitle("Enviar Solicitud", for: .normal)

                switch result {
                case .success:
                    let nombre = self?.profesional.usuario?.nombre ?? "el profesional"
                    self?.showAlert(title: "¡Solicitud Enviada!", message: "Tu solicitud ha sido enviada a \(nombre). Te notificaremos cuando la acepte.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.navigationController?.popViewController(animated: true)
                    }
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
}

// MARK: - UITextViewDelegate
extension ProfesionalDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe tu proyecto o necesidad..."
            textView.textColor = .systemGray
        }
    }
}
