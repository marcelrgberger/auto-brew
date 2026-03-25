#!/usr/bin/env swift

import AppKit

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}

func generateIcon(pixels: Int) -> Data? {
    let p = CGFloat(pixels)
    let center = CGPoint(x: p / 2, y: p / 2)

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    )!

    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    let g = ctx.cgContext

    // ═══════════════════════════════════════════════
    // 1. BACKGROUND — Deep Teal to Dark Emerald
    // ═══════════════════════════════════════════════
    // Deep Teal: #004D40 -> Dark Emerald: #064E3B
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.0, 0.30, 0.25), // Deep Teal
        color(0.02, 0.25, 0.15), // Dark Emerald
    ] as CFArray, locations: [0.0, 1.0])!
    
    // Draw diagonal gradient
    g.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: p), end: CGPoint(x: p, y: 0), options: [])

    // Subtle radial glow in the center to make the symbol pop
    let glowGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.0, 0.45, 0.35, 0.3),
        color(0.0, 0.20, 0.15, 0.0),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawRadialGradient(glowGrad,
        startCenter: center, startRadius: 0,
        endCenter: center, endRadius: p * 0.5, options: [])

    // ═══════════════════════════════════════════════
    // 2. THE HOP CONE SYMBOL — Geometric & Modern
    // ═══════════════════════════════════════════════
    let symbolColor = color(0.98, 0.98, 0.94) // Light cream / Off-white
    g.setFillColor(symbolColor)
    g.setStrokeColor(symbolColor)
    
    let scale: CGFloat = p * 0.55
    let sx = center.x
    let sy = center.y + (p * 0.05) // Slightly adjust for visual balance
    
    func drawScale(at pos: CGPoint, width: CGFloat, height: CGFloat, rotation: CGFloat) {
        g.saveGState()
        g.translateBy(x: pos.x, y: pos.y)
        g.rotate(by: rotation)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height/2))
        // Modern geometric petal/scale shape
        path.addCurve(to: CGPoint(x: 0, y: -height/2),
                      control1: CGPoint(x: width/2, y: height/2),
                      control2: CGPoint(x: width/2, y: -height/2))
        path.addCurve(to: CGPoint(x: 0, y: height/2),
                      control1: CGPoint(x: -width/2, y: -height/2),
                      control2: CGPoint(x: -width/2, y: height/2))
        path.closeSubpath()
        
        g.addPath(path)
        g.fillPath()
        g.restoreGState()
    }

    // Draw Hop Layers (Bottom to Top)
    
    // Row 4 (Bottom tip)
    drawScale(at: CGPoint(x: sx, y: sy - scale * 0.35), width: scale * 0.25, height: scale * 0.35, rotation: 0)
    
    // Row 3
    drawScale(at: CGPoint(x: sx - scale * 0.15, y: sy - scale * 0.15), width: scale * 0.3, height: scale * 0.4, rotation: .pi * 0.1)
    drawScale(at: CGPoint(x: sx + scale * 0.15, y: sy - scale * 0.15), width: scale * 0.3, height: scale * 0.4, rotation: -.pi * 0.1)
    
    // Row 2
    drawScale(at: CGPoint(x: sx - scale * 0.22, y: sy + scale * 0.05), width: scale * 0.35, height: scale * 0.45, rotation: .pi * 0.15)
    drawScale(at: CGPoint(x: sx + scale * 0.22, y: sy + scale * 0.05), width: scale * 0.35, height: scale * 0.45, rotation: -.pi * 0.15)
    drawScale(at: CGPoint(x: sx, y: sy + scale * 0.02), width: scale * 0.35, height: scale * 0.45, rotation: 0)

    // Row 1 (Top)
    drawScale(at: CGPoint(x: sx - scale * 0.12, y: sy + scale * 0.25), width: scale * 0.3, height: scale * 0.4, rotation: .pi * 0.05)
    drawScale(at: CGPoint(x: sx + scale * 0.12, y: sy + scale * 0.25), width: scale * 0.3, height: scale * 0.4, rotation: -.pi * 0.05)

    // ═══════════════════════════════════════════════
    // 3. REFRESH SYMBOL — Integrated at the stem
    // ═══════════════════════════════════════════════
    let ringRadius = scale * 0.12
    let ringThickness = p * 0.022
    let ringCenter = CGPoint(x: sx, y: sy + scale * 0.42)
    
    g.setLineWidth(ringThickness)
    g.setLineCap(.round)
    
    // Draw 3/4 circle
    let startAngle = -CGFloat.pi * 0.2
    let endAngle = CGFloat.pi * 1.5
    let ringPath = CGMutablePath()
    ringPath.addArc(center: ringCenter, radius: ringRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
    g.addPath(ringPath)
    g.strokePath()
    
    // Arrowhead
    let arrowSize = p * 0.035
    let arrowAngle = endAngle
    let arrowPos = CGPoint(x: ringCenter.x + ringRadius * cos(arrowAngle), y: ringCenter.y + ringRadius * sin(arrowAngle))
    
    g.saveGState()
    g.translateBy(x: arrowPos.x, y: arrowPos.y)
    g.rotate(by: arrowAngle)
    
    let arrowPath = CGMutablePath()
    arrowPath.move(to: CGPoint(x: 0, y: 0))
    arrowPath.addLine(to: CGPoint(x: -arrowSize, y: arrowSize * 0.6))
    arrowPath.addLine(to: CGPoint(x: -arrowSize, y: -arrowSize * 0.6))
    arrowPath.closeSubpath()
    
    g.addPath(arrowPath)
    g.fillPath()
    g.restoreGState()
    
    // Stem connector (subtle)
    g.setLineWidth(ringThickness * 0.8)
    g.move(to: CGPoint(x: sx, y: sy + scale * 0.38))
    g.addLine(to: CGPoint(x: sx, y: sy + scale * 0.3))
    g.strokePath()

    NSGraphicsContext.current = nil
    return rep.representation(using: .png, properties: [:])
}

let outputDir = "AutoBrew/Assets.xcassets/AppIcon.appiconset"
let sizes: [(Int, String)] = [
    (16, "icon_16x16.png"), (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"), (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"), (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"), (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"), (1024, "icon_512x512@2x.png"),
    (1024, "icon_source_1024.png"),
]

for (px, name) in sizes {
    guard let png = generateIcon(pixels: px) else { print("FAIL: \(name)"); continue }
    let url = URL(fileURLWithPath: "\(outputDir)/\(name)")
    try! png.write(to: url)
    print("\(name) (\(px)px)")
}

print("\nSuccessfully updated all icons in \(outputDir)")
