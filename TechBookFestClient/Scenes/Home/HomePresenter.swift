import Foundation

protocol HomePresenterInput: AnyObject {
    func fetch()
}

protocol HomePresenterOutput: AnyObject {
    func fetched(result: Result<Home, Error>)
}

final class HomePresenter: HomePresenterInput {
    private let output: HomePresenterOutput
    private let useCase: HomeUseCase

    init(output: HomePresenterOutput, useCase: HomeUseCase) {
        self.output = output
        self.useCase = useCase
    }

    func fetch() {
        useCase.getHome { [weak self] result in
            self?.output.fetched(result: result)
        }
    }
}
