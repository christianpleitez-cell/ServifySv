import UIKit

class PublicarViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerStack = UIStackView()
    private let fotoUploadView = UIView()
    private let fotoLabel = UILabel()

    private var tituloTextField: UITextField!
    private var categoriaTextField: UITextField!
    private var descripcionTextView: UITextView!
    private var precioTextField: UITextField!

    private lazy var tituloField = createTextField(textField: &tituloTextField, placeholder: "Ej: Construcción y Remodelación", label: "Título del servicio")
    private lazy var categoriaField = createDropdown(textField: &categoriaTextField, label: "Categoría", placeholder: "Selecciona una categoría")
    private lazy var descripcionField = createTextView(textView: &descripcionTextView, placeholder: "Describe tu experiencia, especialidades y qué servicios ofreces...", label: "Descripción")
    private lazy var precioField = createTextField(textField: &precioTextField, placeholder: "500", label: "Precio por día", keyboardType: .decimalPad)
    private let precioHelpLabel = UILabel()

    private let publicarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Publicar Servicio", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        title = "Publicar"
        navigationController?.navigationBar.prefersLargeTitles = true

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let titleLabel = UILabel()
        titleLabel.text = "Publicar Servicio"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Comparte tu experiencia profesional"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)

        setupFotoUpload()
        contentView.addSubview(fotoUploadView)

        contentView.addSubview(tituloField)
        contentView.addSubview(categoriaField)
        contentView.addSubview(descripcionField)
        contentView.addSubview(precioField)

        precioHelpLabel.text = "Este será tu tarifa base por día de trabajo"
        precioHelpLabel.font = UIFont.systemFont(ofSize: 12)
        precioHelpLabel.textColor = .systemGray
        precioHelpLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(precioHelpLabel)

        contentView.addSubview(publicarButton)

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

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            fotoUploadView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            fotoUploadView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fotoUploadView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            fotoUploadView.heightAnchor.constraint(equalToConstant: 140),

            tituloField.topAnchor.constraint(equalTo: fotoUploadView.bottomAnchor, constant: 20),
            tituloField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tituloField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            categoriaField.topAnchor.constraint(equalTo: tituloField.bottomAnchor, constant: 16),
            categoriaField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoriaField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descripcionField.topAnchor.constraint(equalTo: categoriaField.bottomAnchor, constant: 16),
            descripcionField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descripcionField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descripcionField.heightAnchor.constraint(equalToConstant: 120),

            precioField.topAnchor.constraint(equalTo: descripcionField.bottomAnchor, constant: 16),
            precioField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            precioField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            precioHelpLabel.topAnchor.constraint(equalTo: precioField.bottomAnchor, constant: 6),
            precioHelpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            publicarButton.topAnchor.constraint(equalTo: precioHelpLabel.bottomAnchor, constant: 20),
            publicarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            publicarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            publicarButton.heightAnchor.constraint(equalToConstant: 50),
            publicarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])

        publicarButton.addTarget(self, action: #selector(publicarTapped), for: .touchUpInside)
    }

    private func setupFotoUpload() {
        fotoUploadView.backgroundColor = .white
        fotoUploadView.layer.cornerRadius = 8
        fotoUploadView.layer.borderColor = UIColor.systemGray3.cgColor
        fotoUploadView.layer.borderWidth = 1
        fotoUploadView.translatesAutoresizingMaskIntoConstraints = false

        let fotoLabelTitle = UILabel()
        fotoLabelTitle.text = "Foto del servicio"
        fotoLabelTitle.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        fotoLabelTitle.textColor = .black
        fotoLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(fotoLabelTitle, belowSubview: fotoUploadView)

        let iconLabel = UILabel()
        iconLabel.text = "📷"
        iconLabel.font = UIFont.systemFont(ofSize: 40)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        fotoUploadView.addSubview(iconLabel)

        fotoLabel.text = "Toca para subir una foto"
        fotoLabel.font = UIFont.systemFont(ofSize: 14)
        fotoLabel.textColor = .systemGray
        fotoLabel.textAlignment = .center
        fotoLabel.translatesAutoresizingMaskIntoConstraints = false
        fotoUploadView.addSubview(fotoLabel)

        NSLayoutConstraint.activate([
            fotoLabelTitle.bottomAnchor.constraint(equalTo: fotoUploadView.topAnchor, constant: -6),
            fotoLabelTitle.leadingAnchor.constraint(equalTo: fotoUploadView.leadingAnchor),

            iconLabel.topAnchor.constraint(equalTo: fotoUploadView.topAnchor, constant: 16),
            iconLabel.centerXAnchor.constraint(equalTo: fotoUploadView.centerXAnchor),

            fotoLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            fotoLabel.leadingAnchor.constraint(equalTo: fotoUploadView.leadingAnchor, constant: 12),
            fotoLabel.trailingAnchor.constraint(equalTo: fotoUploadView.trailingAnchor, constant: -12),
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(subirFotoTapped))
        fotoUploadView.addGestureRecognizer(tap)
    }

    @objc private func subirFotoTapped() {
        let alert = UIAlertController(title: "Subir Foto", message: "Selecciona una opción", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default))
        alert.addAction(UIAlertAction(title: "Galería", style: .default))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func publicarTapped() {
        guard let titulo = tituloTextField.text, !titulo.isEmpty else {
            showAlert(title: "Error", message: "Por favor ingresa un título para el servicio")
            return
        }

        guard let categoria = categoriaTextField.text, !categoria.isEmpty else {
            showAlert(title: "Error", message: "Por favor selecciona una categoría")
            return
        }

        guard let descripcion = descripcionTextView.text, !descripcion.isEmpty, descripcion != "Describe tu experiencia, especialidades y qué servicios ofreces..." else {
            showAlert(title: "Error", message: "Por favor ingresa una descripción")
            return
        }

        guard let precioStr = precioTextField.text, !precioStr.isEmpty, let precio = Double(precioStr) else {
            showAlert(title: "Error", message: "Por favor ingresa un precio válido")
            return
        }

        guard let profesionalId = AuthManager.shared.currentUser?.id else { return }

        publicarButton.isEnabled = false
        let originalTitle = publicarButton.title(for: .normal)
        publicarButton.setTitle("Publicando...", for: .normal)

        APIManager.shared.createServicio(
            idProfesional: profesionalId,
            nombreServicio: titulo,
            categoria: categoria.lowercased(),
            descripcion: descripcion,
            precioReferencia: precio,
            disponibilidad: true
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.publicarButton.isEnabled = true
                self?.publicarButton.setTitle(originalTitle, for: .normal)

                switch result {
                case .success:
                    self?.showAlert(title: "Éxito", message: "Tu servicio ha sido publicado exitosamente")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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

private func createTextField(textField: inout UITextField?, placeholder: String, label: String, keyboardType: UIKeyboardType = .default) -> UIView {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let labelView = UILabel()
    labelView.text = label
    labelView.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    labelView.textColor = .black
    labelView.translatesAutoresizingMaskIntoConstraints = false

    let tf = UITextField()
    tf.placeholder = placeholder
    tf.borderStyle = .none
    tf.keyboardType = keyboardType
    tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
    tf.layer.cornerRadius = 8
    tf.translatesAutoresizingMaskIntoConstraints = false

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
    tf.leftView = paddingView
    tf.leftViewMode = .always

    textField = tf

    container.addSubview(labelView)
    container.addSubview(tf)

    NSLayoutConstraint.activate([
        labelView.topAnchor.constraint(equalTo: container.topAnchor),
        labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),

        tf.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 6),
        tf.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        tf.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        tf.heightAnchor.constraint(equalToConstant: 44),
        tf.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    return container
}

private func createDropdown(textField: inout UITextField?, label: String, placeholder: String) -> UIView {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let labelView = UILabel()
    labelView.text = label
    labelView.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    labelView.textColor = .black
    labelView.translatesAutoresizingMaskIntoConstraints = false

    let tf = UITextField()
    tf.placeholder = placeholder
    tf.borderStyle = .none
    tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
    tf.layer.cornerRadius = 8
    tf.translatesAutoresizingMaskIntoConstraints = false

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
    tf.leftView = paddingView
    tf.leftViewMode = .always

    let dropdownImage = UIImageView(image: UIImage(systemName: "chevron.down"))
    dropdownImage.tintColor = .systemGray
    dropdownImage.translatesAutoresizingMaskIntoConstraints = false
    tf.rightView = dropdownImage
    tf.rightViewMode = .always

    textField = tf

    container.addSubview(labelView)
    container.addSubview(tf)

    NSLayoutConstraint.activate([
        labelView.topAnchor.constraint(equalTo: container.topAnchor),
        labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),

        tf.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 6),
        tf.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        tf.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        tf.heightAnchor.constraint(equalToConstant: 44),
        tf.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    return container
}

private func createTextView(textView: inout UITextView?, placeholder: String, label: String) -> UIView {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let labelView = UILabel()
    labelView.text = label
    labelView.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    labelView.textColor = .black
    labelView.translatesAutoresizingMaskIntoConstraints = false

    let tv = UITextView()
    tv.text = placeholder
    tv.textColor = .systemGray
    tv.backgroundColor = UIColor(white: 0.95, alpha: 1)
    tv.layer.cornerRadius = 8
    tv.font = UIFont.systemFont(ofSize: 14)
    tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    tv.translatesAutoresizingMaskIntoConstraints = false

    textView = tv

    container.addSubview(labelView)
    container.addSubview(tv)

    NSLayoutConstraint.activate([
        labelView.topAnchor.constraint(equalTo: container.topAnchor),
        labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),

        tv.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 6),
        tv.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        tv.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        tv.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    return container
}
