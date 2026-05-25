import UIKit

class ProfesionalHomeViewController: UIViewController {

    private var servicios: [Servicio] = []

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

    private func loadServicios() {
        guard let profesionalId = AuthManager.shared.currentUser?.id else { return }

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
    }
}

extension ProfesionalHomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        servicios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfesionalCell.identifier, for: indexPath) as! ProfesionalCell

        if let currentUser = AuthManager.shared.currentUser {
            let profesional = Profesional(
                id: currentUser.id,
                usuario: User(
                    id: currentUser.id,
                    nombre: currentUser.nombre,
                    correo: currentUser.correo,
                    tipoUsuario: currentUser.tipo_usuario == "profesional" ? .profesional : .cliente,
                    fechaRegistro: Date(),
                    fotoPerfil: nil
                ),
                especialidad: currentUser.nombre,
                descripcion: "Mi servicio",
                experiencia: 0,
                estadoVerificacion: "Verificado",
                calificacionPromedio: 0,
                totalCalificaciones: 0,
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
