import UIKit

class ProfesionalHomeViewController: UIViewController {

    private var servicios: [Servicio] = []
    private var calificacionPromedio: Double = 0
    private var totalCalificaciones: Int = 0

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadServicios()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        navigationController?.isNavigationBarHidden = true

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        let holaLabel = UILabel()
        let userName = AuthManager.shared.currentUser?.nombre ?? "Usuario"
        holaLabel.text = "Hola, \(userName)"
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

        let initials = userName.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        let avatarButton = UIButton(type: .system)
        avatarButton.backgroundColor = .systemBlue
        avatarButton.setTitle(String(initials.prefix(2)).uppercased(), for: .normal)
        avatarButton.setTitleColor(.white, for: .normal)
        avatarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        avatarButton.layer.cornerRadius = 20
        avatarButton.layer.borderWidth = 2
        avatarButton.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(avatarButton)

        NSLayoutConstraint.activate([
            holaLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            holaLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: holaLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            subtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),

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

    private func loadServicios() {
        guard let profesionalId = AuthManager.shared.currentUser?.id_profesional else { return }

        APIManager.shared.getMisServicios(profesionalId: profesionalId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.servicios = response.servicios
                    self?.tableView.reloadData()
                case .failure:
                    self?.servicios = []
                    self?.tableView.reloadData()
                }
            }
        }

        APIManager.shared.getResenasProfesional(profesionalId: profesionalId) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let response) = result, let stats = response.estadisticas {
                    self?.calificacionPromedio = stats.calificacionPromedio
                    self?.totalCalificaciones = stats.totalResenas
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension ProfesionalHomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        servicios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfesionalCell.identifier, for: indexPath) as! ProfesionalCell

        if let currentUser = AuthManager.shared.currentUser {
            let profesionalId = currentUser.id_profesional ?? 0
            let profesional = Profesional(
                id: profesionalId,
                usuario: User(
                    id: profesionalId,
                    nombre: currentUser.nombre,
                    correo: currentUser.correo,
                    tipoUsuario: currentUser.tipo_usuario == "profesional" ? .profesional : .cliente,
                    fechaRegistro: nil,
                    fotoPerfil: nil
                ),
                especialidad: currentUser.nombre,
                descripcion: "Mi servicio",
                experiencia: 0,
                estadoVerificacion: "Verificado",
                calificacionPromedio: calificacionPromedio,
                totalCalificaciones: totalCalificaciones,
                servicios: [servicios[indexPath.row]]
            )
            cell.configure(with: profesional)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        280
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let servicio = servicios[indexPath.row]

        let sheet = UIAlertController(title: servicio.nombreServicio, message: nil, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Editar servicio", style: .default) { [weak self] _ in
            let vc = EditarServicioViewController(servicio: servicio)
            self?.navigationController?.pushViewController(vc, animated: true)
        })

        sheet.addAction(UIAlertAction(title: "Eliminar servicio", style: .destructive) { [weak self] _ in
            self?.confirmEliminar(servicio: servicio)
        })

        sheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(sheet, animated: true)
    }
}

extension ProfesionalHomeViewController {

    private func confirmEliminar(servicio: Servicio) {
        let alert = UIAlertController(
            title: "Eliminar servicio",
            message: "¿Seguro que deseas eliminar \"\(servicio.nombreServicio)\"? Esta acción no se puede deshacer.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            APIManager.shared.deleteServicio(servicioId: servicio.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.loadServicios()
                    case .failure(let error):
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
