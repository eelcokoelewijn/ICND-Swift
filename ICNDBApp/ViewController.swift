import UIKit

class ViewController: UIViewController,
                      UsesJokeViewModel,
                      JokeViewOutput {
    internal let jokeViewModel: JokeViewModel
    
    private lazy var jokeText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    init(viewModel: JokeViewModel) {
        jokeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        jokeViewModel.setOutput(output: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        applyViewConstraints()
        jokeViewModel.loadJoke()
    }
    
    //MARK: JokeViewOutput
    
    func show(joke: String) {
        jokeText.text = joke
    }
    
    private func setupViews() {
        view.addSubview(jokeText)
    }
    
    private func applyViewConstraints() {
        let views = ["jokeText": jokeText]
        
        let topConstraint = NSLayoutConstraint(item: jokeText, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 10)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[jokeText]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        view.addConstraints(horizontalConstraints)
        view.addConstraint(topConstraint)
    }

}

