import UIKit

class CategoryCell: UICollectionViewCell {

    static let identifier = "CategoryCell"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.borderWidth = 1.5
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        if isSelected {
            backgroundColor = .systemBlue
            layer.borderColor = UIColor.systemBlue.cgColor
            titleLabel.textColor = .white
        } else {
            backgroundColor = .clear
            layer.borderColor = UIColor.systemGray4.cgColor
            titleLabel.textColor = .label
        }
    }
}
