public protocol AmountRepresentable {
    /// Значение (без копеек и центов)
    var value: Int { get }
    /// Валюта
    var currency: Currency { get }
}
