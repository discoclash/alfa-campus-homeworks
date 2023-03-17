/*:
 ### Задание 2

 Есть некий service, который проверяет статус пользователя. В нашем случае он всегда будет возвращать loggedIn статус. ViewController хранит в себе текущего пользователя и сервис для проверки статуса этого пользователя. Есть ли retain cycle в этом коде? Если есть, то как можно исправить retain cycle? Логика работы кода должна сохраняться, если вдруг понимаешь, что нужно править код, чтобы поправить retain cycle.

 Формат ответа:
     - Поправлен код (если требуется)
     - Обоснование коментом на ПРе, почему это фиксит проблему, если была проблема

 */


import UIKit

enum LoginStatus {
    case loggedIn(User)
    case guest
}

class User {
    var status: LoginStatus = .guest

    func someFunc() {
        print("some func")
    }
}

class UserService {
    func checkStatus(user: User, _ completion: (LoginStatus) -> ()) {
        user.someFunc()
        completion(.loggedIn(user))
    }
}

class ViewController: UIViewController {
    let service = UserService()
    let user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        service.checkStatus(user: user) { status in
            user.status = status
        }
    }
}

// Стартовая точка программы
func main() {
    let viewController = ViewController()
    viewController.loadViewIfNeeded()
    viewController.user.status = .guest
}

// Запуск программы
main()
