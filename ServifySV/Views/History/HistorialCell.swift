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
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textColor = .systemBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let profesionalLabel: UILabel = {
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

    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .systemYellow
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let comentarioLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .systemBlue
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        [tituloLabel, precioLabel, profesionalLabel, fechaLabel, ratingLabel, comentarioLabel].forEach { cardView.addSubview($0) }
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            tituloLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            tituloLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),

            precioLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            precioLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            profesionalLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 2),
            profesionalLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),

            fechaLabel.topAnchor.constraint(equalTo: profesionalLabel.bottomAnchor, constant: 2),
            fechaLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),

            ratingLabel.topAnchor.constraint(equalTo: profesionalLabel.topAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            comentarioLabel.topAnchor.constraint(equalTo: fechaLabel.bottomAnchor, constant: 8),
            comentarioLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            comentarioLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            comentarioLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(titulo: String, profesional: String, precio: String, fecha: String, rating: String, comentario: String) {
        tituloLabel.text = titulo
        precioLabel.text = precio
        profesionalLabel.text = profesional
        fechaLabel.text = fecha
        ratingLabel.text = rating
        comentarioLabel.text = ""\(comentario)""
    }
}
