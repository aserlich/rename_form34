
Start-Transcript -path C:\Users\Spark\Desktop\AA\all_pdf_copy\error_log.txt -Append
#starting log to record errors (and other messages)


# ~~step 1- extract polling station names and save them on a textfile~~

foreach ($file in get-ChildItem *.pdf) {
pdftotext.exe $file
}


$txts = Get-childitem $PSScriptRoot | where {$_.Extension -match "txt"}
$pdfs = Get-childitem $PSScriptRoot | where {$_.Extension -match "pdf"}

$i=1

foreach ($txt in $txts)
{
$fullnametxt = $txt | % { $_.FullName }

$txtfile = Get-Content -Path $fullnametxt

$text_one_line = $txtfile -replace "`n|`r"
#making the text extracted from pdf into a single line string

$trim= ([regex]::Match($text_one_line, 'S*T*A*T*I*O*N: (.+) S*T*R*E*A*M:').Groups[1].Value) -replace "[\s # < > $ % ! % * ' { } / \ :]", ''
#extracting the polling station name, remove spaces and illegal symbols

$txtname = $txt.BaseName


"`"$txtname.pdf`",`"$trim`_$i.pdf`"" | Add-Content -Path $PSScriptRoot\list_names.txt 
#sends the original file name and its matching polling station name separated by a comma (to make it a CSV) to a textfile

$i++

}

echo "$trim"
#shows the extracted names on powershell (just to check if they were extracted correctly)





# ~~step 2- add a counter in each line in the textfile (to avoid having new file names that are exactly the same in the next step)~~ 

$b = get-content $PSScriptRoot\list_names.txt

$i=1

$b | foreach-object {$_+$i
$i++
}



# ~~step 3- use the polling station names in the textfile to rename the form 34s~~


$myHeader= echo fileName newName
Import-Csv $PSScriptRoot\list_names.txt -Header $myHeader | foreach { 
	if (test-path -path "$PSScriptRoot\*.pdf") { 
				rename-Item $_.fileName $_.newName 
	} 
}




Stop-Transcript
#stop logging error messages, etc.
