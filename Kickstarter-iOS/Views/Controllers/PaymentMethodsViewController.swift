import KsApi
import Library
import Prelude
import UIKit

internal final class PaymentMethodsViewController: UIViewController {

  private let dataSource = PaymentMethodsDataSource()
  private let viewModel: PaymentMethodsViewModelType = PaymentMethodsViewModel()

  @IBOutlet private weak var headerLabel: UILabel!
  @IBOutlet private weak var tableView: UITableView! {
    didSet {
      self.tableView.register(nib: .CreditCardCell)
    }
  }

  public static func instantiate() -> PaymentMethodsViewController {
    return Storyboard.Settings.instantiate(PaymentMethodsViewController.self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel.inputs.viewDidLoad()
    self.tableView.dataSource = self.dataSource
    self.tableView.delegate = self
  }

  override func bindStyles() {
    super.bindStyles()

    _ = self
      |> \.view.backgroundColor .~ .ksr_grey_200

    _ = self.headerLabel
      |> settingsDescriptionLabelStyle
      |> \.text %~ { _ in
        "Any payment methods you've saved to Kickstarter are listed here (securely) for your convenience."
    }

    _ = self.tableView
      |> \.backgroundColor .~ .clear
  }

  override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.didFetchPaymentMethods
      .observeForUI()
      .observeValues { [weak self] result in
        self?.dataSource.load(creditCards: result)
        self?.tableView.reloadData()
    }
  }
}

extension PaymentMethodsViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.zero()
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.1
  }
}
