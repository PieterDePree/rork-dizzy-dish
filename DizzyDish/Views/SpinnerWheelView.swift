import SwiftUI

struct WheelSegment {
    let color: Color
    let highlight: Color

    static let allSegments: [WheelSegment] = [
        WheelSegment(color: DS.Colors.warm.opacity(0.95), highlight: DS.Colors.warmLight),
        WheelSegment(color: DS.Colors.cream, highlight: DS.Colors.warmLight.opacity(0.85)),
        WheelSegment(color: DS.Colors.green.opacity(0.9), highlight: DS.Colors.greenLight),
        WheelSegment(color: DS.Colors.warmLight.opacity(0.9), highlight: DS.Colors.warm),
        WheelSegment(color: DS.Colors.warm.opacity(0.85), highlight: DS.Colors.warmLight),
        WheelSegment(color: DS.Colors.cream.opacity(0.95), highlight: DS.Colors.warmLight.opacity(0.8)),
        WheelSegment(color: DS.Colors.green.opacity(0.85), highlight: DS.Colors.greenLight),
        WheelSegment(color: DS.Colors.warmLight.opacity(0.85), highlight: DS.Colors.warm),
        WheelSegment(color: DS.Colors.warm.opacity(0.8), highlight: DS.Colors.warmLight),
        WheelSegment(color: DS.Colors.cream.opacity(0.9), highlight: DS.Colors.warmLight.opacity(0.75)),
        WheelSegment(color: DS.Colors.green.opacity(0.8), highlight: DS.Colors.greenLight),
        WheelSegment(color: DS.Colors.warmLight.opacity(0.8), highlight: DS.Colors.warm)
    ]
}

struct SpinnerWheelView: View {
    let rotation: Double
    let isSpinning: Bool
    let onSpin: () -> Void

    private let wheelSize: CGFloat = 280
    private let segments = WheelSegment.allSegments
    private let innerRingSize: CGFloat = 180

    var body: some View {
        ZStack {
            outerRing
            wheelBody
            centerButton
            pointer
        }
        .frame(width: wheelSize + 50, height: wheelSize + 60)
    }

    private var outerRing: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [DS.Colors.cream.opacity(0.3), DS.Colors.cream.opacity(0.08)],
                        center: .center,
                        startRadius: wheelSize * 0.45,
                        endRadius: wheelSize * 0.58
                    )
                )
                .frame(width: wheelSize + 40, height: wheelSize + 40)

            Circle()
                .stroke(DS.Colors.cream.opacity(0.5), lineWidth: 2)
                .frame(width: wheelSize + 16, height: wheelSize + 16)

            ForEach(0..<24, id: \.self) { i in
                let angle = Double(i) * 15.0
                Capsule()
                    .fill(DS.Colors.warmLight.opacity(0.6))
                    .frame(width: 5, height: 12)
                    .offset(y: -(wheelSize / 2 + 8))
                    .rotationEffect(.degrees(angle))
            }
        }
    }

    private var wheelBody: some View {
        ZStack {
            ForEach(0..<segments.count, id: \.self) { index in
                let segmentAngle = 360.0 / Double(segments.count)
                let startAngle = segmentAngle * Double(index) - 90
                let segment = segments[index]

                ZStack {
                    SegmentShape(
                        startAngle: .degrees(startAngle),
                        endAngle: .degrees(startAngle + segmentAngle)
                    )
                    .fill(
                        LinearGradient(
                            colors: [segment.color, segment.highlight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                    SegmentShape(
                        startAngle: .degrees(startAngle),
                        endAngle: .degrees(startAngle + segmentAngle)
                    )
                    .stroke(DS.Colors.background.opacity(0.2), lineWidth: 1)
                }
            }

            Circle()
                .fill(
                    AngularGradient(
                        colors: [
                            DS.Colors.warmLight.opacity(0.55),
                            DS.Colors.warm.opacity(0.35),
                            DS.Colors.green.opacity(0.4),
                            DS.Colors.cream.opacity(0.6)
                        ],
                        center: .center
                    )
                )
                .frame(width: innerRingSize, height: innerRingSize)
                .overlay(
                    Circle()
                        .stroke(DS.Colors.cream.opacity(0.7), lineWidth: 2)
                )

            Circle()
                .stroke(
                    LinearGradient(
                        colors: [DS.Colors.cream, DS.Colors.warmLight.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 4
                )
                .frame(width: wheelSize, height: wheelSize)
        }
        .frame(width: wheelSize, height: wheelSize)
        .clipShape(Circle())
        .rotationEffect(.degrees(rotation))
        .shadow(color: DS.Colors.textPrimary.opacity(0.12), radius: 24, y: 10)
    }

    private var centerButton: some View {
        Button(action: onSpin) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [DS.Colors.warm, DS.Colors.warmLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 88, height: 88)
                    .shadow(color: DS.Colors.warm.opacity(0.45), radius: 14, y: 6)

                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.4), .white.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2.5
                    )
                    .frame(width: 88, height: 88)

                VStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse, isActive: isSpinning)

                    Text("DECIDE")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.95))
                        .tracking(1.6)

                    Text("FOR ME")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                        .tracking(1.4)
                }
            }
        }
        .disabled(isSpinning)
        .scaleEffect(isSpinning ? 0.92 : 1.0)
        .animation(.spring(response: 0.3), value: isSpinning)
    }

    private var pointer: some View {
        VStack(spacing: 0) {
            Triangle()
                .fill(
                    LinearGradient(
                        colors: [DS.Colors.warm, DS.Colors.warm.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 22, height: 18)
                .shadow(color: DS.Colors.warm.opacity(0.4), radius: 4, y: 2)

            Circle()
                .fill(DS.Colors.warm)
                .frame(width: 8, height: 8)
                .offset(y: -2)
        }
        .offset(y: -(wheelSize / 2) - 4)
    }
}

struct SegmentShape: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
