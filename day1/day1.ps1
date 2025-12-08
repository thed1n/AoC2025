$instructions = get-content .\input.txt
$dial = 50
$score = 0
$timeItsZero = 0

foreach ($i in $instructions) {
    if ($dial -eq 0 -or $dial -eq 100) {
        $score++
        $timeItsZero++
        $dial = 0
        #write-host "Score 0/100"
    }
    $isZero = $dial -eq 0 ? $true : $false

    $direction =  $i[0]
    [int]$steps = $i.Substring(1)

    if ([math]::Floor($steps/100) -ge 1) {
        $timeItsZero += [math]::Floor($steps/100)
        #write-host "score Steps"
        $steps = $steps % 100 #shorten steps to make it more manageable ie 935 is 35
    }

    Write-Host "Rotation:$direction Steps: $steps Dial: $dial"

    if ($direction -eq 'L') {

        $dial = $dial - $steps
        if ($dial -lt 0) {
            if (!$isZero) {
                $timeItsZero++ #skip scoring if it already was at zero
            }
            $dial =  100 + $dial
            #write-host "score L"
        }
        
    } else {
        $dial = [math]::abs($dial + $steps)
        if ($dial -gt 100) {
            $dial = $dial % 100
            $timeItsZero++
            #write-host "score R"
        }
    }
    
}

[pscustomobject]@{
    part1 = $score
    Part2 = $timeItsZero
}
