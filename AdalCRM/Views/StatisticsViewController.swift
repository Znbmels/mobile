import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var statistics: Statistics?
    
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
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        loadStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStatistics()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Статистика"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshStatistics), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    // MARK: - Data Loading
    
    private func loadStatistics() {
        APIService.shared.fetchStatistics { [weak self] result in
            switch result {
            case .success(let statistics):
                self?.statistics = statistics
                self?.updateUI()
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func refreshStatistics() {
        APIService.shared.fetchStatistics { [weak self] result in
            self?.refreshControl.endRefreshing()
            
            switch result {
            case .success(let statistics):
                self?.statistics = statistics
                self?.updateUI()
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    private func updateUI() {
        // Очищаем предыдущий контент
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        guard let statistics = statistics else { return }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // Общая статистика
        stackView.addArrangedSubview(createStatCard(
            title: "Общая статистика",
            items: [
                ("Всего заказов", "\(statistics.totalOrders)"),
                ("Общая сумма", String(format: "%.2f ₸", statistics.totalAmount))
            ]
        ))
        
        // Статистика по статусам
        if !statistics.statusCounts.isEmpty {
            var statusItems: [(String, String)] = []
            
            for (statusKey, statusCount) in statistics.statusCounts {
                statusItems.append((statusCount.name, "\(statusCount.count)"))
            }
            
            stackView.addArrangedSubview(createStatCard(
                title: "По статусам",
                items: statusItems
            ))
        }
    }
    
    private func createStatCard(title: String, items: [(String, String)]) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOpacity = 0.1
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Заголовок
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .black
        
        stackView.addArrangedSubview(titleLabel)
        
        // Разделитель
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        stackView.addArrangedSubview(separator)
        
        // Элементы статистики
        for (label, value) in items {
            let itemView = createStatItem(label: label, value: value)
            stackView.addArrangedSubview(itemView)
        }
        
        cardView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    private func createStatItem(label: String, value: String) -> UIView {
        let containerView = UIView()
        
        let labelLabel = UILabel()
        labelLabel.text = label
        labelLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        labelLabel.textColor = .systemGray
        labelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textColor = .systemOrange
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(labelLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            labelLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            labelLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            labelLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8),
            
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        return containerView
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
