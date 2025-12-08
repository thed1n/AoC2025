$data = get-content .\day2\input.txt -raw

[System.Collections.Generic.list[pscustomobject]]$ranges = @()
$data -split ',' | % {
    [int64]$s,[int64]$e = $_ -split '-'
    $ranges.Add([pscustomobject]@{
        start = $s
        end = $e
    })
}



# [string]$length = '1111'.Length / 2
# $pattern = '(?<=\G\w{{{0}}})(?!$)' -f $length
# $pattern
# '1111' -split $pattern

[int64]$sum = 0

$ranges | % {

$start = $_.start
$end  = $_.end
    for ($i = $start;$i -le $end; $i++) {
        if ($i -gt 10) {
            $str = $i -as [string]
            $v = $str.length /2
            $pattern = '(?<=\G\w{{{0}}})(?!$)' -f $v

            $a,$b = [string]$i -split $pattern | ? {$_}
            if ($a -eq $b) {
                write-host "$i is a repeating pattern"
                $sum+=$i
            }
        }
    }

}

#Part2
[int64]$sum2 = 0
$ranges | % {

$start = $_.start
$end  = $_.end
    for ($i = $start;$i -le $end; $i++) {
        if ($i -gt 10) {

            $str = $i -as [string]
            $isEven = $str.Length%2 ? $true : $false
            $max = [math]::floor($str.length /2)

            :outer for ($x = $max ; $x -gt 0; $x --) {
                $v = $x
                $pattern = '(?<=\G\w{{{0}}})(?!$)' -f $v

                $a,$b = [string]$i -split $pattern | ? {$_}

                foreach ($element in $b) {
                    if ($a -ne $element) {
                        #write-host "$i is a repeating pattern $a -eq $element"
                        continue outer
                    }
                }
                #write-host "exited foreach"
                $sum2+=$i
                break outer
            }
        }
    }
}

[pscustomobject]@{
    Part1 = $sum
    Part2 = $sum2
}


