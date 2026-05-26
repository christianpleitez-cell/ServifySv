import UIKit

class EditarPerfilProfesionalViewController: UIViewController {

    private let profesional: Profesional
    private let currentUser: LoginUser

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let guardarButton = UIButton(type: .system)

    private let nombreField     = EditarPerfilProfesionalViewController.makeField(placeholder: "Nombre completo")
    private let telefonoField   = EditarPerfilProfesionalViewController.makeField(placeholder: "Teléfono", keyboard: .phonePad)
    private let ubicacionField  = EditarPerfilProfesionalViewController.makeField(placeholder: "Ciudad / Ubicación")
    private let especialidadField = EditarPerfilProfesionalViewController.makeField(placeholder: "Ej. Electricista, Plomero...")
    private let descripcionField  = EditarPerfilProfesionalViewController.makeField(placeholder: "Descripción breve del servicio")
    private let experienciaField  = EditarPerfilProfesionalViewController.makeField(placeholder: "Años de experiencia", keyboard: .numberPad)
    private let biografiaView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.layer.borderColor = UIColor.separator.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 10
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Init
    init(profesional: Profesional, currentUser: LoginUser) {
        self.profesional = profesional
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillFields()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        title = "Editar Perfil"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Guardar", style: .done, target: self, action: #selector(guardarTapped)
        )

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])

        // Sección Datos Personales
        let personalHeader = makeSection("Datos Personales")
        let nombreRow  = makeRow(label: "Nombre", field: nombreField)
        let telefonoRow = makeRow(label: "Teléfono", field: telefonoField)
        let ubicacionRow = makeRow(label: "Ubicación", field: ubicacionField)

        // Sección Perfil Profesional
        let profesionalHeader = makeSection("Perfil Profesional")
        let especialidadRow = makeRow(label: "Especialidad", field: especialidadField)
        let descripcionRow = makeRow(label: "Descripción", field: descripcionField)
        let experienciaRow = makeRow(label: "Experiencia (años)", field: experienciaField)

        // Sección Biografía
        let biografiaHeader = makeSection("Acerca de mí")

        // Botón guardar
        guardarButton.setTitle("Guardar Cambios", for: .normal)
        guardarButton.backgroundColor = .systemBlue
        guardarButton.setTitleColor(.white, for: .normal)
        guardarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        guardarButton.layer.cornerRadius = 12
        guardarButton.translatesAutoresizingMaskIntoConstraints = false
        guardarButton.addTarget(self, action: #selector(guardarTapped), for: .touchUpInside)

        [personalHeader, nombreRow, telefonoRow, ubicacionRow,
         profesionalHeader, especialidadRow, descripcionRow, experienciaRow,
         biografiaHeader, biografiaView, guardarButton].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            personalHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            personalHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            nombreRow.topAnchor.constraint(equalTo: personalHeader.bottomAnchor, constant: 8),
            nombreRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nombreRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            telefonoRow.topAnchor.constraint(equalTo: nombreRow.bottomAnchor, constant: 8),
            telefonoRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            telefonoRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ubicacionRow.topAnchor.constraint(equalTo: telefonoRow.bottomAnchor, constant: 8),
            ubicacionRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ubicacionRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            profesionalHeader.topAnchor.constraint(equalTo: ubicacionRow.bottomAnchor, constant: 24),
            profesionalHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            especialidadRow.topAnchor.constraint(equalTo: profesionalHeader.bottomAnchor, constant: 8),
            especialidadRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            especialidadRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descripcionRow.topAnchor.constraint(equalTo: especialidadRow.bottomAnchor, constant: 8),
            descripcionRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descripcionRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            experienciaRow.topAnchor.constraint(equalTo: descripcionRow.bottomAnchor, constant: 8),
            experienciaRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            experienciaRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            biografiaHeader.topAnchor.constraint(equalTo: experienciaRow.bottomAnchor, constant: 24),
            biografiaHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            biografiaView.topAnchor.constraint(equalTo: biografiaHeader.bottomAnchor, constant: 8),
            biografiaView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            biografiaView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            biografiaView.heightAnchor.constraint(equalToConstant: 120),

            guardarButton.topAnchor.constraint(equalTo: biografiaView.bottomAnchor, constant: 32),
            guardarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            guardarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            guardarButton.heightAnchor.constraint(equalToConstant: 52),
            guardarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])
    }

    private func fillFields() {
        nombreField.text = currentUser.nombre
        telefonoField.text = profesional.usuario?.telefono ?? ""
        ubicacionField.text = profesional.usuario?.ubicacion ?? ""
        especialidadField.text = profesional.especialidad ?? ""
        descripcionField.text = profesional.descripcion ?? ""
        experienciaField.text = profesional.experiencia.map { "\($0)" } ?? ""
        biografiaView.text = profesional.biografia ?? ""
    }

    // MARK: - Actions
    @objc private func guardarTapped() {
        guard let nombre = nombreField.text, !nombre.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert("El nombre no puede estar vacío")
            return
        }

        let telefono  = telefonoField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let ubicacion = ubicacionField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let especialidad = especialidadField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let descripcion  = descripcionField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let experienciaStr = experienciaField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let experiencia  = Int(experienciaStr)
        let biografia    = biografiaView.text.trimmingCharacters(in: .whitespaces)

        setLoading(true)

        let group = DispatchGroup()
        var saveError: String?

        // Actualizar datos de usuario
        group.enter()
        APIManager.shared.updatePerfil(
            userId: currentUser.userId ?? 0,
            nombre: nombre,
            telefono: telefono.isEmpty ? nil : telefono,
            correo: nil
        ) { result in
            if case .failure(let e) = result { saveError = e.localizedDescription }
            group.leave()
        }

        // Actualizar datos profesionales
        group.enter()
        APIManager.shared.updateProfesionalPerfil(
            profesionalId: profesional.id,
            especialidad: especialidad.isEmpty ? nil : especialidad,
            descripcion: descripcion.isEmpty ? nil : descripcion,
            experiencia: experiencia,
            biografia: biografia.isEmpty ? nil : biografia
        ) { result in
            if case .failure(let e) = result { saveError = e.localizedDescription }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.setLoading(false)
            if let err = saveError {
                self?.showAlert(err)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func setLoading(_ loading: Bool) {
        guardarButton.isEnabled = !loading
        guardarButton.setTitle(loading ? "Guardando..." : "Guardar Cambios", for: .normal)
        navigationItem.rightBarButtonItem?.isEnabled = !loading
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Helpers
    private static func makeField(placeholder: String, keyboard: UIKeyboardType = .default) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.keyboardType = keyboard
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.separator.cgColor
        tf.layer.borderWidth = 1
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }

    private func makeRow(label: String, field: UITextField) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let lbl = UILabel()
        lbl.text = label
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(lbl)
        container.addSubview(field)

        NSLayoutConstraint.activate([
            lbl.topAnchor.constraint(equalTo: container.topAnchor),
            lbl.leadingAnchor.constraint(equalTo: container.leadingAnchor),

            field.topAnchor.constraint(equalTo: lbl.bottomAnchor, constant: 4),
            field.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            field.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            field.heightAnchor.constraint(equalToConstant: 44),
            field.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    private func makeSection(_ title: String) -> UILabel {
        let l = UILabel()
        l.text = title.uppercased()
        l.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .systemBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }
}
