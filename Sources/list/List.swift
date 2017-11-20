precedencegroup JoinGroup {
    associativity: right
}

precedencegroup AttachGroup {
    associativity: right
    higherThan: JoinGroup
}
infix operator ++: AttachGroup
infix operator +++: JoinGroup

public indirect enum List<T> {
    /// an empty list
    case empty
    
    /// a list with head and tail
    case cons(head: T, tail: List<T>)
    
    /// creates a list with `element` as the new head
    /// Complexity: O(1)
    public func prepend(_ element: T) -> List<T> {
        return .cons(head: element, tail: self)
    }
    
    /// short hand syntax for prepending a head to a list
    /// Complexity: O(1)
    public static func ++(head: T, tail: List<T>) -> List<T> {
        return tail.prepend(head)
    }
    
    /// Append `other` to self.
    /// Complexity: O(n)
    public func append(_ other: List<T>) -> List<T> {
        switch self {
        case .empty: return other
        case let .cons(head, tail):
            return .cons(head: head, tail: tail.append(other))
        }
    }
    
    /// Short hand syntax for appending two lists.
    /// Complexity: O(n)
    public static func +++(lhs: List<T>, rhs: List<T>) -> List<T> {
        return lhs.append(rhs)
    }
    
    /// Returns the number of elements in the list
    /// Complexity: O(n)
    public var count: Int {
        switch self {
        case .empty: return 0
        case let .cons(_, tail): return 1 + tail.count
        }
    }
    
    /// Returns if the list is empty
    /// Complexity: O(1)
    public var isEmpty: Bool {
        switch self {
        case .empty: return true
        case .cons: return false
        }
    }
    
    /// Returns the element at index `index`. **NOTE** Crashes if index is out of bounds!
    /// Complexity: O(n)
    public func element(at index: Int) -> T {
        switch self {
        case .empty: preconditionFailure("Index out of bounds!")
        case let .cons(head, tail):
            return index == 0 ? head : tail.element(at: index - 1)
        }
    }
    
    /// Returns the element at index `index`. **NOTE** Crashes if index is out of bounds!
    /// Complexity: O(n)
    public subscript(_ index: Int) -> T {
        return self.element(at: index)
    }
    
    /// Transform each element in the list to create a new one.
    /// Complexity: O(n)
    public func map<U>(_ transform: (T) -> U) -> List<U> {
        switch self {
        case .empty: return .empty
        case let .cons(head, tail):
            return .cons(head: transform(head), tail: tail.map(transform))
        }
    }
    
    /// Transforms each element to a list and creates a flattened list out of it.
    /// Complexity: O(n*m)
    public func flatMap<U>( _ transform: (T) -> List<U>) -> List<U> {
        switch self {
        case .empty: return .empty
        case let .cons(head, tail):
            return transform(head).append(tail.flatMap(transform))
        }
    }
    
    /// Filters the list and only includes elements then produce `true` when `isIncluded` is called.
    /// Complexity: O(n)
    public func filter(_ isIncluded: (T) -> Bool) -> List<T> {
        return self.flatMap { e in
            return isIncluded(e) ? [e] : []
        }
    }
    
    /// Fold the list from the left to create a new value of type `U`.
    /// Complexity: O(n)
    public func foldLeft<U>(_ initial: U, iteration: (U, T) -> U) -> U {
        switch self {
        case .empty: return initial
        case let .cons(head, tail):
            return tail.foldLeft(iteration(initial, head), iteration: iteration)
        }
    }
    
    /// Fold the list from the right to create a new value of type `U`.
    /// Complexity: O(n)
    public func foldRight<U>( _ initial: U, iteration: (T, U) -> U) -> U {
        switch self {
        case .empty: return initial
        case let .cons(head, tail):
            return tail.foldRight(iteration(head, initial), iteration: iteration)
        }
    }
    
    /// Fold the list from the left to create a new value of type `U`.
    /// Complexity: O(n)
    public func reduce<U>(_ initial: U, iteration: (U, T) -> U) -> U {
        return self.foldLeft(initial, iteration: iteration)
    }
    
    /// Returns the list with its first element removed.
    /// **NOTE**: If list does not have any elements, the empty list is returned.
    public func removeFirst() -> List<T> {
        switch self {
        case .empty: return .empty
        case let .cons(_, tail):
            return tail
        }
    }
}

extension List: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
    
    public init(_ elements: T...) {
        self.init(elements)
    }
    
    private init(_ elements: [T]) {
        self = elements.reversed().reduce(List.empty) { r, e in r.prepend(e) }
    }
}

extension List where T == String {
    
    /// Join all elements in the list together.
    /// Complexity: O(n)
    public func joined(separator: String = "") -> String {
        switch self {
        case .empty: return ""
        case let .cons(head, tail):
            return tail.foldLeft(head, iteration: { r, e in r + separator + e })
        }
    }
}

extension List: CustomStringConvertible {
    public var description: String {
        return "[" + self.map({ "\($0)" }).joined(separator: ", ") + "]"
    }
}

