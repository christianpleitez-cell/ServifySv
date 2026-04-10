import UIKit

class NuevaSolicitudViewController: UIViewController {

    // MARK: - Properties
    private let profesional: Profesional

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Nueva Solicitud"
        l.font = UIFont.boldSystemFont(ofSize: 22)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let profesionalCardView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGroupedBackground
        v.layer.cornerRadius = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let profesionalNombreLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let profesionalEspecialidadLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let servicioLabel: UILabel = {
        let l = UILabel()
        l.text = "Seleccionar servicio"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let servicioPickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()

    private let descripcionLabel: UILabel = {
        let l = UILabel()
        l.text = "Describe lo que necesitas"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descripcionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.layer.borderColor = UIColor.separator.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.text = "Describe el trabajo que necesitas..."
        tv.textColor = .placeholderText
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let enviarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Enviar Solicitud", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init
    init(profesional: Profesional) {
        self.profesional = profesional
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Solicitar Servicio"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        profesionalCardView.addSubview(profesionalNombreLabel)
        profesionalCardView.addSubview(profesionalEspecialidadLabel)

        [titleLabel, profesionalCardView, servicioLabel, servicioPickerView, descripcionLabel, descripcionTextView, enviarButton].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            profesionalCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            profesionalCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profesionalCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            profesionalNombreLabel.topAnchor.constraint(equalTo: profesionalCardView.topAnchor, constant: 16),
            profesionalNombreLabel.leadingAnchor.constraint(equalTo: profesionalCardView.leadingAnchor, constant: 16),
            profesionalNombreLabel.trailingAnchor.constraint(equalTo: profesionalCardView.trailingAnchor, constant: -16),

            profesionalEspecialidadLabel.topAnchor.constraint(equalTo: profesionalNombreLabel.bottomAnchor, constant: 4),
            profesionalEspecialidadLabel.leadingAnchor.constraint(equalTo: profesionalCardView.leadingAnchor, constant: 16),
            profesionalEspecialidadLabel.bottomAnchor.constraint(equalTo: profesionalCardView.bottomAnchor, constant: -16),

            servicioLabel.topAnchor.constraint(equalTo: profesionalCardView.bottomAnchor, constant: 24),
            servicioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            servicioPickerView.topAnchor.constraint(equalTo: servicioLabel.bottomAnchor, constant: 8),
            servicioPickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            servicioPickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            servicioPickerView.heightAnchor.constraint(equalToConstant: 120),

            descripcionLabel.topAnchor.constraint(equalTo: servicioPickerView.bottomAnchor, constant: 16),
            descripcionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            descripcionTextView.topAnchor.constraint(equalTo: descripcionLabel.bottomAnchor, constant: 8),
            descripcionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descripcionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descripcionTextView.heightAnchor.constraint(equalToConstant: 120),

            enviarButton.topAnchor.constraint(equalTo: descripcionTextView.bottomAnchor, constant: 32),
            enviarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            enviarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            enviarButton.heightAnchor.constraint(equalToConstant: 52),
            enviarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])

        servicioPickerView.delegate = self
        servicioPickerView.dataSource = self
        descripcionTextView.delegate = self
        enviarButton.addTarget(self, action: #selector(enviarTapped), for: .touchUpInside)
    }

    private func configure() {
        profesionalNombreLabel.text = profesional.usuario.nombre
        profesionalEspecialidadLabel.text = profesional.especialidad
    }

    // MARK: - Actions
    @objc private func enviarTapped() {
        let alert = UIAlertController(title: "Solicitud Enviada", message: "Tu solicitud ha sido enviada a \(profesional.usuario.nombre). Te notificaremos cuando acepte.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource & Delegate
extension NuevaSolicitudViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        profesional.servicios.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let s = profesional.servicios[row]
        return "\(s.nombreServicio) - $\(String(format: "%.2f", s.precioReferencia))"
    }
}

// MARK: - UITextViewDelegate
extension NuevaSolicitudViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }
}
