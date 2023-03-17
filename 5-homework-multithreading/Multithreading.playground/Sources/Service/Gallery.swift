import Foundation
import UIKit

public class Gallery {
    public static func exportImage(named: String) -> UIImage {
        sleep(1) // Имитация долгой загрузки
        return UIImage(named: named)!
    }
}
