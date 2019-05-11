import CoreData
import Foundation

class Person: NSManagedObject {
    class func insertWithRandomName(in context: NSManagedObjectContext) -> Person {
        let p =  Person(context: context)
        p.name = self.randomPersonName()

        return p
    }

    // MARK: - Public Methods

    // MARK: - Private Methods
    class func randomPersonName() -> String {
        let nameArray = ["Harry", "Zayn", "Niall", "Liam", "Louis"]
        let random = arc4random_uniform(UInt32(nameArray.count))
        let idx = Int(random)
        return nameArray[idx]
    }
}
