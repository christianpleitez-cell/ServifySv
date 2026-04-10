import UIKit

class SolicitudesViewController: UIViewController {

    // MARK: - Properties
    private var solicitudes: [Solicitud] = MockData.solicitudes
    private var filteredSolicitudes: [Solicitud] = []
    private var selectedFilter: EstadoSolicitud? = nil

    // MARK: - UI Components
    private let filterSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Todas", "Pendientes", "Activas", "Completadas"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .systemGroupedBackground
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No hay solicitudes"
        l.textColor = .secondaryLabel
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .center
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyFilter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyFilter()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Solicitudes"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(filterSegment)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            filterSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: filterSegment.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SolicitudCell.self, forCellReuseIdentifier: SolicitudCell.identifier)

        filterSegment.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
    }

    private func applyFilter() {
        switch filterSegment.selectedSegmentIndex {
        case 1: filteredSolicitudes = solicitudes.filter { $0.estado == .pendiente }
        case 2: filteredSolicitudes = solicitudes.filter { $0.estado == .aceptada || $0.estado == .enProgreso }
        case 3: filteredSolicitudes = solicitudes.filter { $0.estado == .completada }
        default: filteredSolicitudes = solicitudes
        }
        emptyLabel.isHidden = !filteredSolicitudes.isEmpty
        tableView.reloadData()
    }

    // MARK: - Actions
    @objc private func filterChanged() {
        applyFilter()
    }
}

// MARK: - UITableViewDataSource & Delegate
extension SolicitudesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredSolicitudes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SolicitudCell.identifier, for: indexPath) as! SolicitudCell
        cell.configure(with: filteredSolicitudes[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = SolicitudDetailViewController(solicitud: filteredSolicitudes[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
