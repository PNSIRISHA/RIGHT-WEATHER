

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    @NSManaged public var user_id: String?
    @NSManaged public var creadit_card: String?
    @NSManaged public var expiry_date: String?
    @NSManaged public var first_name: String?
    @NSManaged public var image: String?
    @NSManaged public var last_name: String?

}
