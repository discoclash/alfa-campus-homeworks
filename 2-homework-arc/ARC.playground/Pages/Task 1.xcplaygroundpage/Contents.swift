/*:
 ### Задание 1

 Есть Factory, которая собирает модуль фичи. Есть ли retain cycle в этом коде? Если есть, то как можно исправить retain cycle? Логика работы кода должна сохраняться, если вдруг понимаешь, что нужно править код, чтобы поправить retain cycle. То есть, модуль должен вывести все print, где они объявлены.

 Формат ответа:
     - Поправлен код (если требуется)
     - Обоснование коментом на ПРе, почему это фиксит проблему, если была проблема

 */


import UIKit

class Presenter {
    weak var viewController: ViewController?

    func someFunc() {
        print("some func in presenter")
        viewController?.someFunc()
    }
}

class ViewController: UIViewController {
    var interactor: Interactor?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.someFunc()
    }

    func someFunc() {
        print("some func in view controller")
    }
}

class Interactor {
    var presenter: Presenter?

    func someFunc() {
        print("some func in interactor")
        presenter?.someFunc()
    }
}

class Factory {
    func build() -> ViewController {
        let viewController = ViewController()
        let presenter = Presenter()
        let interactor = Interactor()
        viewController.interactor = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        return viewController
    }
}

// Стартовая точка программы
func main() {
    let factory = Factory()
    let viewController = factory.build()
    viewController.loadViewIfNeeded()
}

// Запуск программы
main()

