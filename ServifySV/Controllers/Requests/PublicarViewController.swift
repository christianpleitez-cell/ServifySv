import UIKit

class PublicarViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerStack = UIStackView()
    private let fotoUploadView = UIView()
    private let fotoLabel = UILabel()

    private let tituloField = createTextField(placeholder: "Ej: Construcción y Remodelación", label: "Título del servicio")
    private let categoriaField = createDropdown(label: "Categoría", placeholder: "Selecciona una categoría")
    private let descripcionField = createTextView(placeholder: "Describe tu experiencia, especialidades y qué servicios ofreces...", label: "Descripción")
    private let precioField = createTextField(placeholder: "500", label: "Precio por día", keyboardType: .decimalPad)
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
        fotoUploadView.layer.borderStyle = .dashed
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
        let alert = UIAlertController(title: "Servicio Publicado", message: "Tu servicio ha sido publicado exitosamente", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

private func createTextField(placeholder: String, label: String, keyboardType: UIKeyboardType = .default) -> UIView {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let labelView = UILabel()
    labelView.text = label
    labelView.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    labelView.textColor = .black
    labelView.translatesAutoresizingMaskIntoConstraints = false

    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .none
    textField.keyboardType = keyboardType
    textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
    textField.layer.cornerRadius = 8
    textField.translatesAutoresizingMaskIntoConstraints = false

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
    textField.leftView = paddingView
    textField.leftViewMode = .always

    container.addSubview(labelView)
    container.addSubview(textField)

    NSLayoutConstraint.activate([
        labelView.topAnchor.constraint(equalTo: container.topAnchor),
        labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),

        textField.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 6),
        textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        textField.heightAnchor.constraint(equalToConstant: 44),
        textField.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    return container
}

private func createDropdown(label: String, placeholder: String) -> UIView {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let labelView = UILabel()
    labelView.text = label
    labelView.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    labelView.textColor = .black
    labelView.translatesAutoresizingMaskIntoConstraints = false

    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .none
    textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
    textField.layer.cornerRadius = 8
    textField.translatesAutoresizingMaskIntoConstraints = false

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
    textField.leftView = paddingView
    textField.leftViewMode = .always

    let dropdownImage = UIImageView(image: UIImage(systemName: "chevron.down"))
    dropdownImage.tintColor = .systemGray
    dropdownImage.translatesAutoresizingMaskIntoConstraints = false
    textField.rightView = dropdownImage
    textField.rightViewMode = .always

    container.addSubview(labelView)
    container.addSubview(textField)

    NSLayoutConstraint.activate([
        labelView.topAnchor.constraint(equalTo: container.topAnchor),
        labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),

        textField.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 6),
        textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        textField.heightAnchor.constraint(equalToConstant: 44),
        textField.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    return container
}

private func createTextView(placeholder: String, label: String) -> UIView {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let labelView = UILabel()
    labelView.text = label
    labelView.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    labelView.textColor = .black
    labelView.translatesAutoresizingMaskIntoConstraints = false

    let textView = UITextView()
    textView.text = placeholder
    textView.textColor = .systemGray
    textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    textView.layer.cornerRadius = 8
    textView.font = UIFont.systemFont(ofSize: 14)
    textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    textView.translatesAutoresizingMaskIntoConstraints = false

    container.addSubview(labelView)
    container.addSubview(textView)

    NSLayoutConstraint.activate([
        labelView.topAnchor.constraint(equalTo: container.topAnchor),
        labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),

        textView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 6),
        textView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        textView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        textView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    return container
}
