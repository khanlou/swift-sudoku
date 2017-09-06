import Foundation


do {
    let boardString = "..3.2.6..9..3.5..1..18.64....81.29..7.......8..67.82....26.95..8..2.3..9..5.1.3.."
    let board = Board(boardString: boardString)
    let solver = Solver(board: board)
    
    print(board)
    solver.isSolved
    solver.solve()
    solver.isSolved
    print(solver.board)
}




































//do { //hard
//    let boardString = "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......"
//    let board = Board(boardString: boardString)
//    let solver = Solver(board: board)
//    
//    print(board)
//    solver.isSolved
//    solver.solve()
//    solver.isSolved
//    
//    print(solver.board)
//}
