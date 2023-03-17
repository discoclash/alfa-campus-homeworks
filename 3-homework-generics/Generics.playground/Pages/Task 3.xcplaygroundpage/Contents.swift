/*:
 ###  Задание 3. Теперь нужно создать протокол Filters с методом для фильтрации, который будет иметь 2 параметра:
1. Массив items из айтемов ассоциативного типа
2. Параметр *criterion*, тип которого конформит к протоколу Satisfiable. При этом ассоциативный тип из протокола Satisfiable должен быть равен ассоциативному типу из протокола Filters.

Подсказка: Подход тот же, что на 42 слайде лекции.
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

struct CurrencyAccountCriterion: Satisfiable {
    let currency: Currency
    func isSatisfied(item account: Account) -> Bool {
        if account.currency == currency { return true }
        return false
    }
}

struct AccountTypeCriterion: Satisfiable {
    let type: AccountType
    func isSatisfied(item account: Account) -> Bool {
        if account.type == type { return true }
        return false
    }
}

protocol Filters {
    associatedtype Criterion: Satisfiable
    associatedtype Item
}

extension Filters where Item == Criterion.Item {
    func filter(items: [Item], criterion: Criterion) -> [Item] {
        items.filter { criterion.isSatisfied(item: $0) }
    }
}
/*:
Наконец, реализуем наш протокол в структуре AccountFilterV2 для фильтрации массива экземпляров Account по определенному критерию.
 */
struct AccountFilterV2<T: Satisfiable>: Filters {
    typealias Criterion = T
    typealias Item = Account
}

/*:
Для самопроверки можешь раскомментировать следующий код, поменяв нейминги на свои:
 */

let rubbleCreditAccount = Account(name: "Альфа-счет", type: .credit, currency: .rubble)
let euroDepositAccount = Account(name: "Альфа-счет", type: .deposit, currency: .euro)
let euroCriterion = CurrencyAccountCriterion(currency: .euro)
let creditCriterion = AccountTypeCriterion(type: .credit)
let result3 = AccountFilterV2().filter(items: [euroDepositAccount, rubbleCreditAccount], criterion: euroCriterion)
let result4 = AccountFilterV2().filter(items: [euroDepositAccount, rubbleCreditAccount], criterion: creditCriterion)
print(result3) // [deposit euro Альфа-счет]
print(result4)
