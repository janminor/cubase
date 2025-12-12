# Cubase Audio Export Post Process Scripts

These are Scripts that can trigger custom actions on audio files that are exported via the "Export Audio Mixdown" Dialog.

AddCurrentDate - renames the exported audio files so that the current date is inserted at the start of the file name. 

MP3toDropbox - converts the files to mp3 format (ffmpeg needs to be installed) and puts them in your Dropbox folder

Use at your own risk.

## Instructions Windows

These use powershell scripts (.ps1) for the processing. If you are not allowed to run powershell on your system, this will fail. If you have RansomWare protection enabled in Windows, this will also fail.

1. Download the the .aepp and .ps1 file of the same name (e.g. [AddCurrentDate.aepp](AddCurrentDate.aepp) and 
[AddCurrentDate.ps1](AddCurrentDate.ps1) and copy them to "C:\ProgramData\Steinberg\Audio Export Post Process Scripts" 
1. Check the ps1-Scripts for possible configuration at the top of the file.
1. Restart Cubase. The Script should appear in the "After Export" Menu

The "AddCurrentDate.ps" will write a logfile to "C:\temp\CubasePostExport.log". Check this for possible errors.


## Instructions MacOS

Only the AddCurrentDate script os available for MacOS.

1. Download  [AddCurrentDateMacOS.aepp](AddCurrentDateMacOS.aepp) and copy it to `/Library/Application Support/Steinberg/Audio Export Post Process Scripts/`
1. Download  [AddCurrentDate.sh](AddCurrentDate.sh) and copy it to`/Library/Application Support/Steinberg/Audio Export Post Process Scripts/` 
1. Open a Terminal and type `chmod +x "/Library/Application Support/Steinberg/Audio Export Post Process Scripts/AddCurrentDate.sh"` (you might need to type `sudo chmod +x ...` if you get permission error)
1. check the  AddCurrentDate.sh script for configuration options at the top of the file
1. Restart Cubase. The Script should appear in the "After Export" Menu

The bash script will write a log file to "~/Library/Logs/CubasePostExport.log". Check this for possible errors.
