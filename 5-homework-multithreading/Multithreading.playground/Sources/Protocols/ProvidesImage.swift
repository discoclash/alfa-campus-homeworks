import UIKit

public protocol ProvidesImage {
    func fetchImage(named: String, _ completion: @escaping (UIImage) -> ())
}
