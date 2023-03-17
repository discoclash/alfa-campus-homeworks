/*:
 ## Фоновая подгрузка изображений
 */

import Foundation
import PlaygroundSupport

class ViewModel: ProvidesImage {
    var cache: [String : UIImage] = [:]
    // создаем очередь OperationQueue для загрузки картинок
    let queue = OperationQueue()
    
    func fetchImage(named: String, _ completion: @escaping (UIImage) -> ()) {
        // проверяем есть ли картинка в кэше
        if let image = cache[named] {
                completion(image)
        } else {
            // ограничеваем кол-во одновременно загружаемых картинок
            queue.maxConcurrentOperationCount = 3
            let operation = BlockOperation {
                // создаем задачу для OperationQueue
                let image = Gallery.exportImage(named: named) // Очень долгий метод
                // отправляем прорисовку картинок на главный поток
                DispatchQueue.main.async {
                    completion(image)
                    // добавляем загруженную картинку в кэш
                    self.cache[named] = image
                }
            }
            // добавляем задачу в очередь
            queue.addOperation(operation)
        }
    }
}

/*:
 ## Вспомогательный код
 */

import SwiftUI

PlaygroundPage.current.setLiveView(
    ListView(
        viewModel: ViewModel()
    )
)
