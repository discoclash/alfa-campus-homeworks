/*:
 ### Задание 4

 1. Изучи код ниже
 2. Есть ли retain cycle в этом коде?
 3. Если есть, то как можно исправить retain cycle?

 Логика работы кода должна сохраняться, если вдруг понимаешь, что нужно править код, чтобы поправить retain cycle.

 Формат ответа:
     - Поправлен код (если требуется)
     - Обоснование коментом на ПРе, почему это фиксит проблему, если была проблема

 */

class MyClass {

    var doSomething: (() -> Void)?
    var doSomethingElse: (() -> Void)?

    var didSomething: Bool = false
    var didSomethingElse: Bool = false

    func doEverything() {

        print("start")
        doSomething = { [weak self] in
            guard let self = self else { return }
            self.didSomething = true
            print("did something")

            self.doSomethingElse = { [weak self] in
                guard let self = self else { return }
                self.didSomethingElse = true
                print("did something else")
            }

            self.doSomethingElse?()
        }
        doSomething?()
    }
}

// Стартовая точка программы
func main() {
    let model = MyClass()
    model.doEverything()
}

// Запуск программы
main()
