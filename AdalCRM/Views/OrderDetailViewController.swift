import UIKit

class OrderDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var order: Order
    private let currentUser = AuthService.shared.getCurrentUser()
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let updateStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Обновить статус", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupOrderInfo()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Заказ № \(order.orderNumber)"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(orderInfoView)
        
        // Показываем кнопку обновления статуса только для соответствующих ролей
        if canUpdateStatus() {
            contentView.addSubview(updateStatusButton)
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
            
            orderInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            orderInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            orderInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        if canUpdateStatus() {
            NSLayoutConstraint.activate([
                updateStatusButton.topAnchor.constraint(equalTo: orderInfoView.bottomAnchor, constant: 24),
                updateStatusButton.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor),
                updateStatusButton.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor),
                updateStatusButton.heightAnchor.constraint(equalToConstant: 50),
                updateStatusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
        } else {
            orderInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        }
    }
    
    private func setupOrderInfo() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        orderInfoView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: orderInfoView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: orderInfoView.bottomAnchor, constant: -16)
        ])
        
        // Добавляем информацию о заказе
        stackView.addArrangedSubview(createInfoRow(title: "Номер заказа:", value: order.orderNumber))
        stackView.addArrangedSubview(createInfoRow(title: "Клиент:", value: order.clientName))
        stackView.addArrangedSubview(createInfoRow(title: "Телефон:", value: order.clientPhone))
        stackView.addArrangedSubview(createStatusRow())
        stackView.addArrangedSubview(createInfoRow(title: "Сумма:", value: "\(order.totalAmount) ₸"))
        stackView.addArrangedSubview(createInfoRow(title: "Количество позиций:", value: "\(order.itemsCount)"))
        
        if let managerName = order.managerName {
            stackView.addArrangedSubview(createInfoRow(title: "Менеджер:", value: managerName))
        }
        
        if let courierName = order.courierName {
            stackView.addArrangedSubview(createInfoRow(title: "Курьер:", value: courierName))
        }
        
        if let washerName = order.washerName {
            stackView.addArrangedSubview(createInfoRow(title: "Мойщик:", value: washerName))
        }
        
        if let washerAssistantName = order.washerAssistantName {
            stackView.addArrangedSubview(createInfoRow(title: "Помощник мойщика:", value: washerAssistantName))
        }
    }
    
    private func createInfoRow(title: String, value: String) -> UIView {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .systemGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func createStatusRow() -> UIView {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Статус:"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .systemGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let statusLabel = UILabel()
        statusLabel.text = order.statusDisplay
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.backgroundColor = order.status.backgroundColor
        statusLabel.textColor = order.status.color
        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 32),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            statusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func setupActions() {
        updateStatusButton.addTarget(self, action: #selector(updateStatusTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func updateStatusTapped() {
        guard let user = currentUser else { return }
        
        let nextStatus: OrderStatus
        let message: String
        
        switch user.role {
        case .courier:
            if order.status == .assigned {
                nextStatus = .pickedUp
                message = "Отметить как забранный?"
            } else if order.status == .readyForDelivery {
                nextStatus = .delivered
                message = "Отметить как доставленный?"
            } else {
                showAlert(title: "Ошибка", message: "Невозможно обновить статус")
                return
            }
        case .washer:
            if order.status == .inWashing {
                nextStatus = .washed
                message = "Отметить как постиранный?"
            } else {
                showAlert(title: "Ошибка", message: "Невозможно обновить статус")
                return
            }
        case .washerAssistant:
            if order.status == .washed {
                nextStatus = .driedAndPacked
                message = "Отметить как высушенный и упакованный?"
            } else {
                showAlert(title: "Ошибка", message: "Невозможно обновить статус")
                return
            }
        default:
            showAlert(title: "Ошибка", message: "У вас нет прав для обновления статуса")
            return
        }
        
        let alert = UIAlertController(title: "Обновить статус", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Обновить", style: .default) { [weak self] _ in
            self?.updateOrderStatus(to: nextStatus)
        })
        
        present(alert, animated: true)
    }
    
    private func updateOrderStatus(to status: OrderStatus) {
        updateStatusButton.isEnabled = false
        updateStatusButton.setTitle("Обновление...", for: .normal)
        
        APIService.shared.updateOrderStatus(orderId: order.id, status: status) { [weak self] result in
            self?.updateStatusButton.isEnabled = true
            self?.updateStatusButton.setTitle("Обновить статус", for: .normal)
            
            switch result {
            case .success(let updatedOrder):
                self?.order = updatedOrder
                self?.setupOrderInfo()
                self?.showAlert(title: "Успех", message: "Статус заказа обновлен")
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func canUpdateStatus() -> Bool {
        guard let user = currentUser else { return false }
        
        switch user.role {
        case .courier:
            return order.status == .assigned || order.status == .readyForDelivery
        case .washer:
            return order.status == .inWashing
        case .washerAssistant:
            return order.status == .washed
        default:
            return false
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
