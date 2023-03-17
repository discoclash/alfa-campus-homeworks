import Foundation
// создаём класс узел (элемент нашего списка)
final class Node<Element> {
    // значене
    var value: Element
    // предыдущий узел
    var previous: Node<Element>?
    // следующий узел
    var next: Node<Element>?
    
    init(value: Element, previous: Node<Element>? = nil, next: Node<Element>? = nil) {
        self.value = value
        self.previous = previous
        self.next = next
    }
    // для проверки что узел умериает при удалении
    deinit{
        print("Node die")
    }
}

// создаём структуру для двусвязного списка
struct DoubleLinkedList<Element> {
    // первый элемент
    private(set) var head: Node<Element>?
    // последний элемент
    private(set) var tail: Node<Element>?
    // размер списка
    private(set) var count: Int = 0
    
    // добавление узла в хвост списка
    mutating func append(value: Element) {
        let newNode = Node(value: value)
        guard self.head != nil else {
            self.head = newNode
            self.tail = newNode
            self.count += 1
            return
        }
        self.tail?.next = newNode
        newNode.previous = self.tail
        self.tail = newNode
        self.count += 1
    }
    
    // добавление узла в начало списка
    mutating func insertHead(value: Element) {
        let newNode = Node(value: value)
        guard self.head != nil else {
            self.head = newNode
            self.tail = newNode
            self.count += 1
            return
        }
        self.head?.previous = newNode
        newNode.next = self.head
        self.head = newNode
        self.count += 1
    }
}

// расширение "последовательность" для списка. Позволит осуществить поиск запрашиваемого элемента стандартными методами для последовательности
extension DoubleLinkedList: Sequence {
    func makeIterator() -> DoubleLinkedListIterator<Element> {
        return DoubleLinkedListIterator(current: head)
    }
    // создаём итератор для следования протоколу Sequence
    struct DoubleLinkedListIterator<Element>: IteratorProtocol {
        var current: Node<Element>?
        
        mutating func next() -> Node<Element>? {
            defer { current = current?.next }
            return current
        }
    }
}

// т.к. наш список теперь является последовательностью, можем добавить методы с итерацией по списку
extension DoubleLinkedList {
    
    // метод удаления узла из списка по индексу:
    mutating func remove(atIndex index: Int) {
        guard self.head != nil else {
            print("Ошибка! Cписок пуст")
            return
        }
        guard index >= 0 && index <= (self.count - 1) else {
            print("Ошибка! Индекс отсутствует в списке")
            return
        }
        for (nodeIndex, node) in self.enumerated() {
            guard nodeIndex == index else { continue }
            node.next?.previous = node.previous
            node.previous?.next = node.next
            break
        }
        // смещение начала и хвоста
        if index == 0 {
            self.head = head?.next
        }
        if index == (self.count - 1) {
            self.tail = tail?.previous
        }
        self.count -= 1
    }
    
    
    
    // метод добавления элемента по индексу
    mutating func insert(toIndex index: Int, value: Element) {
        guard index >= 0 && index <= (self.count - 1) else {
            print("Ошибка! Индекс отсутствует в списке")
            return
        }
        if index == 0 {
            insertHead(value: value)
            return
        }
        if index == (self.count - 1) {
            append(value: value)
            return
        }
        for (nodeIndex, node) in self.enumerated() {
            guard nodeIndex == index else { continue }
            var newNode = Node(value: value)
            node.previous?.next = newNode
            newNode.previous = node.previous
            newNode.next = node
            node.previous = newNode
            self.count += 1
            break
        }
    }
}

extension DoubleLinkedList where Element: Equatable {
    
    // метод удаление узла из списка по значению (в данной реализации удаляются все узлы с искомым значением
    mutating func remove(value: Element) {
        guard self.head != nil else {
            print("Ошибка! Cписок пуст")
            return
        }
        for node in self {
            guard node.value == value else { continue }
            // смещение начала списка, если искомый элемент первый
            if node.previous == nil {
                self.head = node.next
            }
            // смещение хвоста списка, если искомый элемент последний
            if node.next == nil {
                self.tail = node.previous
            }
            node.next?.previous = node.previous
            node.previous?.next = node.next
            self.count -= 1
        }
    }
}

// сабскрипт для списка:
extension DoubleLinkedList {
    subscript(index: Int) -> Element? {
        guard index >= 0 && index <= (self.count - 1) else { return nil }
        var array = self.map { $0.value }
        return array[index]
    }
}


// Реализация Copy On Write

// класс Reference, который будет обарачивать наш тип значения DoubleLinkedList
final class Reference<T> {
  var objectCOW: T
    
  init(objectCOW: T) {
      self.objectCOW = objectCOW
  }
}

// cтруктура Box, которая будет оборачивать Reference
struct Box<T> {
    // это свойство и является нашей ссылкой в реализации Copy On Write
  var reference: Reference<T>
    
  init(objectCOW: T) {
      reference = Reference(objectCOW: objectCOW)
  }
    
    var objectCOW: T {
        get {
            return reference.objectCOW
        }
        set {
            // если ссылка одна, то функция ниже вернёт true, иначе false
            if !isKnownUniquelyReferenced(&reference) {
                // false, ссылка не одна, поэтому для этой ссылки создём новый экзэмпляр класса, в который положим newValue
                reference = Reference(objectCOW: newValue)
            } else {
                // true, ссылка одна, поэтому просто меняем у нее значение
                reference.objectCOW = newValue
            }
        }
    }
}


// ПРОВЕРКА РЕЗУЛЬТАТА

// создаём список
var list = DoubleLinkedList<Int>()

// вставка новых элементов
func fillList() {
    for i in 1...6 {
        if i % 2 == 0 {
            list.append(value: i)
        } else {
            list.insertHead(value: i)
        }
    }
}
fillList()
fillList()
fillList()
fillList()

// печать списка
for (index, node) in list.enumerated() {
    print("\(index) - \(node.value)")
}
print("----------")
// вставка по индексу
list.insert(toIndex: 1, value: 5)
for (index, node) in list.enumerated() {
    print("\(index) - \(node.value)")
}
print("----------")

// сабскрипт
list[17]
list[21]
list[-2]

// удаление из списка по значению
list.remove(value: 1)
list.remove(value: 6)
list.remove(value: 3)

print("----------")

// удалене из списка по индексу
list.remove(atIndex: 26)
list.remove(atIndex: 0)
list.remove(atIndex: 11)
list.remove(atIndex: 5)
print("----------")

for (index, node) in list.enumerated() {
    print("\(index) - \(node.value)")
}
print("----------")

// поиск элемента
list.contains(where: {$0.value == 10} )

// Сopy-on-write

// сначала оберём наш список в контейнер
var box1 = Box(objectCOW: list)
// структуры копируются, но их свойства "reference" лежат по одному адресу. т.к. являются классами
var box2 = box1

func address(_ pointer: UnsafeRawPointer) {
  print("address: \(Int(bitPattern: pointer))")
}

// адреса одинаковые
address(&box1.reference.objectCOW)
address(&box2.reference.objectCOW)

// здесь сработает set 196ой строки
box2.objectCOW.append(value: 10)

// адреса изменились!
address(&box1.reference.objectCOW)
address(&box2.reference.objectCOW)

print(box1.objectCOW.tail!.value)
print(box2.objectCOW.tail!.value)
