public protocol BanknotRepresentable {
    /// Номинал банкноты (50/100/200...)
    var denomination: Int { get }
    /// Валюта банкноты
    var currency: Currency { get }
}

