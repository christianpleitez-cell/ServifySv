import UIKit

class ProfesionalHomeViewController: UIViewController {

    private var servicios: [Servicio] = MockData.serviciosProfesional

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = UIColor(white: 0.97, alpha: 1)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        navigationController?.isNavigationBarHidden = true

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        let holaLabel = UILabel()
        holaLabel.text = "Hola, Juan"
        holaLabel.font = UIFont.boldSystemFont(ofSize: 24)
        holaLabel.textColor = .black
        holaLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(holaLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Tus servicios"
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(subtitleLabel)

        let avatarButton = UIButton(type: .system)
        avatarButton.backgroundColor = .systemBlue
        avatarButton.setTitle("J", for: .normal)
        avatarButton.setTitleColor(.white, for: .normal)
        avatarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        avatarButton.layer.cornerRadius = 20
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(avatarButton)

        NSLayoutConstraint.activate([
            holaLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            holaLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: holaLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),

            avatarButton.centerYAnchor.constraint(equalTo: holaLabel.centerYAnchor),
            avatarButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            avatarButton.widthAnchor.constraint(equalToConstant: 40),
            avatarButton.heightAnchor.constraint(equalToConstant: 40),
        ])

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfesionalCell.self, forCellReuseIdentifier: ProfesionalCell.identifier)
    }
}

extension ProfesionalHomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        servicios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfesionalCell.identifier, for: indexPath) as! ProfesionalCell

        let profesional = Profesional(
            id: 1,
            usuario: User(id: 1, nombre: "Juan Pérez", correo: "juan@example.com", tipoUsuario: .profesional, fechaRegistro: Date(), fotoPerfil: nil),
            especialidad: "Albañilería",
            descripcion: "Servicio profesional de albañilería",
            experiencia: 10,
            estadoVerificacion: "Verificado",
            calificacionPromedio: 4.8,
            totalCalificaciones: 45,
            servicios: [servicios[indexPath.row]]
        )

        cell.configure(with: profesional)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        280
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
