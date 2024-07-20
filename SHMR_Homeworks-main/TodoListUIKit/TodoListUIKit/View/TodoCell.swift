import UIKit

class TodoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with todoItem: TodoItem) {
        textLabel?.isEnabled = true
        textLabel?.text = todoItem.text
        
        if todoItem.done {
            textLabel?.textColor = .gray
            let attributeString = NSMutableAttributedString(string: todoItem.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            textLabel?.attributedText = attributeString
        } else {
            textLabel?.textColor = .black
            textLabel?.backgroundColor = .blue 
            textLabel?.attributedText = nil
        }
    }
}
