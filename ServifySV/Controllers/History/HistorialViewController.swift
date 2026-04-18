import UIKit

class HistorialViewController: UIViewController {

    private let tabControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Trabajos", "Ingresos"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let trabajosTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor(white: 0.97, alpha: 1)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let ingresosScrollView = UIScrollView()
    private let ingresosContentView = UIView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        title = "Historial"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tabControl)
        view.addSubview(trabajosTableView)

        ingresosScrollView.translatesAutoresizingMaskIntoConstraints = false
        ingresosContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ingresosScrollView)
        ingresosScrollView.addSubview(ingresosContentView)

        NSLayoutConstraint.activate([
            tabControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            tabControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tabControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            trabajosTableView.topAnchor.constraint(equalTo: tabControl.bottomAnchor, constant: 12),
            trabajosTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trabajosTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trabajosTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            ingresosScrollView.topAnchor.constraint(equalTo: tabControl.bottomAnchor, constant: 12),
            ingresosScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ingresosScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ingresosScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            ingresosContentView.topAnchor.constraint(equalTo: ingresosScrollView.topAnchor),
            ingresosContentView.leadingAnchor.constraint(equalTo: ingresosScrollView.leadingAnchor),
            ingresosContentView.trailingAnchor.constraint(equalTo: ingresosScrollView.trailingAnchor),
            ingresosContentView.bottomAnchor.constraint(equalTo: ingresosScrollView.bottomAnchor),
            ingresosContentView.widthAnchor.constraint(equalTo: ingresosScrollView.widthAnchor),
        ])

        tabControl.addTarget(self, action: #selector(tabChanged), for: .valueChanged)

        setupTrabajosTab()
        setupIngresosTab()

        ingresosScrollView.isHidden = true
    }

    @objc private func tabChanged() {
        trabajosTableView.isHidden = tabControl.selectedSegmentIndex == 1
        ingresosScrollView.isHidden = tabControl.selectedSegmentIndex == 0
    }

    private func setupTrabajosTab() {
        trabajosTableView.delegate = self
        trabajosTableView.dataSource = self
        trabajosTableView.register(HistorialCell.self, forCellReuseIdentifier: HistorialCell.identifier)
    }

    private func setupIngresosTab() {
        // Card 1: Ingresos Totales
        let ingresosCard = createStatsCard(title: "Ingresos Totales", value: "$1800", backgroundColor: .systemBlue, textColor: .white)
        ingresosContentView.addSubview(ingresosCard)

        // Card 2: Trabajos
        let trabajosCard = createStatsCard(title: "Trabajos", value: "4", backgroundColor: .systemGreen, textColor: .white)
        ingresosContentView.addSubview(trabajosCard)

        // Card 3: Calificación
        let calificacionCard = createRatingCard()
        ingresosContentView.addSubview(calificacionCard)

        // Resumen Mensual
        let resumenTitle = UILabel()
        resumenTitle.text = "Resumen Mensual"
        resumenTitle.font = UIFont.boldSystemFont(ofSize: 16)
        resumenTitle.translatesAutoresizingMaskIntoConstraints = false
        ingresosContentView.addSubview(resumenTitle)

        let resumenStack = UIStackView()
        resumenStack.axis = .vertical
        resumenStack.spacing = 12
        resumenStack.translatesAutoresizingMaskIntoConstraints = false
        ingresosContentView.addSubview(resumenStack)

        let meses = [
            ("Febrero 2026", "4 trabajos", "+$1800"),
            ("Enero 2026", "6 trabajos", "+$3,200"),
            ("Diciembre 2025", "5 trabajos", "+$2,800")
        ]

        for (mes, trabajos, monto) in meses {
            let row = createResumenRow(mes: mes, trabajos: trabajos, monto: monto)
            resumenStack.addArrangedSubview(row)
        }

        // Ingresos por Categoría
        let categoriasTitle = UILabel()
        categoriasTitle.text = "Ingresos por Categoría"
        categoriasTitle.font = UIFont.boldSystemFont(ofSize: 16)
        categoriasTitle.translatesAutoresizingMaskIntoConstraints = false
        ingresosContentView.addSubview(categoriasTitle)

        let categoriasStack = UIStackView()
        categoriasStack.axis = .vertical
        categoriasStack.spacing = 16
        categoriasStack.translatesAutoresizingMaskIntoConstraints = false
        ingresosContentView.addSubview(categoriasStack)

        let categorias = [
            ("Instalaciones Eléctricas", "$400", 1),
            ("Muebles a Medida", "$600", 1),
            ("Pintura Residencial", "$300", 1),
            ("Construcción y Remodelación", "$500", 1)
        ]

        for (categoria, monto, trabajos) in categorias {
            let row = createCategoriaRow(categoria: categoria, monto: monto, trabajos: trabajos)
            categoriasStack.addArrangedSubview(row)
        }

        NSLayoutConstraint.activate([
            ingresosCard.topAnchor.constraint(equalTo: ingresosContentView.topAnchor, constant: 16),
            ingresosCard.leadingAnchor.constraint(equalTo: ingresosContentView.leadingAnchor, constant: 16),
            ingresosCard.trailingAnchor.constraint(equalTo: ingresosContentView.centerXAnchor, constant: -6),
            ingresosCard.heightAnchor.constraint(equalToConstant: 100),

            trabajosCard.topAnchor.constraint(equalTo: ingresosContentView.topAnchor, constant: 16),
            trabajosCard.leadingAnchor.constraint(equalTo: ingresosContentView.centerXAnchor, constant: 6),
            trabajosCard.trailingAnchor.constraint(equalTo: ingresosContentView.trailingAnchor, constant: -16),
            trabajosCard.heightAnchor.constraint(equalToConstant: 100),

            calificacionCard.topAnchor.constraint(equalTo: ingresosCard.bottomAnchor, constant: 12),
            calificacionCard.leadingAnchor.constraint(equalTo: ingresosContentView.leadingAnchor, constant: 16),
            calificacionCard.trailingAnchor.constraint(equalTo: ingresosContentView.trailingAnchor, constant: -16),
            calificacionCard.heightAnchor.constraint(equalToConstant: 80),

            resumenTitle.topAnchor.constraint(equalTo: calificacionCard.bottomAnchor, constant: 20),
            resumenTitle.leadingAnchor.constraint(equalTo: ingresosContentView.leadingAnchor, constant: 16),

            resumenStack.topAnchor.constraint(equalTo: resumenTitle.bottomAnchor, constant: 12),
            resumenStack.leadingAnchor.constraint(equalTo: ingresosContentView.leadingAnchor, constant: 16),
            resumenStack.trailingAnchor.constraint(equalTo: ingresosContentView.trailingAnchor, constant: -16),

            categoriasTitle.topAnchor.constraint(equalTo: resumenStack.bottomAnchor, constant: 24),
            categoriasTitle.leadingAnchor.constraint(equalTo: ingresosContentView.leadingAnchor, constant: 16),

            categoriasStack.topAnchor.constraint(equalTo: categoriasTitle.bottomAnchor, constant: 12),
            categoriasStack.leadingAnchor.constraint(equalTo: ingresosContentView.leadingAnchor, constant: 16),
            categoriasStack.trailingAnchor.constraint(equalTo: ingresosContentView.trailingAnchor, constant: -16),
            categoriasStack.bottomAnchor.constraint(equalTo: ingresosContentView.bottomAnchor, constant: -20),
        ])
    }

    private func createStatsCard(title: String, value: String, backgroundColor: UIColor, textColor: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = backgroundColor
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = textColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 28)
        valueLabel.textColor = textColor
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),

            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
        ])

        return card
    }

    private func createRatingCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .systemYellow
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Calificación Promedio"
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)

        let ratingLabel = UILabel()
        ratingLabel.text = "4.8 ⭐⭐⭐⭐⭐"
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        ratingLabel.textColor = .white
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),

            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            ratingLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
        ])

        return card
    }

    private func createResumenRow(mes: String, trabajos: String, monto: String) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        let mesLabel = UILabel()
        mesLabel.text = mes
        mesLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        mesLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(mesLabel)

        let trabajosLabel = UILabel()
        trabajosLabel.text = trabajos
        trabajosLabel.font = UIFont.systemFont(ofSize: 12)
        trabajosLabel.textColor = .systemGray
        trabajosLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(trabajosLabel)

        let montoLabel = UILabel()
        montoLabel.text = monto
        montoLabel.font = UIFont.boldSystemFont(ofSize: 14)
        montoLabel.textColor = .systemGreen
        montoLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(montoLabel)

        NSLayoutConstraint.activate([
            mesLabel.topAnchor.constraint(equalTo: row.topAnchor),
            mesLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),

            trabajosLabel.topAnchor.constraint(equalTo: mesLabel.bottomAnchor, constant: 2),
            trabajosLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            trabajosLabel.bottomAnchor.constraint(equalTo: row.bottomAnchor),

            montoLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            montoLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor),
        ])

        row.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return row
    }

    private func createCategoriaRow(categoria: String, monto: String, trabajos: Int) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        let categoriaLabel = UILabel()
        categoriaLabel.text = categoria
        categoriaLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        categoriaLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(categoriaLabel)

        let montoLabel = UILabel()
        montoLabel.text = monto
        montoLabel.font = UIFont.boldSystemFont(ofSize: 13)
        montoLabel.textColor = .systemBlue
        montoLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(montoLabel)

        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.25
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = UIColor.systemBlue.withAlphaComponent(0.2)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(progressView)

        let trabajosLabel = UILabel()
        trabajosLabel.text = "\(trabajos) trabajo"
        trabajosLabel.font = UIFont.systemFont(ofSize: 11)
        trabajosLabel.textColor = .systemGray
        trabajosLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(trabajosLabel)

        NSLayoutConstraint.activate([
            categoriaLabel.topAnchor.constraint(equalTo: row.topAnchor),
            categoriaLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),

            montoLabel.topAnchor.constraint(equalTo: row.topAnchor),
            montoLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor),

            progressView.topAnchor.constraint(equalTo: categoriaLabel.bottomAnchor, constant: 6),
            progressView.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 4),

            trabajosLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 4),
            trabajosLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            trabajosLabel.bottomAnchor.constraint(equalTo: row.bottomAnchor),
        ])

        row.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return row
    }
}

extension HistorialViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistorialCell.identifier, for: indexPath) as! HistorialCell

        let servicios = [
            ("Instalaciones Eléctricas", "Pedro Ramirez", "$400", "2026-02-25", "⭐⭐⭐⭐⭐", "Excelente trabajo, muy profesional y puntual"),
            ("Muebles a Medida", "María González", "$600", "2026-02-20", "⭐⭐⭐⭐⭐", "Quedó perfecto, superó mis expectativas"),
            ("Pintura Residencial", "Jorge Martínez", "$300", "2026-02-15", "⭐⭐⭐⭐", "Buen trabajo, aunque tardó un poco")
        ]

        let servicio = servicios[indexPath.row]
        cell.configure(titulo: servicio.0, profesional: servicio.1, precio: servicio.2, fecha: servicio.3, rating: servicio.4, comentario: servicio.5)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
}

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
