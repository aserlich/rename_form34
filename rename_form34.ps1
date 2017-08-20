
Start-Transcript -path C:\Users\Spark\Desktop\AA\all_pdf_copy\error_log.txt -Append

#...


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
#making it into a single line string

$trim= ([regex]::Match($text_one_line, 'S*T*A*T*I*O*N: (.+) S*T*R*E*A*M:').Groups[1].Value) -replace "[\s # < > $ % ! % * ' { } / \ :]", ''
#isolating the polling station name

$txtname = $txt.BaseName


"`"$txtname.pdf`",`"$trim`_$i.pdf`"" | Add-Content -Path $PSScriptRoot\list_names.txt 
#each line printed in the textfile has both the original name and the matching polling station name separated by a space

$i++

}

echo "$trim"



#...



$b = get-content $PSScriptRoot\list_names.txt

$i=1


$b | foreach-object {$_+$i
$i++
}



#...


$myHeader= echo fileName newName
Import-Csv $PSScriptRoot\list_names.txt -Header $myHeader | foreach { 
	if (test-path -path "$PSScriptRoot\*.pdf") { 
				rename-Item $_.fileName $_.newName 
	} 
}




#...

Stop-Transcript