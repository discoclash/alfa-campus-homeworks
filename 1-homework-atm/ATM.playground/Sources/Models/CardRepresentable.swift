/// Платежная система
public enum PaymentSystem {
    /// Виза
    case VISA
    /// Матсеркард
    case MC
    /// Мир
    case MIR
}

public protocol CardRepresentable {
    /// Сумма на карте
    var amount: AmountRepresentable { get }
    /// Платежная система
    var paymentSystem: PaymentSystem { get }
}
