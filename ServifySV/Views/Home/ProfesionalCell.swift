import UIKit

class ProfesionalCell: UITableViewCell {

    static let identifier = "ProfesionalCell"

    // MARK: - UI
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 8
        v.clipsToBounds = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let infoView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.backgroundColor = .systemBlue.withAlphaComponent(0.15)
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
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let especialidadLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .systemBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let tituloServicioLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 13)
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descripcionLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11)
        l.textColor = .secondaryLabel
        l.numberOfLines = 2
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

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        avatarView.addSubview(avatarLabel)
        infoView.addSubview(avatarView)
        infoView.addSubview(nombreLabel)
        infoView.addSubview(especialidadLabel)
        infoView.addSubview(ratingLabel)
        infoView.addSubview(tituloServicioLabel)
        infoView.addSubview(descripcionLabel)
        infoView.addSubview(precioLabel)

        cardView.addSubview(categoryImageView)
        cardView.addSubview(infoView)
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            categoryImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            categoryImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            categoryImageView.heightAnchor.constraint(equalToConstant: 120),

            infoView.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            avatarView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -12),
            avatarView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 12),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nombreLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 8),
            nombreLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            nombreLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -12),

            especialidadLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 2),
            especialidadLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),

            ratingLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 2),
            ratingLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -12),

            tituloServicioLabel.topAnchor.constraint(equalTo: especialidadLabel.bottomAnchor, constant: 6),
            tituloServicioLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 12),
            tituloServicioLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -12),

            descripcionLabel.topAnchor.constraint(equalTo: tituloServicioLabel.bottomAnchor, constant: 4),
            descripcionLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 12),
            descripcionLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -12),

            precioLabel.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 6),
            precioLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 12),
            precioLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10),
        ])
    }

    // MARK: - Configure
    func configure(with profesional: Profesional) {
        let nombre = profesional.usuario?.nombre ?? ""
        let initials = nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel.text = nombre
        especialidadLabel.text = profesional.especialidad
        let rating = profesional.calificacionPromedio ?? 0.0
        let total = profesional.totalCalificaciones ?? 0
        ratingLabel.text = "⭐ \(String(format: "%.1f", rating)) (\(total))"

        if let servicio = profesional.servicios?.first {
            tituloServicioLabel.text = servicio.nombreServicio
            descripcionLabel.text = servicio.descripcion ?? ""
            categoryImageView.image = nil
            categoryImageView.backgroundColor = UIColor(red: 0.72, green: 0.88, blue: 0.98, alpha: 1)
            precioLabel.text = "$\(String(format: "%.0f", servicio.precioReferencia))/día"
        }
    }
}
