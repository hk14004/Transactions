//
//  TransactionsVC.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import UIKit
import Combine

class TransactionsScreenVC: UIViewController {

    // MARK: Properties
    
    /// Private
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: DiffableDataSource!
    private let viewModel: TransactionsScreenVM
    private var bag = Set<AnyCancellable>()
    
    // MARK: Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startup()
    }

    // MARK: Init
    
    init(viewModel: TransactionsScreenVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Transactions"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print(":)")
    }
}

// MARK: Private methods

extension TransactionsScreenVC {
    private func startup() {
        configureTableView()
        observeViewModel()
    }
    
    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        view.addSubview(tableView)
        tableView.pinToSuperviewEdges(useSafeArea: false)
        registerTableViewCells()
        configureDataSource()
    }
    
    private func registerTableViewCells() {
        tableView.register(UINib.instanciateNib(type: BalanceTableViewCell.self),
                           forCellReuseIdentifier: BalanceTableViewCell.reuseID)
        tableView.register(UINib.instanciateNib(type: TransactionTableViewCell.self),
                           forCellReuseIdentifier: TransactionTableViewCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = DiffableDataSource(viewModel: viewModel, tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .balance(let vm):
                let cell = tableView.dequeueReusableCell(withIdentifier: BalanceTableViewCell.reuseID,
                                                         for: indexPath) as? BalanceTableViewCell
                cell?.bindTo(viewModel: vm)
                return cell
            case .transaction(let vm):
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseID,
                                                         for: indexPath) as? TransactionTableViewCell
                cell?.bindTo(viewModel: vm)
                return cell
            case .loadingTransactions:
                // TODO: Implement redacted or loader
                let cell = UITableViewCell()
                cell.textLabel?.text = "Loading transactions..."
                return cell
            case .loadingBalance:
                // TODO: Implement redacted or loader
                let cell = UITableViewCell()
                cell.textLabel?.text = "Loading balance..."
                return cell
            }
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    private func observeViewModel() {
        viewModel.sectionsPublisher.receive(on: DispatchQueue.main).sink { [weak self] sections in
            self?.renderTableViewSections(sections)
        }.store(in: &bag)
    }
    
    private func renderTableViewSections(_ sections: [TransactionsScreenSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<TransactionsScreenSection.Identifiers, TransactionsScreenSection.Cell>()
        snapshot.appendSections(sections.map({$0.identifier}))
        sections.forEach { section in
            snapshot.appendItems(section.cells, toSection: section.identifier)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Data source

fileprivate extension TransactionsScreenVC {
    class DiffableDataSource: UITableViewDiffableDataSource<TransactionsScreenSection.Identifiers, TransactionsScreenSection.Cell> {
        
        private var viewModel: TransactionsScreenVM
        
        init(viewModel: TransactionsScreenVM, tableView: UITableView,
             cellProvider: @escaping UITableViewDiffableDataSource<TransactionsScreenSection.Identifiers, TransactionsScreenSection.Cell>.CellProvider) {
            self.viewModel = viewModel
            super.init(tableView: tableView, cellProvider: cellProvider)
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            viewModel.sections[section].title
        }
    }
}
