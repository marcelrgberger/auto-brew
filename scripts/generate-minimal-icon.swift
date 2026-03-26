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

    // 1. Background: Solid rich dark green gradient filling the ENTIRE 1024x1024 square
    let bgRect = CGRect(x: 0, y: 0, width: p, height: p)
    g.saveGState()
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.02, 0.12, 0.04), // Darker green
        color(0.08, 0.22, 0.10), // Slightly lighter dark green
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: p), end: CGPoint(x: p, y: 0), options: [])
    g.restoreGState()

    // 2. Center: Simple white silhouette of a beer bottle
    let bottleW: CGFloat = p * 0.28
    let bottleH: CGFloat = p * 0.70
    let bottleX = (p - bottleW) / 2
    let bottleY = (p - bottleH) / 2 + p * 0.02 // Slightly pushed down for visual balance
    
    let bottlePath = CGMutablePath()
    
    // Bottle neck
    let neckW = bottleW * 0.35
    let neckH = bottleH * 0.35
    let shoulderH = bottleH * 0.15
    let bodyH = bottleH - neckH - shoulderH
    
    // Neck
    bottlePath.move(to: CGPoint(x: p/2 - neckW/2, y: bottleY + bottleH))
    bottlePath.addLine(to: CGPoint(x: p/2 + neckW/2, y: bottleY + bottleH))
    // Lip
    let lipH = bottleH * 0.03
    bottlePath.addLine(to: CGPoint(x: p/2 + neckW/2 + p*0.01, y: bottleY + bottleH - lipH))
    bottlePath.addLine(to: CGPoint(x: p/2 - neckW/2 - p*0.01, y: bottleY + bottleH - lipH))
    bottlePath.move(to: CGPoint(x: p/2 + neckW/2, y: bottleY + bottleH - lipH))
    
    // Neck down to shoulder
    bottlePath.addLine(to: CGPoint(x: p/2 + neckW/2, y: bottleY + bodyH + shoulderH))
    
    // Shoulder curve
    bottlePath.addCurve(to: CGPoint(x: bottleX + bottleW, y: bottleY + bodyH),
                        control1: CGPoint(x: p/2 + neckW/2, y: bottleY + bodyH + shoulderH * 0.5),
                        control2: CGPoint(x: bottleX + bottleW, y: bottleY + bodyH + shoulderH * 0.5))
    
    // Body
    bottlePath.addLine(to: CGPoint(x: bottleX + bottleW, y: bottleY + p * 0.05)) // Base rounding
    bottlePath.addArc(center: CGPoint(x: bottleX + bottleW - p*0.05, y: bottleY + p*0.05), radius: p*0.05, startAngle: 0, endAngle: -.pi/2, clockwise: true)
    
    bottlePath.addLine(to: CGPoint(x: bottleX + p*0.05, y: bottleY))
    bottlePath.addArc(center: CGPoint(x: bottleX + p*0.05, y: bottleY + p*0.05), radius: p*0.05, startAngle: -.pi/2, endAngle: .pi, clockwise: true)
    
    bottlePath.addLine(to: CGPoint(x: bottleX, y: bottleY + bodyH))
    
    // Back to shoulder
    bottlePath.addCurve(to: CGPoint(x: p/2 - neckW/2, y: bottleY + bodyH + shoulderH),
                        control1: CGPoint(x: bottleX, y: bottleY + bodyH + shoulderH * 0.5),
                        control2: CGPoint(x: p/2 - neckW/2, y: bottleY + bodyH + shoulderH * 0.5))
    
    bottlePath.addLine(to: CGPoint(x: p/2 - neckW/2, y: bottleY + bottleH))
    bottlePath.closeSubpath()

    g.saveGState()
    g.addPath(bottlePath)
    g.setFillColor(color(1, 1, 1, 1.0))
    g.setShadow(offset: CGSize(width: 0, height: -p * 0.01), blur: p * 0.03, color: color(0, 0, 0, 0.3))
    g.fillPath()
    g.restoreGState()

    // 3. Green Refresh Arrow Overlay near the bottom
    let badgeR = p * 0.10
    let badgeX = p/2 + bottleW * 0.3
    let badgeY = bottleY + bottleH * 0.15
    let badgeCenter = CGPoint(x: badgeX, y: badgeY)
    
    // Badge Background (Green circle)
    g.saveGState()
    g.setFillColor(color(0.2, 0.7, 0.2)) // Vibrant Green
    g.setShadow(offset: .zero, blur: p * 0.02, color: color(0, 0, 0, 0.4))
    g.fillEllipse(in: CGRect(x: badgeX - badgeR, y: badgeY - badgeR, width: badgeR * 2, height: badgeR * 2))
    g.restoreGState()
    
    // White Refresh Arrow inside the green badge
    let arrowR = badgeR * 0.6
    g.saveGState()
    g.setStrokeColor(color(1, 1, 1, 1.0))
    g.setLineWidth(p * 0.015)
    g.setLineCap(.round)
    
    // Draw two arc segments for the refresh symbol
    for startAngle: CGFloat in [0.1, 1.1] {
        let arc = CGMutablePath()
        arc.addArc(center: badgeCenter, radius: arrowR, startAngle: .pi * startAngle, endAngle: .pi * (startAngle + 0.65), clockwise: false)
        g.addPath(arc)
        g.strokePath()
        
        // Arrow tip
        let tipAngle = .pi * (startAngle + 0.65)
        let tipPt = CGPoint(x: badgeCenter.x + arrowR * cos(tipAngle), y: badgeCenter.y + arrowR * sin(tipAngle))
        let tipDir = tipAngle + .pi / 2
        let tL = p * 0.025
        let tip = CGMutablePath()
        tip.move(to: tipPt)
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir + 2.3), y: tipPt.y + tL * sin(tipDir + 2.3)))
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir - 2.3), y: tipPt.y + tL * sin(tipDir - 2.3)))
        tip.closeSubpath()
        g.setFillColor(color(1, 1, 1, 1.0))
        g.addPath(tip)
        g.fillPath()
    }
    g.restoreGState()

    NSGraphicsContext.current = nil
    let png = rep.representation(using: .png, properties: [:])!
    try! png.write(to: URL(fileURLWithPath: output))
}

generateIcon()
print("Success: \(output)")
