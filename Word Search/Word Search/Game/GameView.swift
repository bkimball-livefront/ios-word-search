//
//  GameView.swift
//  Word Search
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var isDragging = false

    private var foundPositions: Set<Position> {
        Set(viewModel.puzzle.placedWords
            .filter { viewModel.foundWords.contains($0.word) }
            .flatMap { $0.positions })
    }

    private var selectedPositions: Set<Position> {
        Set(viewModel.selection)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Find the hidden words")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: viewModel.newGame) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                }
                .accessibilityLabel("New game")
            }

            HStack(spacing: 12) {
                ForEach(puzzleWords, id: \.self) { word in
                    let found = viewModel.foundWords.contains(word)
                    Text(word)
                        .strikethrough(found)
                        .foregroundStyle(found ? Color.accentColor : Color.primary)
                }
            }
            .padding(.top, 12)

            Text("\(viewModel.foundWords.count) / \(puzzleWords.count) found")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
                .padding(.bottom, 24)

            GeometryReader { geometry in
                let cellSize = geometry.size.width / CGFloat(gridSize)

                VStack(spacing: 0) {
                    ForEach(0..<gridSize, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<gridSize, id: \.self) { col in
                                let position = Position(row: row, col: col)
                                Text(String(viewModel.puzzle.grid[row][col]))
                                    .font(.system(size: 18, weight: .medium))
                                    .frame(width: cellSize, height: cellSize)
                                    .background(backgroundColor(for: position))
                                    .border(Color.gray.opacity(0.4), width: 0.5)
                            }
                        }
                    }
                }
                .border(Color.gray)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let position = gridPosition(for: value.location, cellSize: cellSize)
                            if isDragging {
                                viewModel.onDragTo(position)
                            } else {
                                isDragging = true
                                viewModel.onDragStart(position)
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                            viewModel.onDragEnd()
                        }
                )
            }
            .aspectRatio(1, contentMode: .fit)

            if viewModel.isComplete {
                Text("You found all the words!")
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
                    .padding(.top, 24)
            }

            Spacer()
        }
        .padding(24)
    }

    private func backgroundColor(for position: Position) -> Color {
        if foundPositions.contains(position) {
            return Color.accentColor.opacity(0.3)
        }
        if selectedPositions.contains(position) {
            return Color.blue.opacity(0.25)
        }
        return .clear
    }

    private func gridPosition(for point: CGPoint, cellSize: CGFloat) -> Position {
        let row = min(max(Int(point.y / cellSize), 0), gridSize - 1)
        let col = min(max(Int(point.x / cellSize), 0), gridSize - 1)
        return Position(row: row, col: col)
    }
}

#Preview {
    GameView()
}
