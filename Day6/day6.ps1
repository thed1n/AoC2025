$data = Get-Content -Path .\day6\input.txt

$columns = [ordered]@{}
$widestnumber = 0
$data | ForEach-Object {
    $d = $_
    $numbers = $d -split '\s+' | Where-Object { $_ }


    for ($i = 0; $i -lt $numbers.count; $i++) {
        if ($widestnumber -lt $numbers[$i].Length) { $widestnumber = $numbers[$i].length }

        if ($columns.Contains($i)) {
            if ($numbers[$i] -notmatch '\d+') {
                $columns[$i].operator = $numbers[$i]
            }
            else {
                $columns[$i].numbers.add($numbers[$i])
                if ($columns[$i].Length -lt $numbers[$i].length) {
                    $columns[$i].Length = $numbers[$i].Length
                }
            }
        
        }
        else {
            $columns.add($i, [pscustomobject]@{
                    numbers  = [system.collections.generic.list[string]]::new()
                    part2    = [system.collections.generic.list[string]]::new()
                    operator = ''
                    Length   = 0
                })
            $columns[$i].numbers.add($numbers[$i])
            $columns[$i].Length = $numbers[$i].Length
        }
    }
}
$data | ForEach-Object {

    $d = $_
    $c = 0
        
    $numberspt2 = for ($l = 0; $l -lt $d.Length; ) {
        $splitOn = $columns[$c].Length
        $word = ''
        for ($j = $l; $j -lt $l + $splitOn; $j++) {
            $word += $d[$j]
        }
        $l = $j + 1
        $word
        $c++
    }
    for ($i = 0; $i -lt $numberspt2.count; $i ++) {
        if ($numberspt2[$i] -match '\*|\+') {
            break
        }
        $columns[$i].part2.add($numberspt2[$i])
    }
}

[int64]$sum3 = 0
$columns.keys | ForEach-Object {
    $key = $_
    switch ($columns[$key].operator) {
        '+' {
            $columns[$key].numbers | ForEach-Object {
                $sum3 += [int64]$_
            }
        }
        '*' {
            [int64]$tsum = 1
            $columns[$key].numbers | ForEach-Object {
                $tsum *= [int64]$_
            }
            $sum3 += $tsum
        }
        '-' {}
        '/' {}
    }
}

$part2 = 0
$columns.keys | ForEach-Object {
    $key = $_

    $numbersToCalculate = @()
        
    3..0 | ForEach-Object {
        $pos = $_
        $nr = for ($i = 0; $i -lt $columns[$key].part2.count; $i++) {
            $columns[$key].part2[$i][$pos]
        }
        $toAdd = [int]($nr -join '')
        if ($toAdd -eq 0) { return }
        $numbersToCalculate += $toadd
    }
    
    #write-host $($numbersToCalculate -join ' , ')

    switch ($columns[$key].operator) {
        '+' {
            $numbersToCalculate | ForEach-Object {
                $part2 += [int64]$_
            }
        }
        '*' {
            [int64]$tsum = 1
            $numbersToCalculate | ForEach-Object {
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
