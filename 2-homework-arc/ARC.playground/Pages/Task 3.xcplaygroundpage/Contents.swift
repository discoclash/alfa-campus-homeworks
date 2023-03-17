/*:
 ### Задание 3

 1. Изучи код ниже
 2. Есть ли retain cycle в этом коде?
 3. Если есть, то как можно исправить retain cycle?

 Логика работы кода должна сохраняться, если вдруг понимаешь, что нужно править код, чтобы поправить retain cycle.

 Формат ответа:
     - Поправлен код (если требуется)
     - Обоснование коментом на ПРе, почему это фиксит проблему, если была проблема

 */


import UIKit

class Service {
    func getData(completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            completion("hello world")
        }
    }
    deinit {
        print("service died")
    }
}
class Label: UILabel {
    deinit {
        print("Label died")
    }
}


class ViewController: UIViewController {
    let service = Service()
    let label = Label()

    override func viewDidLoad() {
        super.viewDidLoad()
        service.getData { data in
            self.label.text = data
            print(data)
            print(self.label.text)
        }
    }
    deinit {
        print("vc died")
    }
}

// Стартовая точка программы
func main() {
    let viewConroller = ViewController()
    viewConroller.loadViewIfNeeded()
}

// Запуск программы
main()
