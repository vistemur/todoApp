import Foundation

struct TodoItem {
    let id: String
    let text: String
    let priority: Priority
    let done: Bool
    let creationDate: Date
    let deadline: Date?
    let editDate: Date?
    
    enum Priority: String {
        case high
        case normal
        case low
    }
}

protocol JSONParsable {
    var json: Any { get }
    static func parse(json: Any) -> Self?
}

extension TodoItem: JSONParsable {
    
    var json: Any {
        var json = [
            "id": id,
            "text": text,
            "done": done,
            "creationDate": creationDate.timeIntervalSince1970,
        ] as [String: Any]
        
        if let deadline = deadline {
            json["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let editDate = editDate {
            json["editDate"] = editDate.timeIntervalSince1970
        }
        
        if priority != .normal {
            json["priority"] = priority.rawValue
        }
        
        return json
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let json = json as? [String: Any],
              let id = json["id"] as? String,
              let text = json["text"] as? String,
              let done = json["done"] as? Bool,
              let creationDateInterval = json["creationDate"] as? TimeInterval else {
            return nil
        }
        
        var deadline: Date?
        if let deadlineInterval = json["deadline"] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: deadlineInterval)
        }
        
        var editDate: Date?
        if let editDateInterval = json["editDate"] as? TimeInterval {
            editDate = Date(timeIntervalSince1970: editDateInterval)
        }
        
        var priority = Priority.normal
        if let priorityText = json["priority"] as? String,
           let priorityStatus = Priority(rawValue: priorityText) {
            priority = priorityStatus
        }
        
        return TodoItem(id: id,
                        text: text,
                        priority: priority,
                        done: done,
                        creationDate: Date(timeIntervalSince1970: creationDateInterval),
                        deadline: deadline,
                        editDate: editDate)
    }
}
