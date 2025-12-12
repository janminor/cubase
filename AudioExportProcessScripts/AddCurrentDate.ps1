Param(
	[Parameter(Position=0)]
	[string]
	$inputfile
)

## CONFIGURATION
#
# this determines the default date format. See https://learn.microsoft.com/en-gb/dotnet/standard/base-types/custom-date-and-time-format-strings
# e.g.
#   yyyy = year with 4 digits 
# 	MM = month of year, two digits, zero-padded
# 	dd = day of month, two digits, zero-padded
# 	HH = Hour of day
# 	mm = minute of hour
$dateformat = "yyyy-MM-dd"
# The date will be inserted at the beginning of the file name and will be separtated from the original name by this string
$separator = " "

# You can also put a date format string in the file name field in the audio export dialog,
# but then it must be enclosed in '%' characters, e.g. 
#   "%yyyy-MM-dd_HHmm% mixdown"
# which will result in a name like
#  "2025-12-24_1430 mixdown.wav"
# But be careful if the format string is incorrect, the script will just fail


# this script will write log output to the following file
$logFile = "C:\temp\CubasePostExport.log"

# END CONFIGURATION


# Do NOT edit below here unless you know what you are doing

try {
	New-Item -force $logFile
    Add-Content $logFile "Starting 'AddCurrentDate' at $(get-date)"
	
	[XML]$xml = get-content $inputfile;
	$date = get-date -Format $dateformat

	foreach ( $path in $xml.AudioExportDescription.Track.Path ) {
		$dir=split-path $path
		$filename = split-path $path -leaf
		
		$matches = $null
		$found = $filename -match "%([^%]+)%"
		if ($found) {
			$date = get-date -Format $matches[1]
			$newfilename = $filename -replace "%([^%]+)%", $date
		}
		else {
			$date = get-date -Format $dateformat
			$newfilename = $date + $separator + $filename
		}
		$target = join-path $dir $newfilename
		Add-Content $logFile "rename '$path' to '$target'"
		Move-item -Force $path $target
	}
}
catch {
    Add-Content $logFile "Error: $_"
}

