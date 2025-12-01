import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import resourceManager from '@ohos.resourceManager';

@Entry
@Component
struct Index {
  @State currentLang: 'EN' | 'TR' = 'EN';
  @State buttonLabels: string[] = ['Sit', 'Down', 'Stand', 'Come', 'Stay', 'Dog Repellent'];

  private soundFiles: string[] = [
    'Sit.mp3', 'Down.mp3', 'Stand.mp3', 'Come.mp3', 'Stay.mp3', 'Repellent.mp3'
  ];

  private avPlayer?: media.AVPlayer;

  build() {
    Column() {
      // 🌍 Language toggle
      Button(this.currentLang === 'EN' ? '🇬🇧 English' : '🇹🇷 Türkçe')
        .width('80%')
        .height(36)
        .borderRadius(12)
        .backgroundColor(0x317aff)
        .fontColor(Color.White)
        .onClick(() => this.toggleLanguage())

      // 📜 Command list
      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.buttonLabels, (label: string, index: number) => {
            Button(label)
              .width('90%')
              .height(48)
              .borderRadius(18)
              .fontColor(Color.White)
              .backgroundColor(index === 5 ? '#ff4444' : '#222222')
              .onClick(() => this.playCommandSound(index))
          })
        }
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 10, bottom: 10 })
      }
      .height('80%')
      .scrollBar(BarState.Off)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }

  private toggleLanguage() {
    if (this.currentLang === 'EN') {
      this.currentLang = 'TR';
      this.buttonLabels = ['Otur', 'Yat', 'Kalk', 'Gel', 'Bekle', 'Köpek Kaçır'];
    } else {
      this.currentLang = 'EN';
      this.buttonLabels = ['Sit', 'Down', 'Stand', 'Come', 'Stay', 'Dog Repellent'];
    }
  }

  private async playCommandSound(index: number) {
    try {
      if (this.avPlayer) {
        this.avPlayer.release();
        this.avPlayer = undefined;
      }

      this.avPlayer = await media.createAVPlayer();
      this.setAVPlayerCallback(this.avPlayer);

      const fileName = 'quiz_complete.mp3';

      const fd = await context.resourceManager.getRawFd(fileName);
      const avFileDesc: media.AVFileDescriptor = {
        fd: fd.fd,
        offset: fd.offset,
        length: fd.length
      };

      this.avPlayer.fdSrc = avFileDesc;
      this.avPlayer.prepare();
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
        case 'prepared':
          avPlayer.play();
          break;
        case 'completed':
          avPlayer.stop();
          avPlayer.reset();
          break;
        case 'stopped':
          avPlayer.reset();
          break;
        case 'released':
          break;
      }
    });
  }
}