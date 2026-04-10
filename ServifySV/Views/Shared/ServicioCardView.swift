import UIKit

class ServicioCardView: UIView {

    init(servicio: Servicio) {
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false

        let nombreLabel = UILabel()
        nombreLabel.text = servicio.nombreServicio
        nombreLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nombreLabel.translatesAutoresizingMaskIntoConstraints = false

        let categoriaLabel = UILabel()
        categoriaLabel.text = servicio.categoria.rawValue
        categoriaLabel.font = UIFont.systemFont(ofSize: 12)
        categoriaLabel.textColor = .secondaryLabel
        categoriaLabel.translatesAutoresizingMaskIntoConstraints = false

        let precioLabel = UILabel()
        precioLabel.text = "$\(String(format: "%.2f", servicio.precioReferencia))"
        precioLabel.font = UIFont.boldSystemFont(ofSize: 15)
        precioLabel.textColor = .systemBlue
        precioLabel.translatesAutoresizingMaskIntoConstraints = false

        let disponibilidadLabel = UILabel()
        disponibilidadLabel.text = servicio.disponibilidad
        disponibilidadLabel.font = UIFont.systemFont(ofSize: 12)
        disponibilidadLabel.textColor = .systemGray
        disponibilidadLabel.translatesAutoresizingMaskIntoConstraints = false

        [nombreLabel, categoriaLabel, precioLabel, disponibilidadLabel].forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            nombreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nombreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nombreLabel.trailingAnchor.constraint(equalTo: precioLabel.leadingAnchor, constant: -8),

            precioLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            precioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            categoriaLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 4),
            categoriaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            disponibilidadLabel.topAnchor.constraint(equalTo: categoriaLabel.bottomAnchor, constant: 4),
            disponibilidadLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            disponibilidadLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - SectionView (reutilizable para detalles)
class SectionView: UIView {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .systemBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let valueLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title.uppercased()

        addSubview(titleLabel)
        addSubview(valueLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func setValue(_ value: String) {
        valueLabel.text = value
    }
}
