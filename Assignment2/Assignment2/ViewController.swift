import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let dataArray = [
        ("Dell", "2.7Ghz", "$1299.99"),
        ("Apple", "2Ghz", "$2299.99"),
        ("HP", "2.3Ghz", "$399.99"),
        ("ASUS", "2.8Ghz", "$399.99"),
        ("Acer", "2.3Ghz", "$399.99"),
        ("IBM Tablet(8888617)", "2.3Ghz", "$999.99"),
        ("LENOVO", "2.3Ghz", "$399.99")

    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建自定义返回按钮
        let backButtonImage = UIImage(named: "plus")  // 替换为你的图片名称
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: nil, action: nil)

        // 隐藏返回按钮的标题
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)

        // 设置导航栏左侧按钮为自定义返回按钮
        navigationItem.leftBarButtonItem = backButton
        

        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell

        let (title, frequency, price) = dataArray[indexPath.row]

        cell.titleLabel.text = title
        cell.frequencyLabel.text = frequency
        cell.priceLabel.text = price

        return cell
    }
}
