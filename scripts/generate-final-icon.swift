#!/usr/bin/env swift

import AppKit

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}

func generateIcon(pixels: Int) -> Data? {
    let p = CGFloat(pixels)

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    )!

    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    let g = ctx.cgContext

    // ═══════════════════════════════════════════════
    // 1. BACKGROUND — Rich deep gradient
    // ═══════════════════════════════════════════════
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.08, 0.22, 0.15),
        color(0.04, 0.12, 0.08),
        color(0.02, 0.06, 0.04),
    ] as CFArray, locations: [0.0, 0.6, 1.0])!
    g.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: p), end: CGPoint(x: p, y: 0), options: [])

    // Subtle radial highlight
    let highlightGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.15, 0.35, 0.22, 0.4),
        color(0.05, 0.15, 0.08, 0.0),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawRadialGradient(highlightGrad,
        startCenter: CGPoint(x: p * 0.45, y: p * 0.55), startRadius: 0,
        endCenter: CGPoint(x: p * 0.45, y: p * 0.55), endRadius: p * 0.45, options: [])

    // ═══════════════════════════════════════════════
    // 2. BEER BOTTLE — Elegant green glass
    // ═══════════════════════════════════════════════
    let bottle = CGMutablePath()

    let cx = p * 0.44
    let bodyW = p * 0.28
    let neckW = p * 0.10
    let capW = p * 0.12

    let botY = p * 0.14
    let shoulderY = p * 0.56
    let neckStartY = p * 0.68
    let neckTopY = p * 0.82
    let capTopY = p * 0.87

    let bL = cx - bodyW/2, bR = cx + bodyW/2
    let nL = cx - neckW/2, nR = cx + neckW/2
    let cL = cx - capW/2, cR = cx + capW/2

    bottle.move(to: CGPoint(x: bL + p*0.02, y: botY))
    bottle.addArc(tangent1End: CGPoint(x: bL, y: botY), tangent2End: CGPoint(x: bL, y: botY + p*0.02), radius: p*0.02)
    bottle.addLine(to: CGPoint(x: bL, y: shoulderY))
    bottle.addCurve(to: CGPoint(x: nL, y: neckStartY),
        control1: CGPoint(x: bL, y: shoulderY + p*0.08),
        control2: CGPoint(x: nL, y: neckStartY - p*0.04))
    bottle.addLine(to: CGPoint(x: nL, y: neckTopY))
    bottle.addCurve(to: CGPoint(x: cL, y: neckTopY + p*0.01),
        control1: CGPoint(x: nL - p*0.005, y: neckTopY + p*0.005),
        control2: CGPoint(x: cL, y: neckTopY + p*0.005))
    bottle.addLine(to: CGPoint(x: cL, y: capTopY))
    bottle.addArc(tangent1End: CGPoint(x: cL, y: capTopY + p*0.008), tangent2End: CGPoint(x: cx, y: capTopY + p*0.008), radius: p*0.008)
    bottle.addArc(tangent1End: CGPoint(x: cR, y: capTopY + p*0.008), tangent2End: CGPoint(x: cR, y: capTopY), radius: p*0.008)
    bottle.addLine(to: CGPoint(x: cR, y: neckTopY + p*0.01))
    bottle.addCurve(to: CGPoint(x: nR, y: neckTopY),
        control1: CGPoint(x: cR, y: neckTopY + p*0.005),
        control2: CGPoint(x: nR + p*0.005, y: neckTopY + p*0.005))
    bottle.addLine(to: CGPoint(x: nR, y: neckStartY))
    bottle.addCurve(to: CGPoint(x: bR, y: shoulderY),
        control1: CGPoint(x: nR, y: neckStartY - p*0.04),
        control2: CGPoint(x: bR, y: shoulderY + p*0.08))
    bottle.addLine(to: CGPoint(x: bR, y: botY + p*0.02))
    bottle.addArc(tangent1End: CGPoint(x: bR, y: botY), tangent2End: CGPoint(x: bR - p*0.02, y: botY), radius: p*0.02)
    bottle.closeSubpath()

    // ═══════════════════════════════════════════════
    // 3. BOTTLE RENDERING
    // ═══════════════════════════════════════════════

    // Shadow
    g.saveGState()
    g.setShadow(offset: CGSize(width: p*0.01, height: -p*0.02), blur: p*0.06, color: color(0, 0, 0, 0.5))
    g.setFillColor(color(0, 0, 0, 0.01))
    g.addPath(bottle)
    g.fillPath()
    g.restoreGState()

    // Glass gradient
    g.saveGState()
    g.addPath(bottle)
    g.clip()
    let bottleGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.30, 0.55, 0.25, 0.95),
        color(0.20, 0.42, 0.18, 0.92),
        color(0.12, 0.30, 0.10, 0.90),
        color(0.08, 0.20, 0.06, 0.88),
    ] as CFArray, locations: [0.0, 0.35, 0.7, 1.0])!
    g.drawLinearGradient(bottleGrad, start: CGPoint(x: bL, y: p*0.5), end: CGPoint(x: bR + p*0.05, y: p*0.5), options: [])

    // Beer visible through glass
    let beerTop = shoulderY - p*0.02
    g.saveGState()
    g.clip(to: CGRect(x: bL, y: botY, width: bodyW, height: beerTop - botY))
    let beerGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.85, 0.60, 0.15, 0.7),
        color(0.75, 0.45, 0.10, 0.6),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(beerGrad, start: CGPoint(x: cx, y: beerTop), end: CGPoint(x: cx, y: botY), options: [])
    g.restoreGState()

    // Left edge specular highlight
    g.setFillColor(color(1, 1, 1, 0.25))
    g.fill(CGRect(x: bL + p*0.015, y: botY + p*0.03, width: p*0.025, height: shoulderY - botY - p*0.06))

    // Neck highlight
    g.setFillColor(color(1, 1, 1, 0.2))
    g.fill(CGRect(x: nL + p*0.01, y: neckStartY, width: p*0.015, height: neckTopY - neckStartY))

    g.restoreGState()

    // Subtle outline
    g.setStrokeColor(color(1, 1, 1, 0.08))
    g.setLineWidth(p * 0.003)
    g.addPath(bottle)
    g.strokePath()

    // ═══════════════════════════════════════════════
    // 4. LABEL — Cream with hop leaf
    // ═══════════════════════════════════════════════
    let labelH = p * 0.14
    let labelY = botY + p * 0.10
    let labelRect = CGRect(x: bL + p*0.025, y: labelY, width: bodyW - p*0.05, height: labelH)
    let labelPath = CGPath(roundedRect: labelRect, cornerWidth: p*0.01, cornerHeight: p*0.01, transform: nil)

    g.saveGState()
    g.addPath(labelPath)
    g.clip()
    let labelGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.95, 0.92, 0.85, 0.9),
        color(0.88, 0.84, 0.76, 0.85),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(labelGrad, start: CGPoint(x: cx, y: labelY + labelH), end: CGPoint(x: cx, y: labelY), options: [])
    g.restoreGState()

    // Hop leaf
    let leafCy = labelY + labelH * 0.5
    let leafW = p * 0.045, leafH = p * 0.06
    let leaf = CGMutablePath()
    leaf.move(to: CGPoint(x: cx, y: leafCy + leafH/2))
    leaf.addCurve(to: CGPoint(x: cx, y: leafCy - leafH/2),
        control1: CGPoint(x: cx + leafW, y: leafCy + leafH*0.2),
        control2: CGPoint(x: cx + leafW, y: leafCy - leafH*0.2))
    leaf.addCurve(to: CGPoint(x: cx, y: leafCy + leafH/2),
        control1: CGPoint(x: cx - leafW, y: leafCy - leafH*0.2),
        control2: CGPoint(x: cx - leafW, y: leafCy + leafH*0.2))
    leaf.closeSubpath()
    g.setFillColor(color(0.15, 0.45, 0.20, 0.7))
    g.addPath(leaf)
    g.fillPath()
    g.setStrokeColor(color(0.15, 0.45, 0.20, 0.5))
    g.setLineWidth(p * 0.003)
    g.move(to: CGPoint(x: cx, y: leafCy - leafH*0.35))
    g.addLine(to: CGPoint(x: cx, y: leafCy + leafH*0.35))
    g.strokePath()

    // ═══════════════════════════════════════════════
    // 5. REFRESH BADGE
    // ═══════════════════════════════════════════════
    let bSz = p * 0.22, bBx = p * 0.65, bBy = p * 0.10
    let bCenter = CGPoint(x: bBx + bSz/2, y: bBy + bSz/2)
    let bBRect = CGRect(x: bBx, y: bBy, width: bSz, height: bSz)

    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: -p*0.008), blur: p*0.025, color: color(0, 0, 0, 0.4))
    g.setFillColor(color(0.2, 0.7, 0.35))
    g.fillEllipse(in: bBRect)
    g.restoreGState()

    g.saveGState()
    g.addEllipse(in: bBRect)
    g.clip()
    let badgeGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.35, 0.88, 0.50),
        color(0.18, 0.62, 0.30),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(badgeGrad, start: CGPoint(x: bBx, y: bBy + bSz), end: CGPoint(x: bBx + bSz, y: bBy), options: [])
    let glossGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1, 1, 1, 0.35), color(1, 1, 1, 0.0),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(glossGrad,
        start: CGPoint(x: bBx + bSz/2, y: bBy + bSz*0.92),
        end: CGPoint(x: bBx + bSz/2, y: bBy + bSz*0.5), options: [])
    g.restoreGState()

    // Arrows
    let aR = bSz * 0.30
    g.setStrokeColor(color(1, 1, 1, 0.95))
    g.setLineWidth(p * 0.018)
    g.setLineCap(.round)
    for sa: CGFloat in [0.2, 1.2] {
        let arc = CGMutablePath()
        arc.addArc(center: bCenter, radius: aR, startAngle: .pi * sa, endAngle: .pi * (sa + 0.6), clockwise: false)
        g.addPath(arc)
        g.strokePath()
        let ta = CGFloat.pi * (sa + 0.6)
        let tp = CGPoint(x: bCenter.x + aR * cos(ta), y: bCenter.y + aR * sin(ta))
        let td = ta + .pi / 2, tl = p * 0.028
        let tip = CGMutablePath()
        tip.move(to: tp)
        tip.addLine(to: CGPoint(x: tp.x + tl * cos(td + 2.4), y: tp.y + tl * sin(td + 2.4)))
        tip.addLine(to: CGPoint(x: tp.x + tl * cos(td - 2.4), y: tp.y + tl * sin(td - 2.4)))
        tip.closeSubpath()
        g.setFillColor(color(1, 1, 1, 0.95))
        g.addPath(tip)
        g.fillPath()
    }

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
]

for (px, name) in sizes {
    guard let png = generateIcon(pixels: px) else { print("FAIL: \(name)"); continue }
    try! png.write(to: URL(fileURLWithPath: "\(outputDir)/\(name)"))
    print("\(name) (\(px)px)")
}

if let src = generateIcon(pixels: 1024) {
    try! src.write(to: URL(fileURLWithPath: "\(outputDir)/icon_source_1024.png"))
}
print("\nDone!")
