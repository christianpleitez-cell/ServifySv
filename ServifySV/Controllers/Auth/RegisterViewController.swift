import UIKit

class RegisterViewController: UIViewController {

    private var selectedUserType: String = "cliente"

    // MARK: - UI Components
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoIcon: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "👔"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Crear Cuenta"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Únete a nuestra comunidad"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registro"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let clienteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 12
        btn.tag = 0

        let config = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        container.foregroundColor = .systemBlue

        var fullConfig = config
        fullConfig.attributedTitle = AttributeString("👤\nCliente\nBusca servicios", attributes: container)
        fullConfig.imagePadding = 4
        btn.configuration = fullConfig

        return btn
    }()

    private let profesionalButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1)
        btn.layer.borderColor = UIColor.clear.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 12
        btn.tag = 1

        let config = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        container.foregroundColor = .darkGray

        var fullConfig = config
        fullConfig.attributedTitle = AttributeString("👔\nProfesional\nOfrece servicios", attributes: container)
        fullConfig.imagePadding = 4
        btn.configuration = fullConfig

        return btn
    }()

    private let nombreTextField = createTextField(placeholder: "Juan Pérez", label: "Nombre Completo")
    private let emailTextField = createTextField(placeholder: "correo@ejemplo.com", label: "Correo Electrónico", keyboardType: .emailAddress)
    private let telefonoTextField = createTextField(placeholder: "+52 555 1234 5678", label: "Teléfono", keyboardType: .phonePad)
    private let passwordTextField = createTextField(placeholder: "••••••••", label: "Contraseña", isSecure: true)
    private let confirmPasswordTextField = createTextField(placeholder: "••••••••", label: "Confirmar Contraseña", isSecure: true)

    private let registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Crear Cuenta", for: .normal)
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        let attributedString = NSMutableAttributedString(string: "¿Ya tienes cuenta? ")
        attributedString.append(NSAttributedString(string: "Inicia Sesión", attributes: [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 20))

        btn.setAttributedTitle(attributedString, for: .normal)

        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemBlue

        view.addSubview(headerView)
        headerView.addSubview(logoIcon)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)

        view.addSubview(cardView)

        let typeSelectorStack = UIStackView(arrangedSubviews: [clienteButton, profesionalButton])
        typeSelectorStack.axis = .horizontal
        typeSelectorStack.spacing = 12
        typeSelectorStack.distribution = .fillEqually
        typeSelectorStack.translatesAutoresizingMaskIntoConstraints = false

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(scrollView)

        let cardStackView = UIStackView(arrangedSubviews: [
            cardTitleLabel, typeSelectorStack, nombreTextField, emailTextField,
            telefonoTextField, passwordTextField, confirmPasswordTextField,
            registerButton, loginButton
        ])
        cardStackView.axis = .vertical
        cardStackView.spacing = 12
        cardStackView.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        cardStackView.isLayoutMarginsRelativeArrangement = true
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cardStackView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            logoIcon.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoIcon.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: 60),
            logoIcon.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: logoIcon.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            scrollView.topAnchor.constraint(equalTo: cardView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            cardStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cardStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cardStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cardStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cardStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            clienteButton.heightAnchor.constraint(equalToConstant: 80),
            profesionalButton.heightAnchor.constraint(equalToConstant: 80),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        clienteButton.addTarget(self, action: #selector(userTypeSelected(_:)), for: .touchUpInside)
        profesionalButton.addTarget(self, action: #selector(userTypeSelected(_:)), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func userTypeSelected(_ sender: UIButton) {
        selectedUserType = sender.tag == 0 ? "cliente" : "profesional"

        let isCliente = sender.tag == 0
        clienteButton.backgroundColor = isCliente ? .white : UIColor(white: 0.95, alpha: 1)
        clienteButton.layer.borderColor = isCliente ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
        clienteButton.layer.borderWidth = isCliente ? 2 : 0

        profesionalButton.backgroundColor = isCliente ? UIColor(white: 0.95, alpha: 1) : .white
        profesionalButton.layer.borderColor = isCliente ? UIColor.clear.cgColor : UIColor.systemBlue.cgColor
        profesionalButton.layer.borderWidth = isCliente ? 0 : 2
    }

    @objc private func registerTapped() {
        let tabBar = MainTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }

    @objc private func loginTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Helper
private func createTextField(placeholder: String, label: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) -> UIView {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let labelView = UILabel()
    labelView.text = label
    labelView.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    labelView.textColor = .black
    labelView.translatesAutoresizingMaskIntoConstraints = false

    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .none
    textField.keyboardType = keyboardType
    textField.isSecureTextEntry = isSecure
    if !isSecure {
        textField.autocapitalizationType = .none
    }
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
        labelView.trailingAnchor.constraint(equalTo: container.trailingAnchor),

        textField.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 4),
        textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        textField.heightAnchor.constraint(equalToConstant: 44),
        textField.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    return container
}
