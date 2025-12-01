import { AnimateTo, Curve } from '@kit.ArkUI';

@Entry
@Component
export default struct LandingPage {
  @State logoScale: number = 1.0
  @State glowOpacity: number = 0.5
  @State pulseSize: number = 140

  build() {
    Stack() {

      Circle()
        .width(this.pulseSize)
        .height(this.pulseSize)
        .backgroundColor('#4D9EFFAA')
        .opacity(this.glowOpacity)
        .zIndex(0)

      Column() {
        Image($r('app.media.dog'))
          .width(160)
          .height(160)
          .objectFit(ImageFit.Contain)
          .scale({ x: this.logoScale, y: this.logoScale })
          .shadow({
            radius: 20,
            color: '#6EE7F9',
            offsetX: 0,
            offsetY: 0
          })
          .onAppear(() => {
            this.startLogoAnimation()
          })

        Text('Pet Training App')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .letterSpacing(1.2)
          .margin({ top: 20 })
          .shadow({
            radius: 10,
            color: '#A78BFA',
            offsetX: 0,
            offsetY: 0
          })

        Text('Train your dog with voice and gesture commands')
          .fontSize(16)
          .fontColor('#BBBBBB')
          .fontWeight(FontWeight.Normal)
          .margin({ top: 8, bottom: 20 })
          .textAlign(TextAlign.Center)
          .lineHeight(24)
          .padding({ left: 12, right: 12 })

        Row() {
          ForEach(Array.from(Array(6).keys()), (i: number) => {
            Blank()
              .width(16)
              .height(6)
              .borderRadius(3)
              .backgroundColor('#317AFF')
              .opacity((i + 1) / 6)
              .margin({ left: 2, right: 2 })
          })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .margin({ top: 24 })

        Text('© 2025 PetTrainer Labs')
          .fontSize(12)
          .fontColor('#888888')
          .margin({ top: 60 })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .padding(20)
    }
    .width('100%')
    .height('100%')
  }

  private startLogoAnimation() {
    setInterval(() => {
      AnimateTo({ duration: 1000, curve: Curve.EaseInOut }, () => {
        this.logoScale = this.logoScale === 1.0 ? 1.2 : 1.0
        this.glowOpacity = this.glowOpacity === 0.5 ? 0.9 : 0.5
        this.pulseSize = this.pulseSize === 140 ? 200 : 140
      })
    }, 1000)
  }
}
