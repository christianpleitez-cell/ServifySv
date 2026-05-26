import UIKit

class ChatListCell: UITableViewCell {

    static let identifier = "ChatListCell"

    private let avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        v.layer.cornerRadius = 22
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textColor = .systemBlue
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nombreLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let ultimoMensajeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let horaLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .tertiaryLabel
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        avatarView.addSubview(avatarLabel)
        [avatarView, nombreLabel, ultimoMensajeLabel, horaLabel].forEach { contentView.addSubview($0) }
        accessoryType = .disclosureIndicator

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 44),
            avatarView.heightAnchor.constraint(equalToConstant: 44),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nombreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            nombreLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nombreLabel.trailingAnchor.constraint(equalTo: horaLabel.leadingAnchor, constant: -8),

            ultimoMensajeLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 2),
            ultimoMensajeLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            ultimoMensajeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            horaLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            horaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            horaLabel.widthAnchor.constraint(equalToConstant: 60),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with chat: Chat) {
        let nombre = chat.solicitud?.profesional?.usuario?.nombre ?? ""
        let initials = nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel.text = nombre
        ultimoMensajeLabel.text = chat.mensajes?.last?.contenido ?? "Sin mensajes"
        horaLabel.text = chat.mensajes?.last?.fechaEnvio ?? ""
    }
}
