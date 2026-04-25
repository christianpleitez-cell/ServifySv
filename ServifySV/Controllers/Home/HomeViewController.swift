import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private var profesionales: [Profesional] = MockData.profesionales
    private var categoriaSeleccionada: CategoriaServicio? = nil

    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar profesional o servicio..."
        sb.searchBarStyle = .minimal
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 40)
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .systemGroupedBackground
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfesionales()
    }

    // MARK: - Setup
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
        subtitleLabel.text = "Encuentra tu profesional"
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(subtitleLabel)

        let avatarButton = UIButton(type: .system)
        avatarButton.backgroundColor = .systemBlue
        avatarButton.setTitle("C", for: .normal)
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

        view.addSubview(searchBar)
        view.addSubview(categoryCollectionView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            categoryCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 12),
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

    private func setupCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    }

    private func loadProfesionales() {
        if let categoria = categoriaSeleccionada {
            APIManager.shared.getProfesionalesByCategoria(categoria: categoria.rawValue) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.profesionales = response.profesionales
                        self?.tableView.reloadData()
                    case .failure:
                        self?.profesionales = []
                        self?.tableView.reloadData()
                    }
                }
            }
        } else {
            APIManager.shared.getProfesionales { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.profesionales = response.profesionales
                        self?.tableView.reloadData()
                    case .failure:
                        self?.profesionales = []
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profesionales.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfesionalCell.identifier, for: indexPath) as! ProfesionalCell
        cell.configure(with: profesionales[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        280
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ProfesionalDetailViewController(profesional: profesionales[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CategoriaServicio.allCases.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        if indexPath.item == 0 {
            cell.configure(with: "Todos", isSelected: categoriaSeleccionada == nil)
        } else {
            let cat = CategoriaServicio.allCases[indexPath.item - 1]
            cell.configure(with: cat.rawValue, isSelected: categoriaSeleccionada == cat)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            categoriaSeleccionada = nil
        } else {
            categoriaSeleccionada = CategoriaServicio.allCases[indexPath.item - 1]
        }
        collectionView.reloadData()
        loadProfesionales()
    }
}
