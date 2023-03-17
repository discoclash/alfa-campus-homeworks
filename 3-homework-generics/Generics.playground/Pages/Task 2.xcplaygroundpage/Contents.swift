/*:
 ### Задание 2
 В какой-то момент в проекте стало много аналогичных фильтров, фильтрующих разные модели по разным критериям. Все эти объекты мы хотим привести к единому виду, подписав их под общий протокол Filters.
 
Для начала создадим протокол Satisfiable с методом isSatisfied, который на вход будет принимать параметр item ассоциативного типа и возвращать Bool.
 */
enum Currency {
    case rubble
    case dollar
    case euro
}

enum AccountType {
    case salary
    case deposit
    case credit
}

struct Account {
    var name: String
    var type: AccountType
    var currency: Currency

    init(name: String, type: AccountType, currency: Currency) {
        self.name = name
        self.type = type
        self.currency = currency
    }
}

extension Account: CustomStringConvertible {
    var description: String {
        return "\(type) \(currency) \(name)"
    }
}

protocol Satisfiable {
    associatedtype Item
    func isSatisfied(item: Item) -> Bool
}

/*:
 Теперь создадим 2 структуры *CurrencyAccountCriterion* и *AccountTypeCriterion*, подписанных под Satisfiable. Их метод isSatisfied должен возвращать true, если currency либо accountType параметра метода равен такому же свойству самой структуры.
 */
struct CurrencyAccountCriterion: Satisfiable {
    let currency: Currency
    func isSatisfied(item account: Account) -> Bool {
        account.currency == currency
    }
}

struct AccountTypeCriterion: Satisfiable {
    let type: AccountType
    func isSatisfied(item account: Account) -> Bool {
        account.type == type
    }
}

/*:
Для самопроверки можешь раскомментировать следующий код, поменяв нейминги на свои:
 */
 let euroCriterion = CurrencyAccountCriterion(currency: .euro)
 let result2 = euroCriterion.isSatisfied(item: Account(name: "", type: .deposit, currency: .dollar))
 print(result2) //false
