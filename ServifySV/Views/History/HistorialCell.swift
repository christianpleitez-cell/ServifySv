import UIKit

class HistorialCell: UITableViewCell {

    static let identifier = "HistorialCell"

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 14
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.07
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 6
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let estadoBadge: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        l.textColor = .white
        l.backgroundColor = .systemGreen
        l.layer.cornerRadius = 8
        l.clipsToBounds = true
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let profesionalLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let servicioLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let starsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .systemYellow
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let fechaLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .tertiaryLabel
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        [estadoBadge, profesionalLabel, servicioLabel, starsLabel, fechaLabel].forEach { cardView.addSubview($0) }
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            estadoBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            estadoBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            estadoBadge.widthAnchor.constraint(equalToConstant: 100),
            estadoBadge.heightAnchor.constraint(equalToConstant: 22),

            profesionalLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            profesionalLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            profesionalLabel.trailingAnchor.constraint(equalTo: estadoBadge.leadingAnchor, constant: -8),

            servicioLabel.topAnchor.constraint(equalTo: profesionalLabel.bottomAnchor, constant: 4),
            servicioLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

            starsLabel.topAnchor.constraint(equalTo: servicioLabel.bottomAnchor, constant: 8),
            starsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

            fechaLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            fechaLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with solicitud: Solicitud) {
        profesionalLabel.text = solicitud.profesional.usuario.nombre
        servicioLabel.text = solicitud.servicio.nombreServicio
        estadoBadge.text = " \(solicitud.estado.rawValue) "

        if let cal = solicitud.calificacion {
            starsLabel.text = String(repeating: "★", count: cal.puntuacion) + String(repeating: "☆", count: 5 - cal.puntuacion)
        } else {
            starsLabel.text = "Sin calificación"
            starsLabel.textColor = .tertiaryLabel
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        fechaLabel.text = formatter.string(from: solicitud.fechaSolicitud)
    }
}
