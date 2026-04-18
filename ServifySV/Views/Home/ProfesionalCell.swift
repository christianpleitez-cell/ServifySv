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

    private let imageView: UIImageView = {
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

        cardView.addSubview(imageView)
        cardView.addSubview(infoView)
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            infoView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
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
        let initials = profesional.usuario.nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel.text = profesional.usuario.nombre
        especialidadLabel.text = profesional.especialidad
        ratingLabel.text = "⭐ \(profesional.calificacionPromedio) (\(profesional.totalCalificaciones))"

        if let servicio = profesional.servicios.first {
            tituloServicioLabel.text = servicio.nombreServicio
            descripcionLabel.text = "Servicio profesional con más de 10 años de experiencia. Construcción, remodelación, acabados."
            imageView.image = getImageForCategory(servicio.categoria)
            precioLabel.text = "$\(String(format: "%.0f", servicio.precioReferencia))/día"
        }
    }

    private func getImageForCategory(_ categoria: CategoriaServicio) -> UIImage? {
        let emoji: String
        switch categoria {
        case .electricidad:
            emoji = "⚡"
        case .plomeria:
            emoji = "🚰"
        case .albanileria:
            emoji = "👷"
        case .pintura:
            emoji = "🎨"
        case .carpinteria:
            emoji = "🪛"
        case .limpieza:
            emoji = "🧹"
        case .jardineria:
            emoji = "🌱"
        case .otro:
            emoji = "🔧"
        }

        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: 60)
        label.backgroundColor = UIColor.systemGray5
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: 120, height: 120)

        let renderer = UIGraphicsImageRenderer(size: label.frame.size)
        return renderer.image { context in
            UIColor.systemGray5.setFill()
            context.fill(label.bounds)
            label.layer.render(in: context.cgContext)
        }
    }
}
