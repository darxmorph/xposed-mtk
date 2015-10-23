@echo off
title MTK Xposed Installer by darxmorph
echo Welcome to Xposed Installer
echo.
:yesno
>%temp%\yesno.vbs echo wscript.echo msgbox("Are you sure you want to install Xposed Framework on your device?","68","MTK Xposed Installer by Henry")
for /f "delims=" %%N in ('cscript //nologo %temp%\yesno.vbs') do set yesno=%%N & del %temp%\yesno.vbs
if %yesno%==7 goto exit
if %yesno%==6 goto continue
goto yesno
:continue
>%temp%\info.vbs echo MsgBox "Before continuing, please make sure USB debugging is enabled" ^& vbCrLf ^& vbCrLf ^& _
>>%temp%\info.vbs echo               "To enable Developer Options go to Settings > About phone > Tap 7 times on Build number" ^& vbCrLf ^& vbCrLf ^& _
>>%temp%\info.vbs echo               "Then go to Settings > Developer Options > Enable the switch and check USB debugging" ^& vbCrLf ^& vbCrLf ^& _
>>%temp%\info.vbs echo               "Then, connect your device to the computer" ^& vbCrLf ^& vbCrLf ^& _
>>%temp%\info.vbs echo               "Your phone may ask if you want to allow USB debugging from this computer","64","MTK Xposed Installer by Henry"
call %temp%\info.vbs & del /f /q %temp%\info.vbs
ping 1.1.1.1 -n 1 -w 1000 >nul
echo Waiting device detection...
adb wait-for-device
echo.
echo Device detected!
echo.
adb shell setprop ro.secure 0
:checkuid0
adb shell am start -n com.android.settings/.DevelopmentSettings
>%temp%\info.vbs echo MsgBox "Now disable USB debugging" ^& vbCrLf ^& _
>>%temp%\info.vbs echo               "Wait 2 seconds and turn it back on" ^& vbCrLf ^& vbCrLf ^& _
>>%temp%\info.vbs echo               "Your phone may ask if you want to allow USB debugging from this computer","64","MTK Xposed Installer by Henry"
call %temp%\info.vbs & del /f /q %temp%\info.vbs
echo.
ping 1.1.1.1 -n 1 -w 1000 >nul
echo Waiting device detection...
adb wait-for-device
for /f "tokens=2 delims==(" %%i in ('adb shell id') do set uid=%%i
if %uid%==0 goto main
echo.
goto checkuid0
:main
echo Now is when things get interesting
echo.
echo Remounting /system partition R/W...
adb shell mount -o remount,rw /system
echo.
echo Installing Xposed Installer as system app... (For module management)
adb push de.robv.android.xposed.installer_v32_de4f0d.apk /system/app/XposedInstaller.apk
adb shell chown 0:0 /system/app/XposedInstaller.apk
adb shell chmod 0644 /system/app/XposedInstaller.apk
echo Making app_process backup...
adb shell cp -a /system/bin/app_process /system/bin/app_process.orig
echo Pushing new app_process...
adb shell rm -f /system/bin/app_process
adb push app_process /system/bin/app_process
echo Setting permissions...
adb shell chown 0:2000 /system/bin/app_process
adb shell chmod 0755 /system/bin/app_process
echo.
echo Xposed Installer init...
adb shell am start -n de.robv.android.xposed.installer/.WelcomeActivity
adb shell input keyevent KEYCODE_BACK
ping 1.1.1.1 -n 1 -w 500 >nul
adb shell am force-stop de.robv.android.xposed.installer
echo.
echo Pushing XposedBridge.jar...
adb push XposedBridge.jar /data/data/de.robv.android.xposed.installer/bin/XposedBridge.jar
adb push app_process /data/data/de.robv.android.xposed.installer/bin/app_process
echo Inicializando Xposed...
ping 1.1.1.1 -n 1 -w 1700 >nul
echo.
for /f "tokens=2" %%i in ('adb shell ls -al /data/data/de.robv.android.xposed.installer') do set xposedid=%%i
adb shell chown %xposedid%:%xposedid% /data/data/de.robv.android.xposed.installer/bin/XposedBridge.jar
adb shell chown %xposedid%:%xposedid% /data/data/de.robv.android.xposed.installer/bin/app_process
adb shell chmod 0644 /data/data/de.robv.android.xposed.installer/bin/XposedBridge.jar
adb shell chmod 0700 /data/data/de.robv.android.xposed.installer/bin/app_process
echo.
echo Pushing misc files and setting permissions...
adb push modules.list /data/data/de.robv.android.xposed.installer/conf/modules.list
adb shell chown %xposedid%:%xposedid% /data/data/de.robv.android.xposed.installer/conf/modules.list
adb shell chmod 0664 /data/data/de.robv.android.xposed.installer/conf/modules.list
adb push enabled_modules.xml /data/data/de.robv.android.xposed.installer/shared_prefs/enabled_modules.xml
adb shell chown %xposedid%:%xposedid% /data/data/de.robv.android.xposed.installer/shared_prefs/enabled_modules.xml
adb shell chmod 0600 /data/data/de.robv.android.xposed.installer/shared_prefs/enabled_modules.xml
echo.
echo.
echo Remounting /system partition R/O...
adb shell sync
ping 1.1.1.1 -n 1 -w 3500 >nul
adb shell mount -o remount,ro /system
echo.
adb shell setprop ro.secure 1
:checkuid2000
adb shell am start -n com.android.settings/.DevelopmentSettings
>%temp%\info.vbs echo MsgBox "Now disable USB debugging" ^& vbCrLf ^& _
>>%temp%\info.vbs echo               "Wait 2 seconds and turn it back on" ^& vbCrLf ^& vbCrLf ^& _
>>%temp%\info.vbs echo               "Your phone may ask if you want to allow USB debugging from this computer","64","MTK Xposed Installer by Henry"
call %temp%\info.vbs & del /f /q %temp%\info.vbs
echo.
ping 1.1.1.1 -n 1 -w 1000 >nul
echo Waiting device detection...
adb wait-for-device
for /f "tokens=2 delims==(" %%i in ('adb shell id') do set uid=%%i
if %uid%==2000 goto askgravity
echo.
goto checkuid2000
:askgravity
>%temp%\yesno.vbs echo wscript.echo msgbox("Do you want to install GravityBox module?","68","MTK Xposed Installer by Henry")
for /f "delims=" %%N in ('cscript //nologo %temp%\yesno.vbs') do set yesno=%%N & del %temp%\yesno.vbs
if %yesno%==7 goto reboot
if %yesno%==6 goto installgravitybox
goto askgravity
:installgravitybox
echo.
echo Installing GravityBox...
adb install com.ceco.kitkat.gravitybox_v129_565389.apk
echo.
:reboot
echo Rebooting device in 10 seconds...
ping 1.1.1.1 -n 1 -w 10000 >nul
echo Rebooting...
adb reboot
echo Killing ADB server...
adb kill-server
>%temp%\info.vbs echo MsgBox "Done! Don't forget to disable USB debugging...","64","MTK Xposed Installer by Henry"
call %temp%\info.vbs & del /f /q %temp%\info.vbs
:exit
rem Required for SFX
rem start cmd /c "title MTK Xposed Installer by Henry & echo Deleting temp files... & cd .. & ping 1.1.1.1 -n 1 -w 1000 >nul & rmdir %~dp0 /s /q"
exit