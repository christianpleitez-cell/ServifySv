import UIKit

class HistorialCell: UITableViewCell {

    static let identifier = "HistorialCell"

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

    private let tituloLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let precioLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.textColor = .systemBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let contactoLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .systemGray
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

    private let estadoBadge: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let estadoLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 11)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let comentarioLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .systemBlue
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        estadoBadge.addSubview(estadoLabel)
        [tituloLabel, precioLabel, contactoLabel, fechaLabel, estadoBadge, comentarioLabel].forEach { cardView.addSubview($0) }
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            tituloLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            tituloLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            tituloLabel.trailingAnchor.constraint(lessThanOrEqualTo: precioLabel.leadingAnchor, constant: -8),

            precioLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            precioLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            contactoLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 4),
            contactoLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            contactoLabel.trailingAnchor.constraint(lessThanOrEqualTo: estadoBadge.leadingAnchor, constant: -8),

            estadoBadge.centerYAnchor.constraint(equalTo: contactoLabel.centerYAnchor),
            estadoBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            estadoLabel.topAnchor.constraint(equalTo: estadoBadge.topAnchor, constant: 4),
            estadoLabel.bottomAnchor.constraint(equalTo: estadoBadge.bottomAnchor, constant: -4),
            estadoLabel.leadingAnchor.constraint(equalTo: estadoBadge.leadingAnchor, constant: 8),
            estadoLabel.trailingAnchor.constraint(equalTo: estadoBadge.trailingAnchor, constant: -8),

            fechaLabel.topAnchor.constraint(equalTo: contactoLabel.bottomAnchor, constant: 4),
            fechaLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),

            comentarioLabel.topAnchor.constraint(equalTo: fechaLabel.bottomAnchor, constant: 6),
            comentarioLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            comentarioLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            comentarioLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(titulo: String, contacto: String, precio: String, fecha: String, estado: String, comentario: String? = nil) {
        tituloLabel.text = titulo
        precioLabel.text = precio
        contactoLabel.text = contacto
        fechaLabel.text = fecha
        comentarioLabel.text = comentario
        comentarioLabel.isHidden = comentario == nil

        switch estado {
        case "completada":
            estadoLabel.text = "Completado"
            estadoLabel.textColor = .systemGreen
            estadoBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
        case "aceptada":
            estadoLabel.text = "Activo"
            estadoLabel.textColor = .systemOrange
            estadoBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.12)
        default:
            estadoLabel.text = estado.capitalized
            estadoLabel.textColor = .systemGray
            estadoBadge.backgroundColor = UIColor.systemGray.withAlphaComponent(0.12)
        }
    }
}
