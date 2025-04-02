import Foundation

//DEFINE BEVERAGE FIRST TO SET ITS PROPERTIES
struct Beverage {
    let name: String
    let prep: String
    let caffeine: Int
}

class BeverageManager {
    static let shared = BeverageManager()
    
    private init() {}
    
    // READ CSV INTO DICTIONARY
    func readCSV() -> [Beverage] {
        guard let filePath = Bundle.main.path(forResource: "starbucks", ofType: "csv") else {
            return []
        }
        
        var beverages: [Beverage] = []
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = content.components(separatedBy: "\n")
            
            for row in rows {
                let components = row.components(separatedBy: ",")
                if components.count == 3 {
                    let name = components[0]
                    let prep = components[1]
                    let caffeine = Int(components[2]) ?? 0
                    
                    beverages.append(Beverage(name: name, prep: prep, caffeine: caffeine))
                }
            }
        } catch {
            print("Error reading CSV file: \(error)") //WORKS
        }
        
        return beverages
    }
    
    func getUniqueBeverages() -> [String] {
        let beverages = readCSV()
        let uniqueBeverages = Set(beverages.map { $0.name })
        return Array(uniqueBeverages)
    }
    func getAvailableSizes(for drinkName: String) -> [String] {
        let beverages = readCSV()
        let sizes = beverages.filter { $0.name == drinkName }.map { $0.prep }
        return Array(Set(sizes))
    }
    func getCaffeineContent(for drinkName: String, size: String) -> Int {
        let beverages = readCSV()
        let matchingBeverages = beverages.filter { $0.name == drinkName && $0.prep == size }
        return matchingBeverages.first?.caffeine ?? 0
    }
}


