#!/usr/bin/env bash
# يُنشئ مجلد المنصات (android/ios) ثم يدمج ملفات المشروع. يتطلب Flutter مثبتًا.
set -e
flutter create --org com.tawasal --project-name tawasal_maee --platforms android,ios app
cp pubspec.yaml app/pubspec.yaml
rm -rf app/lib && cp -r lib app/lib
rm -rf app/test
python3 - <<'PY'
p='app/android/app/src/main/AndroidManifest.xml'
s=open(p,encoding='utf-8').read()
q='<intent><action android:name="android.intent.action.TTS_SERVICE"/></intent>'
if '<queries>' in s:
    s=s.replace('<queries>','<queries>\n        '+q,1)
else:
    s=s.replace('<application','<queries>'+q+'</queries>\n    <application',1)
import re
s=re.sub(r'android:label="[^"]*"','android:label="تواصل معي"',s,1)
open(p,'w',encoding='utf-8').write(s)
PY
cd app && flutter pub get
echo "جاهز: cd app && flutter run"
