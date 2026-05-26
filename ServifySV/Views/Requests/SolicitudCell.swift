import UIKit

class SolicitudCell: UITableViewCell {

    static let identifier = "SolicitudCell"

    // MARK: - UI
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 6
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        v.layer.cornerRadius = 24
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

    private let clienteLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let estadoBadge: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .systemOrange
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let servicioLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .systemOrange
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let fechaLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .systemGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descripcionLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .systemBlue
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let precioLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.textColor = .systemBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let chatButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "message"), for: .normal)
        btn.tintColor = .systemGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let acceptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        btn.tintColor = .systemGreen
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
    }()

    private let rejectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .systemRed
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        avatarView.addSubview(avatarLabel)
        cardView.addSubview(avatarView)
        cardView.addSubview(clienteLabel)
        cardView.addSubview(estadoBadge)
        cardView.addSubview(servicioLabel)
        cardView.addSubview(fechaLabel)
        cardView.addSubview(descripcionLabel)
        cardView.addSubview(precioLabel)
        cardView.addSubview(chatButton)
        cardView.addSubview(acceptButton)
        cardView.addSubview(rejectButton)

        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            avatarView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            avatarView.widthAnchor.constraint(equalToConstant: 48),
            avatarView.heightAnchor.constraint(equalToConstant: 48),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            clienteLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            clienteLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),

            estadoBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            estadoBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            servicioLabel.topAnchor.constraint(equalTo: clienteLabel.bottomAnchor, constant: 2),
            servicioLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),

            fechaLabel.topAnchor.constraint(equalTo: servicioLabel.bottomAnchor, constant: 2),
            fechaLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),

            descripcionLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 10),
            descripcionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            descripcionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            precioLabel.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 8),
            precioLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),

            chatButton.topAnchor.constraint(equalTo: precioLabel.topAnchor),
            chatButton.leadingAnchor.constraint(equalTo: precioLabel.trailingAnchor, constant: 16),
            chatButton.widthAnchor.constraint(equalToConstant: 24),
            chatButton.heightAnchor.constraint(equalToConstant: 24),

            acceptButton.topAnchor.constraint(equalTo: precioLabel.topAnchor),
            acceptButton.leadingAnchor.constraint(equalTo: chatButton.trailingAnchor, constant: 16),
            acceptButton.widthAnchor.constraint(equalToConstant: 28),
            acceptButton.heightAnchor.constraint(equalToConstant: 28),

            rejectButton.topAnchor.constraint(equalTo: precioLabel.topAnchor),
            rejectButton.leadingAnchor.constraint(equalTo: acceptButton.trailingAnchor, constant: 8),
            rejectButton.widthAnchor.constraint(equalToConstant: 28),
            rejectButton.heightAnchor.constraint(equalToConstant: 28),
            rejectButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
        ])
    }

    func configure(with solicitud: Solicitud) {
        let nombre = solicitud.cliente?.nombre ?? ""
        let initials = nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(1))
        clienteLabel.text = nombre
        servicioLabel.text = solicitud.servicio?.nombreServicio ?? ""
        descripcionLabel.text = solicitud.descripcion
        precioLabel.text = "$\(Int(solicitud.servicio?.precioReferencia ?? 0))"
        estadoBadge.text = solicitud.estado
        fechaLabel.text = solicitud.fechaSolicitud ?? ""

        updateStateAppearance(for: solicitud.estado)
    }

    private func updateStateAppearance(for estado: String) {
        switch estado {
        case "pendiente":
            estadoBadge.textColor = .systemOrange
            acceptButton.isHidden = false
            rejectButton.isHidden = false
        case "aceptada":
            estadoBadge.textColor = .systemGreen
            acceptButton.isHidden = true
            rejectButton.isHidden = true
        case "completada":
            estadoBadge.textColor = .systemGray
            acceptButton.isHidden = true
            rejectButton.isHidden = true
        case "cancelada", "rechazada":
            estadoBadge.textColor = .systemRed
            acceptButton.isHidden = true
            rejectButton.isHidden = true
        default:
            estadoBadge.textColor = .systemBlue
            acceptButton.isHidden = true
            rejectButton.isHidden = true
        }
    }
}
