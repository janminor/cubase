# Cubase Audio Export Post Process Scripts

AddCurrentDate - renames the exported audio files so that the current date is inserted at the start of the file name. See the script for tweaks and configuration

MP3toDropbox - converts the files to mp3 format (ffmpeg needs to be installed) and puts them in your Dropbox folder

## Instructions Windows

These use powershell scripts (.ps1) for the processing. If you are not allowed to run powershell on your system, this will fail. If you have RansomWare protection enabled in Windows, this will also fail.

Use at your own risk.

1. Copy the .aepp and .ps1 file of the same name to C:\ProgramData\Steinberg\Audio Export Post Process Scripts

2. Check the Powershell script for additional configuration that might be neccessary