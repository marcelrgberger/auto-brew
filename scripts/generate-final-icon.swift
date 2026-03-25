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

    // --- Background (Superellipse approximation) ---
    // macOS squircle radius for 1024 is approx 225
    let corner: CGFloat = p * 0.22
    let bgPath = CGPath(roundedRect: CGRect(x: 0, y: 0, width: p, height: p), cornerWidth: corner, cornerHeight: corner, transform: nil)

    g.saveGState()
    g.addPath(bgPath)
    g.clip()
    
    // Warm brown-to-amber diagonal gradient
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.95, 0.65, 0.15), // Amber
        color(0.40, 0.20, 0.05), // Deep Brown
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: p), end: CGPoint(x: p, y: 0), options: [])
    g.restoreGState()

    // --- Inner Shadow/Glow for depth ---
    g.saveGState()
    g.addPath(bgPath)
    g.clip()
    let innerShadowGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1, 1, 1, 0.15),
        color(1, 1, 1, 0.0),
    ] as CFArray, locations: [0.0, 0.4])!
    g.drawRadialGradient(innerShadowGrad, startCenter: CGPoint(x: p * 0.4, y: p * 0.7), startRadius: 0, endCenter: CGPoint(x: p * 0.5, y: p * 0.5), endRadius: p * 0.7, options: [])
    g.restoreGState()

    // --- Centered Mug Assembly ---
    let mugW = p * 0.38
    let handleR = p * 0.09
    let assemblyW = mugW + handleR
    let startX = (p - assemblyW) / 2
    
    let mugL = startX, mugB = p * 0.22, mugH = p * 0.45
    let mugR = p * 0.06
    let mugRect = CGRect(x: mugL, y: mugB, width: mugW, height: mugH)
    let mugPath = CGPath(roundedRect: mugRect, cornerWidth: mugR, cornerHeight: mugR, transform: nil)

    // Mug Body
    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: -p * 0.02), blur: p * 0.04, color: color(0, 0, 0, 0.3))
    g.addPath(mugPath)
    g.clip()
    let mugGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1, 1, 1, 1.0),
        color(0.94, 0.94, 0.94, 1.0),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(mugGrad, start: CGPoint(x: 0, y: mugB + mugH), end: CGPoint(x: 0, y: mugB), options: [])
    g.restoreGState()

    // Handle
    let hx = mugL + mugW, hy = mugB + mugH * 0.5
    g.setStrokeColor(color(1, 1, 1, 1.0))
    g.setLineWidth(p * 0.045)
    g.setLineCap(.round)
    let handle = CGMutablePath()
    handle.addArc(center: CGPoint(x: hx, y: hy), radius: handleR, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true)
    g.addPath(handle)
    g.strokePath()

    // --- Steam Wisps ---
    g.setStrokeColor(color(1, 1, 1, 0.5))
    g.setLineWidth(p * 0.018)
    g.setLineCap(.round)
    let sBase = mugB + mugH + p * 0.04, sH = p * 0.12
    for i in 0..<3 {
        let xOffset = mugW * (0.25 + CGFloat(i) * 0.25)
        let x = mugL + xOffset
        let w = p * 0.02 * (i % 2 == 0 ? 1.0 : -1.0)
        let s = CGMutablePath()
        s.move(to: CGPoint(x: x, y: sBase))
        s.addCurve(to: CGPoint(x: x + w * 0.5, y: sBase + sH),
                   control1: CGPoint(x: x + w, y: sBase + sH * 0.35),
                   control2: CGPoint(x: x - w, y: sBase + sH * 0.65))
        g.addPath(s)
        g.strokePath()
    }

    // --- Green Badge (Bottom Right) ---
    let bSz = p * 0.28, bX = p * 0.64, bY = p * 0.08
    let bC = CGPoint(x: bX + bSz / 2, y: bY + bSz / 2)

    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: p * 0.01), blur: p * 0.03, color: color(0, 0, 0, 0.4))
    g.setFillColor(color(0.2, 0.75, 0.35)) // Green base
    g.fillEllipse(in: CGRect(x: bX, y: bY, width: bSz, height: bSz))
    g.restoreGState()

    // Badge Gradient
    g.saveGState()
    g.addEllipse(in: CGRect(x: bX, y: bY, width: bSz, height: bSz))
    g.clip()
    let bGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.35, 0.85, 0.45),
        color(0.15, 0.60, 0.25),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(bGrad, start: CGPoint(x: bX, y: bY + bSz), end: CGPoint(x: bX, y: bY), options: [])
    g.restoreGState()

    // Sync Arrows in Badge
    let aR = bSz * 0.28, aLW = p * 0.024
    g.setStrokeColor(color(1, 1, 1, 1.0))
    g.setLineWidth(aLW)
    g.setLineCap(.round)

    for startAngle: CGFloat in [0.25, 1.25] {
        let arc = CGMutablePath()
        arc.addArc(center: bC, radius: aR, startAngle: .pi * startAngle, endAngle: .pi * (startAngle + 0.5), clockwise: false)
        g.addPath(arc)
        g.strokePath()
        
        // Arrow tip
        let tipAngle = .pi * (startAngle + 0.5)
        let tipPt = CGPoint(x: bC.x + aR * cos(tipAngle), y: bC.y + aR * sin(tipAngle))
        let tipDir = tipAngle + .pi / 2
        let tL = p * 0.035
        let tip = CGMutablePath()
        tip.move(to: tipPt)
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir + 2.4), y: tipPt.y + tL * sin(tipDir + 2.4)))
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir - 2.4), y: tipPt.y + tL * sin(tipDir - 2.4)))
        tip.closeSubpath()
        g.setFillColor(color(1, 1, 1, 1.0))
        g.addPath(tip)
        g.fillPath()
    }

    NSGraphicsContext.current = nil
    let png = rep.representation(using: .png, properties: [:])!
    try! png.write(to: URL(fileURLWithPath: output))
}

generateIcon()
print("Success: \(output)")
