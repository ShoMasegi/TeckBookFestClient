import Moya

enum TBAPI {
    case home
    case circles(id: Int)
}

extension TBAPI: TargetType {
    var baseURL: URL {
        let urlString = "https://api.techboost7"
        guard let url = URL(string: urlString) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    var path: String {
        switch self {
        case .home: return  "/home"
        case .circles(let id): return "/circles/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .home: return stubbedResponse("home")
        case .circles: return stubbedResponse("circle")
        }
    }

    var task: Moya.Task {
        switch self {
        default: return .requestPlain
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

func stubbedResponse(_ filename: String) -> Data {
    class TestClass: NSObject {}

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    do {
        return (try Data(contentsOf: URL(fileURLWithPath: path!)))
    } catch {
        fatalError("Such a JSON file dose not exist.")
    }
}
