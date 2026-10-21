# HTML / File to APK (GitHub auto-build)

Mee HTML (leda zip / image / video / audio / text) ni push chesthe, GitHub APK build chesi istundi.

## Steps
1. GitHub lo kotha repo create cheyyandi, ee folder anta (hidden `.github` tho saha) push cheyyandi.
2. Mee files ni **`www/`** folder lo pettandi.
   - Entry file peru **`index.html`** undali (CSS/JS/images anni same folder lo).
   - Zip pettina, auto-extract avutundi. Single image/video/audio/txt pettina viewer page auto create avutundi.
3. **`app.config`** lo APP_NAME, PACKAGE_ID, VERSION marchandi.
   - Website ni APK cheyyali ante `START_URL=https://...` pettandi.
4. (Optional) icon kosam root lo `icon.png` (192x192 leda 512x512) pettandi.
5. Push cheyyandi. GitHub -> **Actions** tab -> **Build APK** run -> kinda **Artifacts -> apk** download.
   Zip extract chesi `.apk` install cheyyandi.

## Notes
- APK debug-signed. Install ki "Install unknown apps" allow cheyyali. Play Store ki kaadu.
- Debug key prathi build ki maarachu, kabatti kotha APK install cheyyadaniki mundu old version ni uninstall cheyyali.
- PDF direct ga support ledu. App name lo `&` ledha quotes vaddu.
- Build fail ayithe Actions lo red run open chesi, error line copy chesi naaku pampandi.
