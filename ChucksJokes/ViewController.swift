import UIKit
import NetworkKit

class ViewController: UIViewController {
    private let networker = NetworkKit()
    
    private lazy var jokeText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let views = ["jokeText": jokeText]
        view.addSubview(jokeText)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[jokeText]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))

        let topConstraint = NSLayoutConstraint(item: jokeText, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(topConstraint)
        networker.load(resource: Joke.resource()) { joke, error in
            DispatchQueue.main.async(execute: { [weak self] in
                self?.jokeText.text = joke?.description.htmlDecode()
            })
            
        }
    }
}

