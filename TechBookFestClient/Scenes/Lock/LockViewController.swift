import UIKit

final class LockViewController: UIViewController, StoryboardInstantiable {
    enum LockType {
        case maintenance
        case versionUpdate
        var title: String {
            switch self {
            case .maintenance: return "メンテナンスのお知らせ"
            case .versionUpdate: return "アプリアップデートのお知らせ"
            }
        }

        var body: String {
            switch self {
            case .maintenance:
                return "現在メンテナンス中です。\n復旧までしばらくお待ち下さい。"
            case .versionUpdate:
                return "アプリを安定にご利用いただくため、最新バージョンへのアップデートをお願いします。"
            }
        }

        var buttonTitle: String {
            switch self {
            case .maintenance: return "お知らせを確認"
            case .versionUpdate: return "更新する"
            }
        }

        var url: URL? {
            return URL(string: "https://github.com/ShoMasegi/TeckBookFestClient")
        }
    }

    var type: LockType?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = type?.title
        bodyLabel.text = type?.body
        button.setTitle(type?.buttonTitle, for: .normal)
    }

    @IBOutlet private weak var alertView: UIView! {
        didSet {
            alertView.layer.cornerRadius = 10
            alertView.clipsToBounds = true
            alertView.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
            alertView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
            alertView.layer.shadowRadius = 10
            alertView.layer.shouldRasterize = true
            alertView.layer.rasterizationScale = UIScreen.main.scale
            alertView.layer.shadowOpacity = 1
            alertView.layer.masksToBounds = false
        }
    }
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var button: UIButton! {
        didSet {
            button.setTitleColor(.gray, for: .highlighted)
        }
    }

    @IBAction private func buttonTouchUpInside(_ sender: UIButton) {
        guard let url = type?.url else { return }
        UIApplication.shared.open(url)
    }
}
