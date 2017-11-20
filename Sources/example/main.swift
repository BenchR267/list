import list

let l = List(1, 2, 3, 4)

let l2 = l.foldLeft(0, iteration: +)

let l3 = (l +++ 5 ++ List(6, 7, 8)).foldRight([]) { e, r in
    return e ++ r
}.removeFirst().removeFirst().removeFirst()

print(l3)

