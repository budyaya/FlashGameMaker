#!/bin/bash
#ADT AIR SDK 3.4

#ADL debug
adl "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2\swf\application.xml"

#Packaging SWF to AIR
adt -package -storetype pkcs12 -keystore "certificate.p12" swf/LittleFighterEvo.air swf/application.xml swf/LittleFighterEvo.swf swf/LittleFighterEvo.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\LittleFighterEvo" assets -C "C:\Users\NDOYEA\Adobe Flash Builder 4\LittleFighterEvo" data

#Packaging SWF to APK Emulator
adt -package -target apk-emulator -storetype pkcs12 -keystore "certificate.p12" swf/FlashGameMaker.apk swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data  

#Packaging SWF to APK
adt -package -target apk -storetype pkcs12 -keystore "certificate.p12" swf/FlashGameMaker.apk swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data  

#Packaging AIR to APK
adt -package  -target apk -storetype pkcs12 -keystore "certificate.p12" swf/LittleFighterEvo.apk swf/LittleFighterEvo.air

#Install de l'APK sur l'émulator AVD (Android Virtual Device)
adb install FlashGameMaker.apk

#Packaging SWF to Apple Store
adt -package -target ipa-app-store -storetype pkcs12 -keystore "certificate.p12" -provisioning-profile AppleDistribution.mobileprofile swf/FlashGameMaker.ipa swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data  

#Packaging SWF to Ipa Debug
adt -package -target ipa-debug -storetype pkcs12 -keystore "certificate.p12" -provisioning-profile AppleDevelopment.mobileprofile -connect 192.168.0.12 | -listen swf/FlashGameMaker.ipa swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data  

#Packaging AIR to IPA
adt -package  -target ipa-test -storetype pkcs12 -keystore "certificate.p12" swf/LittleFighterEvo.ipa swf/LittleFighterEvo.air


#Lauch FDB (Flash Debuger)
fdb -p [port]

#Launch ADL
adl "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2\swf\application.xml"

#Compc SWC
compc -source-path="C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\classes" -include-sources="C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\classes\utils,C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\classes\framework" -output="C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\swf\FlashGameMaker.swc" -library-path="C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\lib\as3corelib.swc,C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\lib\fl_controls.swc,C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\lib\flash.swc,C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\lib\greensock_tweenlite.swc,C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\lib\shareelements.swc,C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\lib\theminer_en.swc,C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\lib\textlayout.swc,C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2.1\lib\core.swc" 