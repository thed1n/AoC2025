$data = gc .\day5\input.txt

$ranges = [System.Collections.Generic.list[pscustomobject]]@()
$freshpositions =  $data | % {
    if ([string]::IsNullOrEmpty($_)) {return}
    if ($_ -match '-') {
        [int64]$l,[int64]$h = $_ -split '-'
        $ranges.add([pscustomobject]@{
            Low = $l
            High = $h
        })
    } else {
        [int64]$_
    }   
}

#cheap version
$sum = 0
:outer foreach ($f in $freshpositions) {
    foreach ($r in $ranges) {
        if ($f -ge $r.low -and $f -le $r.High) {
            #write-host "$f $($r.low)  $($r.high)"
            $sum++
            continue outer
        }
    }
}
$sum

$sortedranges = $ranges | sort low

while ($true) {
    $changed = $false
for ($i=0; $i -lt $sortedranges.count; $i++) {
    
    if (($sortedranges[$i].low -ge $sortedranges[$i+1].low -and $sortedranges[$i].low -le $sortedranges[$i+1].high) -or ($sortedranges[$i].high -ge $sortedranges[$i+1].low -and $sortedranges[$i].high -le $sortedranges[$i+1].high)) {
        
        if ($sortedranges[$i].low -gt $sortedranges[$i+1].low) {
            $sortedranges[$i].low = $sortedranges[$i+1].low
            $changed = $true
        } elseif ($sortedranges[$i+1].low -gt $sortedranges[$i].low) {
            $sortedranges[$i+1].low = $sortedranges[$i].low
            $changed = $true
        }

        if ($sortedranges[$i+1].high -gt $sortedranges[$i].high) {
            $sortedranges[$i].high = $sortedranges[$i+1].high
            $changed = $true
        } elseif ($sortedranges[$i].high -gt $sortedranges[$i+1].high) {
            $sortedranges[$i+1].high = $sortedranges[$i].high
            $changed = $true
        }
        
    }

}
if ($changed -eq $false) {
    break
}
}

$uniqueranges = $sortedranges | sort -Unique low,high

[int64]$sum2 = 0
$uniqueranges | % {
    #$sum2 += 
    ($_.high - $_.low) + 1
}

$sum2

#360413497045311

<#
Low            High
---            ----
2157927821344   5870181288183
11529515560599  14764568063191
14764568063193  19253939891730
23029611009699  23029611009699
23029611009700  27519859263588
30641998874405  38108327610839
36272910753387  38108327610839
43378411936235  47339949118256
43378411936235  47339949118256
54082894481381  56510094938283
#>
