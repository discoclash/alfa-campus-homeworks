/*:
 ## Банкомат

 ![Банкомат](ATM.jpg)

Привет! Давай разработаем ПО для банкомата :) Ниже приведены задания, и давай шаг за шагом попробуем изобрести свой банкомат
 */
/*:
 ### Задание 1

 Нужно создать модели
 1. ***Карты*** (модель должна поддерживать протокол **CardRepresentable**)
 2. ***Банкноты*** (модель должна поддерживать протокол **BanknotRepresentable**)
 3. ***Суммы*** (модель должна поддерживать протокол **AmountRepresentable**)

Создавай эти модели ниже под этим заданием, стирай строку и пиши код :)
 */

import Foundation

struct Card: CardRepresentable {
    var amount: AmountRepresentable
    var paymentSystem: PaymentSystem
}

struct Banknot: BanknotRepresentable {
    var denomination: Int
    var currency: Currency
}

struct Amount: AmountRepresentable {
    var value: Int
    var currency: Currency
}

/*:
 ### Задание 2

Теперь тебе нужно реализовать **ATMMachineManager**, который будет отвечать за выдачу денег из нашего банкомата и прием купюр в наш банкомат.
 * В этом задании заполним **banknoteUniqueStore**, используя модель из **Задания 1**, которая поддерживает протокол **BanknotRepresentable**. Будем считать, что банкомат содержит бесконенчное число банкнот каждого номинала, в **banknoteUniqueStore** указываем каждый номинал один раз, чтобы показать, что этот номинал есть в банкомате. Заполнять будем по следующему правилу
   1. Для валюты RUB, будут банкноты номиналом 50/100/200/500/1000/2000/5000
   2. Для валюты USD, будут банкноты номиналом 10/20/50/100
 */

final class ATMMachineManager {
    /// Для задания 2-3
    private let banknoteUniqueStore: [Currency : [BanknotRepresentable]] = [
        .RUB : [Banknot(denomination: 50, currency: .RUB),
                Banknot(denomination: 100, currency: .RUB),
                Banknot(denomination: 200, currency: .RUB),
                Banknot(denomination: 500, currency: .RUB),
                Banknot(denomination: 1000, currency: .RUB),
                Banknot(denomination: 2000, currency: .RUB),
                Banknot(denomination: 5000, currency: .RUB)],
        .USD : [Banknot(denomination: 10, currency: .USD),
                Banknot(denomination: 20, currency: .USD),
                Banknot(denomination: 50, currency: .USD),
                Banknot(denomination: 100, currency: .USD)]
    ]
    /// Для задания 4
    private(set) var depositBanknots: [BanknotRepresentable] = []

    /// Снять наличные с карты (Задание 3)
    func withdraw(amount: AmountRepresentable, from card: CardRepresentable) throws -> [BanknotRepresentable] {
        // проверяем запрос на корректность и возвращаем отсортированный массив доступных купюр
        let sortedStore = try checkingCashRequest(amount: amount, card: card)
        // создаём пустой массив с купюрами, который будем наполнять и возвращать функцией
        var cash: [BanknotRepresentable] = []
        // переменная с запрашиваемой суммой, из которой будем вычитать добавленные в массив купюры
        var amountCount = amount.value
        // идём по массиву с банкнотами от большей к меньшей
        for banknot in sortedStore {
            //добавление купюр одного номинала в массив
            while banknot.denomination <= amountCount {
                amountCount -= banknot.denomination
                cash.append(Banknot(denomination: banknot.denomination, currency: banknot.currency))
            }
        }
        return cash
    }

