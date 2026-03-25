import AppKit

let p: CGFloat = 1024
let output = "AutoBrew/Assets.xcassets/AppIcon.appiconset/icon_source_1024.png"

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}

func generateIcon() {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(p),
        pixelsHigh: Int(p),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!

    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    let g = ctx.cgContext

    // 1. Background (Full 1024x1024 square, NO gaps, NO black corners)
    g.saveGState()
    // Rich gradient from warm copper/bronze (top-left) to deep dark brown (bottom-right)
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.85, 0.50, 0.25), // Warm Copper/Bronze
        color(0.08, 0.04, 0.02), // Deep Dark Brown
    ] as CFArray, locations: [0.0, 1.0])!
    // Drawing from top-left (0, 1024) to bottom-right (1024, 0)
    g.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: p), end: CGPoint(x: p, y: 0), options: [])
    g.restoreGState()

    // 2. Mug (3D white ceramic coffee mug)
    // 3/4 angle: we shift the mug body slightly left and the handle stays right.
    let mugW = p * 0.44
    let mugH = p * 0.48
    let mugX = (p - mugW) * 0.42 // Shifted slightly left for handle
    let mugY = p * 0.20
    
    // Mug body (cylindrical with rounded bottom)
    let mugBodyPath = CGMutablePath()
    let mugR = p * 0.08
    mugBodyPath.move(to: CGPoint(x: mugX, y: mugY + mugH))
    mugBodyPath.addLine(to: CGPoint(x: mugX + mugW, y: mugY + mugH))
    mugBodyPath.addLine(to: CGPoint(x: mugX + mugW, y: mugY + mugR))
    mugBodyPath.addArc(center: CGPoint(x: mugX + mugW - mugR, y: mugY + mugR), radius: mugR, startAngle: 0, endAngle: -.pi/2, clockwise: true)
    mugBodyPath.addLine(to: CGPoint(x: mugX + mugR, y: mugY))
    mugBodyPath.addArc(center: CGPoint(x: mugX + mugR, y: mugY + mugR), radius: mugR, startAngle: -.pi/2, endAngle: .pi, clockwise: true)
    mugBodyPath.closeSubpath()

    // Mug Soft Shadow beneath
    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: -p * 0.05), blur: p * 0.1, color: color(0, 0, 0, 0.6))
    g.addPath(mugBodyPath)
    g.setFillColor(color(0, 0, 0, 0.3))
    g.fillPath()
    g.restoreGState()

    // Mug Body Fill (Polished ceramic)
    g.saveGState()
    g.addPath(mugBodyPath)
    g.clip()
    // High-quality shading for curvature
    let mugGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1.0, 1.0, 1.0),    // Top-left highlight
        color(0.95, 0.95, 0.95), // Base white
        color(0.80, 0.80, 0.82), // Right-side shadow for depth
    ] as CFArray, locations: [0.0, 0.3, 1.0])!
    g.drawLinearGradient(mugGrad, start: CGPoint(x: mugX, y: mugY + mugH), end: CGPoint(x: mugX + mugW, y: mugY + mugH * 0.2), options: [])
    g.restoreGState()

    // Mug Rim (3D Perspective)
    let rimH = p * 0.10
    let rimRect = CGRect(x: mugX, y: mugY + mugH - rimH/2, width: mugW, height: rimH)
    let rimPath = CGPath(ellipseIn: rimRect, transform: nil)
    g.saveGState()
    g.addPath(rimPath)
    g.setFillColor(color(1, 1, 1, 1.0))
    g.fillPath()
    // Subtle rim shadow for thickness
    g.setLineWidth(p * 0.006)
    g.setStrokeColor(color(0.85, 0.85, 0.85, 0.6))
    g.strokePath()
    g.restoreGState()

    // Inner Mug & Coffee (Visible at top)
    let innerRimRect = rimRect.insetBy(dx: p * 0.025, dy: p * 0.008)
    let innerRimPath = CGPath(ellipseIn: innerRimRect, transform: nil)
    g.saveGState()
    g.addPath(innerRimPath)
    g.clip()
    // Dark Coffee Gradient
    let coffeeGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.12, 0.06, 0.02), // Dark espresso center
        color(0.25, 0.15, 0.08), // Slightly lighter at edges
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawRadialGradient(coffeeGrad, startCenter: CGPoint(x: innerRimRect.midX, y: innerRimRect.midY), startRadius: 0, endCenter: CGPoint(x: innerRimRect.midX, y: innerRimRect.midY), endRadius: innerRimRect.width/2, options: [])
    g.restoreGState()

    // Handle (Right side)
    let hX = mugX + mugW - p * 0.04
    let hY = mugY + mugH * 0.52
    let hW = p * 0.18
    let hH = p * 0.30
    let handleRect = CGRect(x: hX, y: hY - hH/2, width: hW, height: hH)
    let handlePath = CGPath(ellipseIn: handleRect, transform: nil)
    
    g.saveGState()
    // Handle shadow on the background
    g.setShadow(offset: CGSize(width: p * 0.01, height: -p * 0.01), blur: p * 0.04, color: color(0, 0, 0, 0.4))
    g.setLineWidth(p * 0.055)
    g.setLineCap(.round)
    g.setStrokeColor(color(0.96, 0.96, 0.96, 1.0))
    // Clip to keep handle outside the mug body
    g.addPath(handlePath)
    g.clip(to: CGRect(x: mugX + mugW, y: 0, width: p, height: p))
    g.addPath(handlePath)
    g.strokePath()
    g.restoreGState()

    // 3. Steam Wisps (Elegant and thin)
    g.saveGState()
    g.setStrokeColor(color(1, 1, 1, 0.25))
    g.setLineWidth(p * 0.015)
    g.setLineCap(.round)
    g.setShadow(offset: .zero, blur: p * 0.02, color: color(1, 1, 1, 0.4))
    
    let steamBase = mugY + mugH + p * 0.04
    for i in 0..<3 {
        let sx = mugX + mugW * (0.3 + CGFloat(i) * 0.2)
        let sw = p * 0.05
        let sh = p * 0.18
        let sPath = CGMutablePath()
        sPath.move(to: CGPoint(x: sx, y: steamBase))
        sPath.addCurve(to: CGPoint(x: sx + (i % 2 == 0 ? sw : -sw), y: steamBase + sh),
                       control1: CGPoint(x: sx - sw, y: steamBase + sh * 0.3),
                       control2: CGPoint(x: sx + sw, y: steamBase + sh * 0.7))
        g.addPath(sPath)
        g.strokePath()
    }
    g.restoreGState()

    // 4. Green Badge (Bottom-Right, Vibrant Green Glossy)
    let bSz = p * 0.30
    let bX = p * 0.62
    let bY = p * 0.08
    let bRect = CGRect(x: bX, y: bY, width: bSz, height: bSz)
    let bCenter = CGPoint(x: bX + bSz/2, y: bY + bSz/2)

    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: p * 0.015), blur: p * 0.05, color: color(0, 0, 0, 0.5))
    // Vibrant green gradient
    let bGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.30, 0.90, 0.45), // Top light green
        color(0.10, 0.55, 0.25), // Bottom dark green
    ] as CFArray, locations: [0.0, 1.0])!
    g.addEllipse(in: bRect)
    g.clip()
    g.drawLinearGradient(bGrad, start: CGPoint(x: bX, y: bY + bSz), end: CGPoint(x: bX, y: bY), options: [])
    
    // Glass highlight effect
    let bHighlightRect = bRect.insetBy(dx: bSz * 0.1, dy: bSz * 0.1).offsetBy(dx: 0, dy: bSz * 0.25)
    let bHighlightGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1, 1, 1, 0.5),
        color(1, 1, 1, 0.0),
    ] as CFArray, locations: [0.0, 0.8])!
    g.saveGState()
    g.addEllipse(in: bHighlightRect)
    g.clip()
    g.drawLinearGradient(bHighlightGrad, start: CGPoint(x: bHighlightRect.midX, y: bHighlightRect.maxY), end: CGPoint(x: bHighlightRect.midX, y: bHighlightRect.minY), options: [])
    g.restoreGState()
    g.restoreGState()

    // Refresh arrows inside badge (White curved arrows)
    let arrowR = bSz * 0.28
    g.saveGState()
    g.setStrokeColor(color(1, 1, 1, 0.98))
    g.setLineWidth(p * 0.03)
    g.setLineCap(.round)
    
    for startAngle: CGFloat in [0.22, 1.22] {
        let arc = CGMutablePath()
        arc.addArc(center: bCenter, radius: arrowR, startAngle: .pi * startAngle, endAngle: .pi * (startAngle + 0.55), clockwise: false)
        g.addPath(arc)
        g.strokePath()
        
        // Arrow tip
        let tipAngle = .pi * (startAngle + 0.55)
        let tipPt = CGPoint(x: bCenter.x + arrowR * cos(tipAngle), y: bCenter.y + arrowR * sin(tipAngle))
        let tipDir = tipAngle + .pi / 2
        let tL = p * 0.04
        let tip = CGMutablePath()
        tip.move(to: tipPt)
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir + 2.3), y: tipPt.y + tL * sin(tipDir + 2.3)))
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir - 2.3), y: tipPt.y + tL * sin(tipDir - 2.3)))
        tip.closeSubpath()
        g.setFillColor(color(1, 1, 1, 0.98))
        g.addPath(tip)
        g.fillPath()
    }
    g.restoreGState()

    NSGraphicsContext.current = nil
    let png = rep.representation(using: .png, properties: [:])!
    try! png.write(to: URL(fileURLWithPath: output))
}

generateIcon()
