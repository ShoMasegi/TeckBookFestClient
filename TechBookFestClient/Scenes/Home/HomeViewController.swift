import UIKit

final class HomeViewController: UIViewController, StoryboardInstantiable {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetch()
    }

    private lazy var presenter: HomePresenterInput = HomePresenter(
        output: self,
        useCase: UseCaseProvider(networking: Networking.newStubNetworking()).makeHomeUseCase()
    )
}

extension HomeViewController: HomePresenterOutput {
    func fetched(result: Result<Home, Error>) {
        switch result {
        case .success(let home):
            print(home)
        case .failure(let error):
            print(error)
        }
    }
}
