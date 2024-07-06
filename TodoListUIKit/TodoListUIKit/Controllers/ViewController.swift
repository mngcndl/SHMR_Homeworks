import UIKit
import SwiftUI

class ViewController: UITableViewController {

    let reuseIdentifier = "TodoCell"
    var items = [TodoItem]()
    var groupedTasks = [String: [TodoItem]]()
    var fileCache = FileCache()
    var dateScrollView: DateScrollView!
    
    @State private var text: String = ""
    @State private var priority: TodoItem.Priority = .usual
    @State private var deadlineEnabled: Bool = false
    @State private var deadline: Date = Date()


    var fileManager = FileManager.default
    var documentsURL: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    var tasksFileURL: URL {
        return documentsURL.appendingPathComponent("tasks.json")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        configureDateScrollView()
        loadTasks()
        addExampleTasks()
        groupTasksByDate()
        
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)

        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.bounds.height * 0.1),
                    button.widthAnchor.constraint(equalToConstant: 50),
                    button.heightAnchor.constraint(equalToConstant: 50)
                ])
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateSelection(_:)), name: .didSelectDate, object: nil)
    }
    
    @objc func buttonTapped() {
        let detailView = DetailView(text: $text, priority: $priority, deadlineEnabled: $deadlineEnabled, deadline: $deadline)

        let hostingController = UIHostingController(rootView: detailView)
        present(hostingController, animated: true)
    }
    
    func addExampleTasks() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            guard let date1 = dateFormatter.date(from: "2024-07-06"),
                  let date2 = dateFormatter.date(from: "2024-07-07") else {
                return
            }

        let task1 = TodoItem(text: "Task 1", priority: .high, deadline: date1, done: false)
        let task2 = TodoItem(text: "Task 2", priority: .low, deadline: date2, done: false)

            items.append(task1)
            items.append(task2)
        }

    @objc func handleDateSelection(_ notification: Notification) {
        guard let selectedDate = notification.object as? Date else { return }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.register(TodoCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    func configureNavigationBar() {
        title = "Мои дела"
        let calendarButton = UIBarButtonItem(title: "Calendar", style: .plain, target: self, action: #selector(showCalendar))
        navigationItem.rightBarButtonItem = calendarButton
    }

    @objc func showCalendar() {
        let calendarVC = CalendarViewController()
        navigationController?.pushViewController(calendarVC, animated: true)
    }

    func configureDateScrollView() {
        dateScrollView = DateScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        dateScrollView.dates = loadDates()
        tableView.tableHeaderView = dateScrollView
    }
    
    func addDates() {
        let newDates = loadDates()
        dateScrollView.setDates(newDates)
    }

    @objc func addNewTask() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let newDate = dateFormatter.date(from: "2024-07-08") {
            let newTask = TodoItem(text: "New Task", priority: .usual, deadline: newDate, done: false)
            items.append(newTask)
            groupTasksByDate()
        }
    }

    func loadTasks() {
        items = []
        saveTasks()
    }


    func saveTasks() {
        fileCache.saveItemsToFile(filename: "tasks.json")
    }

    func groupTasksByDate() {
        groupedTasks.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        
        for item in items {
            guard let deadline = item.deadline else { continue }
            let dateString = dateFormatter.string(from: deadline)
            
            if groupedTasks[dateString] != nil {
                groupedTasks[dateString]?.append(item)
            } else {
                groupedTasks[dateString] = [item]
            }
        }
        
        tableView.reloadData()
        addDates()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedTasks.keys.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(groupedTasks.keys)[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(groupedTasks.keys)[section]
        return groupedTasks[key]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let key = Array(groupedTasks.keys)[indexPath.section]
        if let todoItem = groupedTasks[key]?[indexPath.row] {
            cell.configure(with: todoItem)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let key = Array(self.groupedTasks.keys)[indexPath.section]
        var item = groupedTasks[key]?[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            self.fileCache.removeItem(id: item?.id ?? "")
            self.groupedTasks[key]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveTasks()
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red

        let completeAction = UIContextualAction(style: .normal, title: "Complete") { (_, _, completionHandler) in
            item?.done = true
            self.fileCache.addItem(item: item ?? TodoItem(text: "", priority: .usual, done: true))
            tableView.reloadRows(at: [indexPath], with: .automatic)
            self.saveTasks()
            completionHandler(true)
        }
        completeAction.backgroundColor = .green

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, completeAction])
        return configuration
    }
}

extension ViewController {

    func loadDates() -> [Date] {
        var dates = [Date]()
        let calendar = Calendar.current
        let today = Date()

        for dayOffset in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                dates.append(date)
            }
        }

        return dates
    }
}

extension Notification.Name {
    static let didSelectDate = Notification.Name("didSelectDate")
}
