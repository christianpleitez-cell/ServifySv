import UIKit

class EditarServicioViewController: UIViewController {

    private let servicio: Servicio

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var tituloTextField: UITextField!
    private var categoriaTextField: UITextField!
    private var descripcionTextView: UITextView!
    private var precioTextField: UITextField!

    private lazy var tituloField = createTextField(textField: &tituloTextField, placeholder: "Ej: Construcción y Remodelación", label: "Título del servicio")
    private lazy var categoriaField = createDropdown(textField: &categoriaTextField, label: "Categoría", placeholder: "Selecciona una categoría")
    private lazy var descripcionField = createTextView(textView: &descripcionTextView, placeholder: "Describe tu experiencia...", label: "Descripción")
    private lazy var precioField = createTextField(textField: &precioTextField, placeholder: "500", label: "Precio por día", keyboardType: .decimalPad)

    private let categoriaPicker = UIPickerView()
    private let categorias = ["electricidad", "plomeria", "albanileria", "pintura", "carpinteria", "limpieza", "jardineria", "otro"]

    private let guardarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Guardar Cambios", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    init(servicio: Servicio) {
        self.servicio = servicio
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prefillFields()
        setupCategoriaPicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        title = "Editar Servicio"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let titleLabel = UILabel()
        titleLabel.text = "Editar Servicio"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Actualiza la información de tu servicio"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)

        contentView.addSubview(tituloField)
        contentView.addSubview(categoriaField)
        contentView.addSubview(descripcionField)
        contentView.addSubview(precioField)

        let precioHelpLabel = UILabel()
        precioHelpLabel.text = "Este será tu tarifa base por día de trabajo"
        precioHelpLabel.font = UIFont.systemFont(ofSize: 12)
        precioHelpLabel.textColor = .systemGray
        precioHelpLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(precioHelpLabel)

        contentView.addSubview(guardarButton)

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
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            tituloField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            tituloField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tituloField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            categoriaField.topAnchor.constraint(equalTo: tituloField.bottomAnchor, constant: 16),
            categoriaField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoriaField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descripcionField.topAnchor.constraint(equalTo: categoriaField.bottomAnchor, constant: 16),
            descripcionField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descripcionField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descripcionField.heightAnchor.constraint(equalToConstant: 120),

            precioField.topAnchor.constraint(equalTo: descripcionField.bottomAnchor, constant: 16),
            precioField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            precioField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            precioHelpLabel.topAnchor.constraint(equalTo: precioField.bottomAnchor, constant: 6),
            precioHelpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            guardarButton.topAnchor.constraint(equalTo: precioHelpLabel.bottomAnchor, constant: 20),
            guardarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            guardarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            guardarButton.heightAnchor.constraint(equalToConstant: 50),
            guardarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])

        guardarButton.addTarget(self, action: #selector(guardarTapped), for: .touchUpInside)
    }

    private func prefillFields() {
        tituloTextField.text = servicio.nombreServicio
        categoriaTextField.text = servicio.categoria.capitalized
        if let desc = servicio.descripcion, !desc.isEmpty {
            descripcionTextView.text = desc
            descripcionTextView.textColor = .label
        }
        precioTextField.text = "\(Int(servicio.precioReferencia))"
    }

    private func setupCategoriaPicker() {
        categoriaPicker.delegate = self
        categoriaPicker.dataSource = self
        categoriaTextField.inputView = categoriaPicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(categoriaPickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, done], animated: false)
        categoriaTextField.inputAccessoryView = toolbar

        if let idx = categorias.firstIndex(of: servicio.categoria.lowercased()) {
            categoriaPicker.selectRow(idx, inComponent: 0, animated: false)
        }
    }

    @objc private func categoriaPickerDone() {
        let idx = categoriaPicker.selectedRow(inComponent: 0)
        categoriaTextField.text = categorias[idx].capitalized
        categoriaTextField.resignFirstResponder()
    }

    @objc private func guardarTapped() {
        guard let titulo = tituloTextField.text, !titulo.isEmpty else {
            showAlert(title: "Error", message: "Por favor ingresa un título para el servicio")
            return
        }

        guard let categoria = categoriaTextField.text, !categoria.isEmpty else {
            showAlert(title: "Error", message: "Por favor selecciona una categoría")
            return
        }

        guard let descripcion = descripcionTextView.text, !descripcion.isEmpty else {
            showAlert(title: "Error", message: "Por favor ingresa una descripción")
            return
        }

        guard let precioStr = precioTextField.text, !precioStr.isEmpty, let precio = Double(precioStr) else {
            showAlert(title: "Error", message: "Por favor ingresa un precio válido")
            return
        }

        guardarButton.isEnabled = false
        guardarButton.setTitle("Guardando...", for: .normal)

        APIManager.shared.updateServicio(
            servicioId: servicio.id,
            nombreServicio: titulo,
            categoria: categoria.lowercased(),
            descripcion: descripcion,
            precioReferencia: precio,
            disponibilidad: servicio.disponibilidad
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.guardarButton.isEnabled = true
                self?.guardarButton.setTitle("Guardar Cambios", for: .normal)

                switch result {
                case .success:
                    self?.showAlert(title: "Éxito", message: "El servicio ha sido actualizado correctamente") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
}

extension EditarServicioViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categorias.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categorias[row].capitalized
    }
}
