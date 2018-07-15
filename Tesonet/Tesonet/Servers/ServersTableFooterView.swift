import UIKit

protocol ServersTableFooterDelegate: class {
    func sortWasPressed()
}

final class ServersTableFooterView: UIView {
    
    weak var delegate: ServersTableFooterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

// MARK: - IBActions

extension ServersTableFooterView {
    
    @IBAction fileprivate func sortPressed() {
        delegate?.sortWasPressed()
    }
    
}