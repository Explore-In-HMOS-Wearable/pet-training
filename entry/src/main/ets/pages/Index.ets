import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';

interface CommandItem {
  id: string;
  labelEn: string;
  labelTr: string;
  sound: string;
  isSpecial: boolean;
}

@Entry
@Component
struct Index {
  @State currentLang: 'EN' | 'TR' = 'EN';
  private avPlayer?: media.AVPlayer;

  private commands: CommandItem[] = [
    { id: '1', labelEn: 'Sit', labelTr: 'Otur', sound: 'Sit.mp3', isSpecial: false },
    { id: '2', labelEn: 'Down', labelTr: 'Yat', sound: 'Down.mp3', isSpecial: false },
    { id: '3', labelEn: 'Stand', labelTr: 'Kalk', sound: 'Stand.mp3', isSpecial: false },
    { id: '4', labelEn: 'Come', labelTr: 'Gel', sound: 'Come.mp3', isSpecial: false },
    { id: '5', labelEn: 'Stay', labelTr: 'Bekle', sound: 'Stay.mp3', isSpecial: false },
    { id: '6', labelEn: 'Dog Repellent', labelTr: 'Köpek Kaçır', sound: 'Repellent.mp3', isSpecial: true }
  ];

  build() {
    Column() {
      Button(this.currentLang === 'EN' ? '🇬🇧 English' : '🇹🇷 Türkçe')
        .width('80%')
        .height(36)
        .borderRadius(12)
        .backgroundColor(Color.Black)
        .fontColor(Color.White)
        .margin({ bottom: 10, top: 10 })
        .onClick(() => this.toggleLanguage())

      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.commands, (item: CommandItem) => {
            Button(this.currentLang === 'EN' ? item.labelEn : item.labelTr)
              .width('90%')
              .height(48)
              .borderRadius(18)
              .fontColor(Color.White)
              .backgroundColor(item.isSpecial ? '#ff4444' : '#222222')
              .onClick(() => this.playCommandSound(item.sound))
          }, (item: CommandItem) => item.id)
        }
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 10, bottom: 10 })
        .width('100%')
      }
      .height('80%')
      .scrollBar(BarState.Off)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }

  private toggleLanguage() {
    this.currentLang = this.currentLang === 'EN' ? 'TR' : 'EN';
  }

  private async playCommandSound(fileName: string) {
    try {
      if (this.avPlayer) {
        await this.avPlayer.reset();
      } else {
        this.avPlayer = await media.createAVPlayer();
        this.setAVPlayerCallback(this.avPlayer);
      }

      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const fileDescriptor = await context.resourceManager.getRawFd(fileName);

      this.avPlayer.fdSrc = fileDescriptor;

    } catch (err) {
      console.error('[Audio Error]', JSON.stringify(err));
    }
  }

  private setAVPlayerCallback(avPlayer: media.AVPlayer) {
    avPlayer.on('error', (err) => {
      console.error('[AVPlayer Error]', JSON.stringify(err));
      avPlayer.reset();
    });

    avPlayer.on('stateChange', (state: string) => {
      console.info('[AVPlayer State]', state);
      switch (state) {
        case 'initialized':
          avPlayer.prepare();
          break;
        case 'prepared':
          avPlayer.play();
          break;
        case 'completed':
          avPlayer.stop();
          break;
        case 'stopped':
          avPlayer.reset();
          break;
        case 'released':
          this.avPlayer = undefined;
          break;
      }
    });
  }
}