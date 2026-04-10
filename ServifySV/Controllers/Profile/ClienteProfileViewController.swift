import UIKit

class ClienteProfileViewController: UIViewController {

    // MARK: - Properties
    private let usuario: User = MockData.usuarioActual

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemOrange.withAlphaComponent(0.15)
        v.layer.cornerRadius = 50
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 36)
        l.textColor = .systemOrange
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

    private let correoLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let tipoLabel: UILabel = {
        let l = UILabel()
        l.text = "Cliente"
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = .white
        l.backgroundColor = .systemOrange
        l.layer.cornerRadius = 10
        l.clipsToBounds = true
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let statsContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGroupedBackground
        v.layer.cornerRadius = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let solicitudesCountLabel: UILabel = {
        let l = UILabel()
        l.text = "3"
        l.font = UIFont.boldSystemFont(ofSize: 28)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let solicitudesTextLabel: UILabel = {
        let l = UILabel()
        l.text = "Solicitudes"
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let completadasCountLabel: UILabel = {
        let l = UILabel()
        l.text = "1"
        l.font = UIFont.boldSystemFont(ofSize: 28)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let completadasTextLabel: UILabel = {
        let l = UILabel()
        l.text = "Completadas"
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cerrar Sesión", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.layer.borderColor = UIColor.systemRed.cgColor
        btn.layer.borderWidth = 1.5
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Mi Perfil"
        navigationController?.navigationBar.prefersLargeTitles = true

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        avatarView.addSubview(avatarLabel)

        let statsStack = UIStackView(arrangedSubviews: [
            makeStatColumn(count: solicitudesCountLabel, text: solicitudesTextLabel),
            makeDivider(),
            makeStatColumn(count: completadasCountLabel, text: completadasTextLabel)
        ])
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(statsStack)

        [avatarView, nombreLabel, correoLabel, tipoLabel, statsContainer, logoutButton].forEach {
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

            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nombreLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 16),
            nombreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nombreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            correoLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 4),
            correoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            correoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            tipoLabel.topAnchor.constraint(equalTo: correoLabel.bottomAnchor, constant: 8),
            tipoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tipoLabel.widthAnchor.constraint(equalToConstant: 80),
            tipoLabel.heightAnchor.constraint(equalToConstant: 24),

            statsContainer.topAnchor.constraint(equalTo: tipoLabel.bottomAnchor, constant: 28),
            statsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsContainer.heightAnchor.constraint(equalToConstant: 90),

            statsStack.topAnchor.constraint(equalTo: statsContainer.topAnchor),
            statsStack.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor),
            statsStack.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor),

            logoutButton.topAnchor.constraint(equalTo: statsContainer.bottomAnchor, constant: 40),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 48),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
        ])

        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    private func configure() {
        let initials = usuario.nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel.text = usuario.nombre
        correoLabel.text = usuario.correo
    }

    private func makeStatColumn(count: UILabel, text: UILabel) -> UIView {
        let stack = UIStackView(arrangedSubviews: [count, text])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }

    private func makeDivider() -> UIView {
        let v = UIView()
        v.backgroundColor = .separator
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }

    // MARK: - Actions
    @objc private func logoutTapped() {
        navigationController?.popToRootViewController(animated: false)
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}
