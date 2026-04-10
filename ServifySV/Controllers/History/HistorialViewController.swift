import UIKit

class HistorialViewController: UIViewController {

    // MARK: - Properties
    private var historial: [Solicitud] = MockData.solicitudes.filter { $0.estado == .completada || $0.estado == .cancelada }

    // MARK: - UI Components
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .systemGroupedBackground
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let emptyStateView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "Sin historial aún"
        l.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let emptySubLabel: UILabel = {
        let l = UILabel()
        l.text = "Tus servicios completados aparecerán aquí"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .tertiaryLabel
        l.textAlignment = .center
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Historial"
        navigationController?.navigationBar.prefersLargeTitles = true

        emptyStateView.addSubview(emptyLabel)
        emptyStateView.addSubview(emptySubLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            emptyLabel.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),

            emptySubLabel.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 8),
            emptySubLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptySubLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistorialCell.self, forCellReuseIdentifier: HistorialCell.identifier)

        emptyStateView.isHidden = !historial.isEmpty
        tableView.isHidden = historial.isEmpty
    }
}

// MARK: - UITableViewDataSource & Delegate
extension HistorialViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historial.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistorialCell.identifier, for: indexPath) as! HistorialCell
        cell.configure(with: historial[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = SolicitudDetailViewController(solicitud: historial[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
