Param(
	[Parameter(Position=0)]
	[string]
	$inputfile
)

[XML]$xml = get-content $inputfile;

foreach ( $path in $xml.AudioExportDescription.Track.Path ) {
	$title = (split-path $path -leaf) -replace '.\w+$', ''
	$year = (get-date).year
	# you need to change this path to wherever your ffmpeg is installed
	&C:\path\to\ffmpeg.exe -y -i $path  -b:a 256k  -id3v2_version 3 -write_id3v1 1 -metadata artist="username" -metadata title="$title" -metadata date=$year "${env:USERPROFILE}\Dropbox\$title.mp3"
}