    /// Пополнение банкомата банкнотами (Задание 4)
    func deposit(banknots: [BanknotRepresentable], fakeBanknotHandler: (BanknotRepresentable) -> ()) {
        // идём циклом по массиву бонкнот и откладываем в фальш каждую третью купюру
        for (index, banknot) in banknots.enumerated() {
            if ((index + 1) % 3) == 0 {
                fakeBanknotHandler(banknot)
            } else {
                depositBanknots.append(banknot)
            }
        }
    }
}
// расширение для обработки ошибок
extension ATMMachineManager {
    ///создаю перечисления с ошибками для функции withdraw
    enum ATMMachineError: LocalizedError {
        case invalidRequest(minBanknot: Int)
        case insufficientFunds
        case incorrectCurrency
        case emptyStore
         //описание ошибок
        var errorDescription: String? {
            switch self {
            case .invalidRequest(let minBanknot):
                return "Введите сумму кратную \(minBanknot), банкомат не выдаёт монет"
            case .insufficientFunds:
                return "Недостоточно средств"
            case .incorrectCurrency:
                return "Выбрана неверная валюта"
            case .emptyStore:
                return "В банкомате нет банкнот"
            }
        }
    }
    // функция проверки запроса выдачи наличных на наличие ошибок
    private func checkingCashRequest(amount: AmountRepresentable, card: CardRepresentable) throws -> [BanknotRepresentable] {
        // проверка на соответсвие валюты
        guard amount.currency == card.amount.currency else { throw ATMMachineError.incorrectCurrency }
        // проверка, доступна ли на балансе запрашиваемая сумма
        guard card.amount.value >= amount.value else { throw ATMMachineError.insufficientFunds }
        // сортируем массив с доступными купюрами и создаём константу с минимальной из доступных купюр
        guard let sortedStore = banknoteUniqueStore[amount.currency]?.sorted(by: { $0.denomination > $1.denomination }),
              let minBanknot = sortedStore.last?.denomination else { throw ATMMachineError.emptyStore }
        // проверка кратна ли запрашиваемая сумма минимальной купюре
        guard (amount.value % minBanknot) == 0 && amount.value != 0 else { throw ATMMachineError.invalidRequest(minBanknot: minBanknot) }
        return sortedStore
    }
}
/*:
### Задание 3

Самое интересное задание :) Реализовать логику внутри функции **func withdraw(amount:from:) -> [BanknotRepresentable]**, которая на вход принимает запрашиваемую **сумму**, **карту** с которой будут списывать деньги, а на выходе отдает **массив банкнот**, которые получает клиент. Требования и допущения:
 1. Мы должны выдать клиенту **НАИМЕНЬШЕЕ** количество банкнот
 2. Предпологаем, что банкомат обладает бесконенчным запасом денег любых купюр, которые мы указали в **banknoteUniqueStore** в **Задание 2** :)
 3. Копейки/центы и монеты банкомат не умеет выдавать
 4. Нужно убедиться, что запрашиваемая сумма есть на карте клиента, в противном случае вернуть пустой массив банкнот
 5. Нужно убедиться, что запрашиваемая валюта совпадает с валютой карты :) В противном случае, снова вывести пустой массив

 Задание продолжаем делать в классе **ATMMachineManager**
*/
/*:
 ### Задание 4

Теперь наш банкомат умеет выдавать деньги. Но банкомат так же нужно пополнять (хотя у нас бесконечное число банкнот), но пополнять все равно хотим :) В этом задании нам предстоит реализовать функцию **func deposit(banknots:fakeBanknotHandler:)**. На вход в функции подается массив банкнот и нужно проверить, если банкнота фальшивая, то отдать эту банкноту в **fakeBanknotHandler**, если же с банкнотой все хорошо, то складываем в **depositBanknots**. Считаем, что каждая **третья** банкнота в массиве **фальшивая**.

 Задание продолжаем делать в классе **ATMMachineManager**
 */
/*:
 ### Задание 5

 Ну что, запустим наш банкомат? :) Ниже есть класс **Controller**. В нем содержится тот самый менеджер, который реализовали выше. В этом задании нужно наполнить метод **run** следующей логикой
 1. Создать модель карты из **Задания 1** (сумму на карте задай сам(а), как и платежную систему)
 2. Создать модель запрашиваемой суммы из **Задания 1**
 3. Сделать массив банкнот, воспользовавшись моделью банкноты из **Задания 1**
 4. Вызвать метод  **withdraw** у **manager** с данными из пункта 1 и 2 и распечать с помощью print номиналы банкнот, которые вернул метод **withdraw**
 5. Вызвать метод **deposit** у **manager**  с данными из пункта 3 и реализовать **fakeBanknotHandler**, который должен распечатывать с помощью print номинал фальшивой банкноты.

 После того, как реализованы все шаги, запускаем код и наслаждаемся :)
 */

final class Controller {
    private let manager = ATMMachineManager()

    func run() {
        // создаём модель карты
        var card = Card(amount: Amount(value: 1000, currency: .RUB), paymentSystem: .VISA)
        // создаём модель запрашиваемой суммы
        var requstedAmount = Amount(value: 1000, currency: .RUB)
        // мавссив банкнот для депозита в банкомат
        let cashForDeposit = [Banknot(denomination: 50, currency: .RUB),
                              Banknot(denomination: 100, currency: .RUB),
                              Banknot(denomination: 200, currency: .RUB),
                              Banknot(denomination: 500, currency: .RUB),
                              Banknot(denomination: 1000, currency: .RUB),
                              Banknot(denomination: 2000, currency: .RUB),
                              Banknot(denomination: 5000, currency: .RUB),
                              Banknot(denomination: 10, currency: .USD),
                              Banknot(denomination: 20, currency: .USD),
                              Banknot(denomination: 50, currency: .USD),
                              Banknot(denomination: 100, currency: .USD)]
        //запрашиваем сумму в банкомате и распечатываем результат запроса
        do {
            var cashFromATMMachine = try manager.withdraw(amount: requstedAmount, from: card)
            print("Выданные банкноты:")
            for (index, banknot) in cashFromATMMachine.enumerated() {
                print("\(index + 1) - \(banknot.denomination) \(banknot.currency)")
            }
        } catch {
            print(error.localizedDescription)
        }
        // сортируем фальшивые купюры для депозита и распечатываем их с помощью замыкания
        manager.deposit(banknots: cashForDeposit) { print("Фальшивая банкнота: \($0.denomination) \($0.currency)") }
    }
}

let controller = Controller()
controller.run()
