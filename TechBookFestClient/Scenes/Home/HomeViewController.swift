import UIKit

final class HomeViewController: UIViewController, StoryboardInstantiable {

    private let networking: Networking = {
        #if STUB
            return Application.shared.stubNetworking()
        #elseif DEBUG
            return Application.shared.debugNetworking(
                statusCode: 426,
                data: stubbedResponse("error")
            )
        #else
            return Application.shared.defaultNetworking()
        #endif
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        networking.request(.home) { [weak self] (result: Result<Home, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let home):
                self.home = home
            case .failure(let error):
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }

    private enum SectionType {
        case cover(_ cover: CoverSection)
        case description(_ description: DescriptionSection)
        case circles(_ circles: CirclesSection)
    }

    private var home: Home? {
        didSet {
            guard let home = home else { return }
            sections = [
                .cover(home.coverSection),
                .description(home.descriptionSection),
                .circles(home.circlesSection)
            ]
            self.tableView.reloadData()
        }
    }

    private var sections: [SectionType] = []

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerFromNib(HomeCoverTableViewCell.self)
            tableView.registerFromNib(HomeDescriptionTableViewCell.self)
            tableView.registerFromNib(CircleTableViewCell.self)
            tableView.registerReusableHeaderFooterFromNib(LabelTableViewHeaderFooterView.self)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .cover, .description:
            return 1
        case .circles(let circlesSection):
            return circlesSection.items.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .cover(let coverSection):
            let cell: HomeCoverTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(section: coverSection)
            return cell
        case .description(let descriptionSection):
            let cell: HomeDescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(section: descriptionSection)
            return cell
        case .circles(let circlesSection):
            let cell: CircleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(circle: circlesSection.items[indexPath.row])
            return cell
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .cover:
            return UIScreen.main.bounds.width * 9 / 16
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.section] {
        case .circles:
            let viewController = CircleDetailViewController.instantiateFromStoryboard()
            navigationController?.pushViewController(viewController, animated: true)
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .circles(let section):
            let view: LabelTableViewHeaderFooterView = tableView.dequeueReusableHeaderFooterView()
            view.label.text = section.header
            return view
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .circles: return 42
        default: return .leastNonzeroMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
