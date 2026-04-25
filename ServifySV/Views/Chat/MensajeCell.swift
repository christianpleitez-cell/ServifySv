import UIKit

// MARK: - Mensaje Propio (derecha)
class MensajeCell: UITableViewCell {

    static let identifier = "MensajeCell"

    private let bubbleView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.layer.cornerRadius = 16
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = .white
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11)
        l.textColor = .tertiaryLabel
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(bubbleView)
        contentView.addSubview(timeLabel)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 260),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),

            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with mensaje: Mensaje) {
        messageLabel.text = mensaje.contenido
        timeLabel.text = mensaje.fechaEnvio ?? ""
    }
}

// MARK: - Mensaje Recibido (izquierda)
class MensajeRecibidoCell: UITableViewCell {

    static let identifier = "MensajeRecibidoCell"

    private let bubbleView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        v.layer.cornerRadius = 16
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let senderLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.textColor = .systemBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11)
        l.textColor = .tertiaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        bubbleView.addSubview(senderLabel)
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(bubbleView)
        contentView.addSubview(timeLabel)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 260),

            senderLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            senderLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            senderLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),

            messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 2),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),

            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with mensaje: Mensaje) {
        senderLabel.text = mensaje.remitente?.nombre ?? ""
        messageLabel.text = mensaje.contenido
        timeLabel.text = mensaje.fechaEnvio ?? ""
    }
}
