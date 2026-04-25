import UIKit

class ChatsListViewController: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .systemGroupedBackground
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private var chats: [Chat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadChats()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Mensajes"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.identifier)
    }

    private func loadChats() {
        guard let userId = AuthManager.shared.currentUser?.id else { return }

        APIManager.shared.getChats(usuarioId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.chats = response.chats
                    self?.tableView.reloadData()

                case .failure:
                    self?.chats = []
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension ChatsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.identifier, for: indexPath) as! ChatListCell
        cell.configure(with: chats[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = ChatViewController(chat: chats[indexPath.row])
        navigationController?.pushViewController(chatVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
