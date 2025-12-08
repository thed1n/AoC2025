$data = gc -path .\day6\input.txt

$columns = [ordered]@{}
$widestnumber = 0
$data[-2] | % {
    $d = $_
    $numbers = $d -split '\s+' |? {$_}
    #$numberspt2 = $_ -split '(?<=\G....)(?!$)'
    $numberspt2 = for ($l = 0;$l -lt $d.length;) {
        if ($d[$l] -in ('+','*')) {
            ''
            break
        }
        #write-host $l
        $word = ''
        while ($true) {
            if ($word.Length -eq 4 -or $l -ge $d.length) {
                $l++
                break
            }

            $word += $d[$l]
            
            if ($d[$l] -match '\d' -and $d[$l+1] -match '\s' -and $d[$l+2] -match '\d') {
                $l+=2
                break
            }
            elseif ($d[$l] -match '\s' -and $d[$l+1] -match '\s' -and $d[$l+2] -match '\d') {
                $l+=2
                break
            }
            $l++
            
        }   
        $word.PadLeft(4,' ')
        #write-host $l
    }

    for ($i=0;$i -lt $numbers.count; $i++) {
        if ($widestnumber -lt $numbers[$i].Length) {$widestnumber = $numbers[$i].length}

        if ($columns.Contains($i)) {
            if ($numbers[$i] -notmatch '\d+') {
                $columns[$i].operator = $numbers[$i]
            } else {
                $columns[$i].numbers.add($numbers[$i])
                $columns[$i].part2.add($numberspt2[$i])
            }
        
        }
        else {
            $columns.add($i,[pscustomobject]@{
                numbers = [system.collections.generic.list[string]]::new()
                part2 = [system.collections.generic.list[string]]::new()
                operator = ''
            })
            $columns[$i].numbers.add($numbers[$i])
            $columns[$i].part2.add($numberspt2[$i])
        }
    }
}

[int64]$sum3 = 0
$columns.keys | % {
$key = $_
    switch ($columns[$key].operator) {
        '+' {
            $columns[$key].numbers | % {
                $sum3 += [int64]$_
            }
        }
        '*' {
            [int64]$tsum = 1
            $columns[$key].numbers | % {
                $tsum *= [int64]$_
            }
            $sum3 += $tsum
        }
        '-' {}
        '/' {}
    }
}

$part2 = 0
$columns.keys | % {
    $key = $_
    #$paddednumbers = $columns[$key].numbers.padleft($widestnumber,' ')

    $numbersToCalculate = @()
        
        3..0 | % {
            $pos = $_
            $nr = for ($i=0;$i -lt $columns[$key].part2.count;$i++) {
                $columns[$key].part2[$i][$pos]
            }
            $toAdd = [int]($nr -join '')
            if ($toAdd -eq 0) { return}
            $numbersToCalculate+= $toadd
        }
    
        write-host $($numbersToCalculate -join ' , ')

    switch ($columns[$key].operator) {
        '+' {
            $numbersToCalculate | % {
                $part2 += [int64]$_
            }
        }
        '*' {
            [int64]$tsum = 1
            $numbersToCalculate | % {
                $tsum *= [int64]$_
            }
            $part2 += $tsum
        }
    }
}

[pscustomobject]@{
    Part1 = $sum3
    Part2 = $part2
}

#         Part1            Part2
#         -----            -----
# 4412382293768 1538774964680905
