import UIKit

class OrderTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
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
    
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let clientNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(orderNumberLabel)
        containerView.addSubview(clientNameLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(itemsCountLabel)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Order number
            orderNumberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            orderNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // Status
            statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            statusLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // Client name
            clientNameLabel.topAnchor.constraint(equalTo: orderNumberLabel.bottomAnchor, constant: 4),
            clientNameLabel.leadingAnchor.constraint(equalTo: orderNumberLabel.leadingAnchor),
            clientNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusLabel.leadingAnchor, constant: -8),
            
            // Amount
            amountLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            
            // Date
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            dateLabel.leadingAnchor.constraint(equalTo: orderNumberLabel.leadingAnchor),
            
            // Items count
            itemsCountLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            itemsCountLabel.trailingAnchor.constraint(equalTo: amountLabel.trailingAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with order: Order) {
        orderNumberLabel.text = "№ \(order.orderNumber)"
        clientNameLabel.text = order.clientName
        statusLabel.text = order.statusDisplay
        amountLabel.text = "\(order.totalAmount) ₸"
        itemsCountLabel.text = "\(order.itemsCount) поз."
        
        // Форматируем дату
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        if let date = dateFormatter.date(from: order.createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            dateLabel.text = displayFormatter.string(from: date)
        } else {
            dateLabel.text = order.createdAt
        }
        
        // Настраиваем цвета статуса
        statusLabel.backgroundColor = order.status.backgroundColor
        statusLabel.textColor = order.status.color
    }
}
