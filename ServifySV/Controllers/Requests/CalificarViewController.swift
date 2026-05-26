import UIKit

class CalificarViewController: UIViewController {

    // MARK: - Properties
    private let solicitud: Solicitud
    private var resena: Resena?
    private var puntuacionSeleccionada: Int = 5

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Calificar Servicio"
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let starsStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private var starButtons: [UIButton] = []

    private let comentarioLabel: UILabel = {
        let l = UILabel()
        l.text = "Agrega un comentario (opcional)"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let comentarioTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.layer.borderColor = UIColor.separator.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let enviarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Enviar Calificación", for: .normal)
        btn.backgroundColor = .systemYellow
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init
    init(solicitud: Solicitud, resena: Resena? = nil) {
        self.solicitud = solicitud
        self.resena = resena
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Restaurar estado oculto si regresamos a SolicitudDetailViewController
        if navigationController?.topViewController is SolicitudDetailViewController {
            navigationController?.navigationBar.isHidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        if let r = resena {
            title = "Editar Calificación"
            titleLabel.text = "Editar Calificación"
            puntuacionSeleccionada = r.calificacion
            comentarioTextView.text = r.comentario ?? ""
            enviarButton.setTitle("Actualizar Calificación", for: .normal)
        }
        updateStars()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Calificar"

        for i in 1...5 {
            let btn = UIButton(type: .system)
            btn.setTitle("★", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 36)
            btn.tag = i
            btn.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starButtons.append(btn)
            starsStack.addArrangedSubview(btn)
        }

        [titleLabel, subtitleLabel, starsStack, comentarioLabel, comentarioTextView, enviarButton].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            starsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            starsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starsStack.widthAnchor.constraint(equalToConstant: 240),
            starsStack.heightAnchor.constraint(equalToConstant: 60),

            comentarioLabel.topAnchor.constraint(equalTo: starsStack.bottomAnchor, constant: 30),
            comentarioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            comentarioTextView.topAnchor.constraint(equalTo: comentarioLabel.bottomAnchor, constant: 8),
            comentarioTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            comentarioTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            comentarioTextView.heightAnchor.constraint(equalToConstant: 100),

            enviarButton.topAnchor.constraint(equalTo: comentarioTextView.bottomAnchor, constant: 32),
            enviarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enviarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            enviarButton.heightAnchor.constraint(equalToConstant: 52),
        ])

        enviarButton.addTarget(self, action: #selector(enviarTapped), for: .touchUpInside)
    }

    private func configure() {
        subtitleLabel.text = "¿Cómo fue tu experiencia con \(solicitud.profesional?.usuario?.nombre ?? "el profesional")?"
    }

    private func updateStars() {
        for btn in starButtons {
            btn.setTitleColor(btn.tag <= puntuacionSeleccionada ? .systemYellow : .systemGray3, for: .normal)
        }
    }

    // MARK: - Actions
    @objc private func starTapped(_ sender: UIButton) {
        puntuacionSeleccionada = sender.tag
        updateStars()
    }

    @objc private func enviarTapped() {
        guard let clienteId = AuthManager.shared.currentUser?.userId else { return }

        let comentario = comentarioTextView.text ?? ""

        enviarButton.isEnabled = false
        let originalTitle = enviarButton.title(for: .normal)
        enviarButton.setTitle("Enviando...", for: .normal)

        if let r = resena {
            APIManager.shared.updateResena(
                resenaId: r.id,
                calificacion: puntuacionSeleccionada,
                comentario: comentario
            ) { [weak self] result in
                DispatchQueue.main.async {
                    self?.enviarButton.isEnabled = true
                    self?.enviarButton.setTitle(originalTitle, for: .normal)
                    switch result {
                    case .success:
                        self?.showSuccessAndPop(stars: self?.puntuacionSeleccionada ?? 5, isEdit: true)
                    case .failure(let error):
                        self?.showError(error.localizedDescription)
                    }
                }
            }
        } else {
            APIManager.shared.createResena(
                idSolicitud: solicitud.id,
                idCliente: clienteId,
                idProfesional: solicitud.profesional?.id ?? 0,
                calificacion: puntuacionSeleccionada,
                comentario: comentario
            ) { [weak self] result in
                DispatchQueue.main.async {
                    self?.enviarButton.isEnabled = true
                    self?.enviarButton.setTitle(originalTitle, for: .normal)
                    switch result {
                    case .success:
                        self?.showSuccessAndPop(stars: self?.puntuacionSeleccionada ?? 5, isEdit: false)
                    case .failure(let error):
                        self?.showError(error.localizedDescription)
                    }
                }
            }
        }
    }

    private func showSuccessAndPop(stars: Int, isEdit: Bool) {
        let msg = isEdit
            ? "Tu calificación de \(stars) estrella(s) ha sido actualizada."
            : "Tu calificación de \(stars) estrella(s) ha sido enviada."
        let alert = UIAlertController(title: isEdit ? "¡Calificación actualizada!" : "¡Gracias por tu reseña!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
