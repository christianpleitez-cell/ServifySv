import UIKit

class ProfesionalCell: UITableViewCell {

    static let identifier = "ProfesionalCell"

    // MARK: - UI
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

    private let avatarView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 28
        v.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let avatarLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = .systemBlue
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nombreLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let especialidadLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let verificadoBadge: UILabel = {
        let l = UILabel()
        l.text = "✓ Verificado"
        l.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        l.textColor = .systemGreen
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let precioLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .systemBlue
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let chevronImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
        cardView.addSubview(avatarView)
        cardView.addSubview(nombreLabel)
        cardView.addSubview(especialidadLabel)
        cardView.addSubview(ratingLabel)
        cardView.addSubview(verificadoBadge)
        cardView.addSubview(precioLabel)
        cardView.addSubview(chevronImageView)
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            avatarView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 56),
            avatarView.heightAnchor.constraint(equalToConstant: 56),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nombreLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            nombreLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nombreLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),

            especialidadLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 3),
            especialidadLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),

            ratingLabel.topAnchor.constraint(equalTo: especialidadLabel.bottomAnchor, constant: 6),
            ratingLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),

            verificadoBadge.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            verificadoBadge.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),

            precioLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            precioLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18),
        ])
    }

    // MARK: - Configure
    func configure(with profesional: Profesional) {
        let initials = profesional.usuario.nombre.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarLabel.text = String(initials.prefix(2))
        nombreLabel.text = profesional.usuario.nombre
        especialidadLabel.text = profesional.especialidad
        ratingLabel.text = "★ \(profesional.calificacionPromedio) (\(profesional.totalCalificaciones))"
        verificadoBadge.isHidden = profesional.estadoVerificacion != "Verificado"

        if let precio = profesional.servicios.first?.precioReferencia {
            precioLabel.text = "Desde $\(String(format: "%.0f", precio))"
        }
    }
}
