/*:
У нас есть модель для счета Account с полями для названия счета, типа счета и валюты денег на счете, а также вспомогательные енамф. Мы хотим иметь возможность фильтровать массив счетов клиента по какому-то критерию. Давай сначала посмотрим на модели для счета:
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
/*:
 ### Задание 1

Мы хотим в новой структуре AccountFilter добавить метод для фильтрации аккаунтов, который принимает массив экземпляров Account и возвращает только те аккаунты, которые относятся к определенному AccountType.
 */

struct AccountFilter {
    func filterAccounts(_ accounts: [Account], by filter: AccountType) -> [Account] {
        accounts.filter { $0.type == filter }
    }
}

/*:
 Для самопроверки можешь раскомментировать следующий код, поменяв нейминги на свои
 */
let rubbleCreditAccount = Account(name: "Альфа-счет", type: .credit, currency: .rubble)
let euroDepositAccount = Account(name: "Альфа-счет", type: .deposit, currency: .euro)
let result1 = AccountFilter().filterAccounts([rubbleCreditAccount, euroDepositAccount], by: .deposit)
print(result1) //[deposit euro Альфа-счет]
