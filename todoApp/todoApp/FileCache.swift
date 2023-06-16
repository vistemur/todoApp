import Foundation

class FileCache {
    
    var todoItems = [String: TodoItem]()
    
    func add(_ item: TodoItem) {
        todoItems[item.id] = item
    }
    
    func remove(id: String) {
        todoItems[id] = nil
    }
    
    func save(to path: String) throws {
        let data = try JSONSerialization.data(withJSONObject: ["items": todoItems.map({ $0.value.json })])
        let fullPath = getDocumentsDirectory().appendingPathComponent(path)
        try data.write(to: fullPath)
    }
    
    func load(from path: String) throws {
        todoItems = [String: TodoItem]()
        let fullPath = getDocumentsDirectory().appendingPathComponent(path)
        let data = try Data(contentsOf: fullPath, options: .alwaysMapped)
        if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any],
           let items = json["items"] as? [[String: Any]] {
            for item in items {
                if let todoItem = TodoItem.parse(json: item) {
                    add(todoItem)
                }
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
