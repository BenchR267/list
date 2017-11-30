import list

let l = List(1, 2, 3, 4)

switch l {
case .cons(1, .cons(let h, let t)):
    print("yay", h, t)
default:
    print("ney")
}
