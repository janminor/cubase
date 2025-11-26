Param(
	[Parameter(Position=0)]
	[string]
	$inputfile
)

[XML]$xml = get-content $inputfile;

foreach ( $path in $xml.AudioExportDescription.Track.Path ) {
	$title = (split-path $path -leaf) -replace '.\w+$', ''
	$year = (get-date).year
	# you need to change the path to wherever your ffmpeg is installed. The default path below assumes you installed ffmpeg via chocolatey.
	# also you might want to customize the output path in your Dropbox folder and the metadata tags
	&C:\ProgramData\chocolatey\bin\ffmpeg.exe -y -i $path  -b:a 256k  -id3v2_version 3 -write_id3v1 1 -metadata artist="your username" -metadata title="$title" -metadata date=$year "${env:USERPROFILE}\Dropbox\$title.mp3"
}

