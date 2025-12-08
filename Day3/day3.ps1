$data = get-content .\day3\input.txt
$sum = 0
foreach ($row in $data) {

    $first = [char[]]$row | Group-Object -NoElement | Sort-Object name -desc
    
    foreach ($c in $first[0..10]) {
        $f = $row.IndexOf($c.name)
        if ($f -ne $row.Length - 1) {
            break
        }
    }

    foreach ($c in $first[0..10]) {
        $n = $row.IndexOf($c.name, $f + 1)
        if ($n -gt $f) {
            break
        }
    }
    [Int32]"$($row[$f])$($row[$n])"
    $sum += [Int32]"$($row[$f])$($row[$n])"

}

[int64]$sum2 = 0
foreach ($row in $data) {

    $first = [char[]]$row | Group-Object -NoElement | Sort-Object name -desc
    foreach ($c in $first[0..10]) {
        $f = $row.IndexOf($c.name)
        if (($row.Length - 1 - $f) -ge 12) {
            break
        }
    }

    [System.Collections.Generic.list[char]]$rowarray = $row.ToCharArray()
    if ($f -ne 0) {
        0..($f - 1) | ForEach-Object { $rowarray.RemoveAt(0) }
    }

    :outer for ($i = 1 ; $i -lt $rowarray.count; $i++) {
            
        while ($rowarray[$i] -gt $rowarray[($i - 1)] -and $rowarray.count -gt 12) {
            #Clear all lower numbers before this number
            $rowarray.RemoveAt(($i - 1))
            $i--
        }
        if ($rowarray[$i] -gt $rowarray[($i - 1)] -and $rowarray.count -gt 12) {
            continue outer
        }
    }

    if ($rowarray.count -gt 12) {
        12..($rowarray.count - 1) | ForEach-Object { $rowarray.RemoveAt(($rowarray.count - 1)) }
    }

    $sumstring = $rowarray -join ''
    $sum2 += [Int64]$sumstring
}

[pscustomobject]@{
    part1 = $sum
    part2 = $sum2
}
