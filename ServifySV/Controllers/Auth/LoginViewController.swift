import UIKit

class LoginViewController: UIViewController {

    private var selectedUserType: String = "cliente"

    // MARK: - UI Components
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
        label.text = "Servify"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Conecta con profesionales"
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
        label.text = "Iniciar Sesión"
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
        container.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        container.foregroundColor = .systemBlue

        var fullConfig = config
        fullConfig.attributedTitle = AttributeString("👤\nCliente", attributes: container)
        fullConfig.imagePadding = 8
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
        container.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        container.foregroundColor = .darkGray

        var fullConfig = config
        fullConfig.attributedTitle = AttributeString("👔\nProfesional", attributes: container)
        fullConfig.imagePadding = 8
        btn.configuration = fullConfig

        return btn
    }()

    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "correo@ejemplo.com"
        tf.borderStyle = .none
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.layer.cornerRadius = 8
        tf.translatesAutoresizingMaskIntoConstraints = false

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftView = paddingView
        tf.leftViewMode = .always

        return tf
    }()

    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "••••••••"
        tf.borderStyle = .none
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.layer.cornerRadius = 8
        tf.translatesAutoresizingMaskIntoConstraints = false

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftView = paddingView
        tf.leftViewMode = .always

        return tf
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Iniciar Sesión", for: .normal)
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        let attributedString = NSMutableAttributedString(string: "¿No tienes cuenta? ")
        attributedString.append(NSAttributedString(string: "Regístrate", attributes: [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 19))

        btn.setAttributedTitle(attributedString, for: .normal)

        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemBlue
        navigationController?.isNavigationBarHidden = true

        view.addSubview(logoIcon)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(cardView)

        let typeSelectorStack = UIStackView(arrangedSubviews: [clienteButton, profesionalButton])
        typeSelectorStack.axis = .horizontal
        typeSelectorStack.spacing = 16
        typeSelectorStack.distribution = .fillEqually
        typeSelectorStack.translatesAutoresizingMaskIntoConstraints = false

        let emailLabelStack = UIStackView()
        emailLabelStack.axis = .vertical
        emailLabelStack.spacing = 4
        emailLabelStack.translatesAutoresizingMaskIntoConstraints = false

        let emailLabel = UILabel()
        emailLabel.text = "Correo Electrónico"
        emailLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        emailLabel.textColor = .black
        emailLabelStack.addArrangedSubview(emailLabel)
        emailLabelStack.addArrangedSubview(emailTextField)

        let passwordLabelStack = UIStackView()
        passwordLabelStack.axis = .vertical
        passwordLabelStack.spacing = 4
        passwordLabelStack.translatesAutoresizingMaskIntoConstraints = false

        let passwordLabel = UILabel()
        passwordLabel.text = "Contraseña"
        passwordLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        passwordLabel.textColor = .black
        passwordLabelStack.addArrangedSubview(passwordLabel)
        passwordLabelStack.addArrangedSubview(passwordTextField)

        let cardStackView = UIStackView(arrangedSubviews: [
            cardTitleLabel, typeSelectorStack, emailLabelStack, passwordLabelStack, loginButton, registerButton
        ])
        cardStackView.axis = .vertical
        cardStackView.spacing = 16
        cardStackView.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        cardStackView.isLayoutMarginsRelativeArrangement = true
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(cardStackView)

        NSLayoutConstraint.activate([
            logoIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: 80),
            logoIcon.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: logoIcon.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            cardStackView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cardStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            cardStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            clienteButton.heightAnchor.constraint(equalToConstant: 80),
            profesionalButton.heightAnchor.constraint(equalToConstant: 80),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
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

    @objc private func loginTapped() {
        let tabBar = MainTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }

    @objc private func registerTapped() {
        let registerVC = RegisterViewController()
        let nav = UINavigationController(rootViewController: registerVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
