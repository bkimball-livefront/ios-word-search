//
//  GameViewModel.swift
//  Word Search
//

import Combine
import Foundation

final class GameViewModel: ObservableObject {
    @Published private(set) var puzzle: WordSearchPuzzle = generatePuzzle()
    @Published private(set) var selection: [Position] = []
    @Published private(set) var foundWords: Set<String> = []

    var isComplete: Bool {
        foundWords.count == puzzleWords.count
    }

    private var dragStart: Position?

    func newGame() {
        puzzle = generatePuzzle()
        selection = []
        foundWords = []
        dragStart = nil
    }

    func onDragStart(_ position: Position) {
        dragStart = position
        selection = [position]
    }

    func onDragTo(_ position: Position) {
        guard let start = dragStart else { return }
        selection = straightLineBetween(start: start, end: position)
    }

    func onDragEnd() {
        if let match = puzzle.placedWords.first(where: { placed in
            !foundWords.contains(placed.word) &&
                (selection == placed.positions || selection == placed.positions.reversed())
        }) {
            foundWords.insert(match.word)
        }
        selection = []
        dragStart = nil
    }

    private func straightLineBetween(start: Position, end: Position) -> [Position] {
        let rowDelta = end.row - start.row
        let colDelta = end.col - start.col
        let rowStep = max(-1, min(1, rowDelta))
        let colStep = max(-1, min(1, colDelta))
        let length = max(abs(rowDelta), abs(colDelta))
        return (0...length)
            .map { i in Position(row: start.row + rowStep * i, col: start.col + colStep * i) }
            .filter { $0.row >= 0 && $0.row < gridSize && $0.col >= 0 && $0.col < gridSize }
    }
}
