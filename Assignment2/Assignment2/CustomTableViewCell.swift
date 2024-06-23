import UIKit

class CustomTableViewCell: UITableViewCell {

    var titleLabel: UILabel!
    var frequencyLabel: UILabel!
    var priceLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: contentView.frame.width - 30, height: 15))
        contentView.addSubview(titleLabel)

        frequencyLabel = UILabel(frame: CGRect(x: 10, y: 25, width: contentView.frame.width - 30, height: 15))
        contentView.addSubview(frequencyLabel)

        priceLabel = UILabel(frame: CGRect(x: 300, y: 10, width: contentView.frame.width - 30, height: 20))
        contentView.addSubview(priceLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
