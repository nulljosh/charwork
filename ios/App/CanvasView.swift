// The character grid itself.
//
// ponytail: one Text draw per ROW, not per cell — 50 draws instead of 5,000.
// Monospace guarantees a uniform advance, so a whole-line draw lands on the same
// column boundaries the tap math uses.

import SwiftUI

struct CanvasView: View {
    let grid: Grid
    let fontSize: CGFloat
    let onTap: (Int, Int) -> Void

    private var uiFont: UIFont {
        UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
    }

    private var charW: CGFloat { ("M" as NSString).size(withAttributes: [.font: uiFont]).width }
    private var charH: CGFloat { uiFont.lineHeight }

    private var cols: Int { grid.first?.count ?? 0 }
    private var rows: Int { grid.count }

    private var canvasSize: CGSize {
        CGSize(width: charW * CGFloat(cols), height: charH * CGFloat(rows))
    }

    var body: some View {
        Canvas(rendersAsynchronously: false) { context, _ in
            draw(in: &context)
        }
        .frame(width: canvasSize.width, height: canvasSize.height, alignment: .topLeading)
        .background(Theme.canvas)
        .overlay(Rectangle().strokeBorder(Theme.rule, lineWidth: 1))
        .gesture(tapGesture)
    }

    private func draw(in context: inout GraphicsContext) {
        let font = Font(uiFont)
        for r in 0..<rows {
            let line = String(grid[r])
            guard line.contains(where: { $0 != " " }) else { continue }
            let text = Text(line).font(font).foregroundStyle(Theme.ink)
            context.draw(text, at: CGPoint(x: 0, y: charH * CGFloat(r)), anchor: .topLeading)
        }
    }

    private var tapGesture: some Gesture {
        SpatialTapGesture().onEnded { value in
            let cell = pxToCell(
                px: value.location.x, py: value.location.y,
                charW: charW, charH: charH
            )
            guard cell.col >= 0, cell.col < cols, cell.row >= 0, cell.row < rows else { return }
            onTap(cell.col, cell.row)
        }
    }
}
