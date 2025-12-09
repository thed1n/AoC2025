$tree = get-content .\Day7\input.txt
$tree = get-content .\Day7\test.txt


function drawgrid {
for ($y = 0 ; $y -lt $tree.count; $y++) {

    for ($x=0;$x -lt $tree[0].Length ; $x++) {
        write-host $grid["$x,$y"] -NoNewline
    }
    write-host
}
}
function drawgrid2 {
for ($y = 0 ; $y -lt $tree.count; $y++) {

    for ($x=0;$x -lt $tree[0].Length ; $x++) {
        write-host $grid2["$x,$y"] -NoNewline
    }
    write-host
}
}

$grid = @{}
$start = ''
for ($y = 0 ; $y -lt $tree.count; $y++) {
    for ($x=0;$x -lt $tree[0].Length ; $x++) {
        if ($tree[$y][$x] -eq 'S') {
            $startcord = "$x,$y"
        }
        $grid["$x,$y"] = $tree[$y][$x]
    }
}
$grid2 = $grid.Clone()

$splitcords = [pscustomobject]@{
    left = [pscustomobject]@{
        x =-1
        y = 1
    }
    right = [pscustomobject]@{
        x = 1
        y = 1
    }
    down = [pscustomobject]@{
        x = 0
        y = 1
    }
}

[System.Collections.generic.queue[string]]$tachyonbeams = @()
$tachyonbeams.enqueue("$startcord")
$visited = @{}


while ($tachyonbeams.count -gt 0) {
    $start = $tachyonbeams.Dequeue()
    [int]$xn,[int]$yn = $start -split ','
    
    if ($visited.containskey("$xn,$yn")) {
        continue
    }
    switch ($grid["$xn,$yn"]) {
        '^' {
            $visited["$xn,$yn"]++
            $left = "$($xn+$splitcords.left.x),$($yn+$splitcords.left.y)"
            $right = "$($xn+$splitcords.right.x),$($yn+$splitcords.right.y)"
            $tachyonbeams.Enqueue($left)
            $tachyonbeams.Enqueue($right)
            break
        }
        '.' {$grid["$xn,$yn"] = '|'
            $down = "$xn,$($yn+$splitcords.down.y)"
            $tachyonbeams.Enqueue($down)
            break
        }
        'S' {
            $down = "$xn,$($yn+$splitcords.down.y)"
            $tachyonbeams.Enqueue($down)
            break
        }
        default {}
    }
}

#Quantum entanglement
$tachyonbeams.enqueue("$startcord")
$beamnodes = @{}
$beamAtEnd = 0

while ($tachyonbeams.count -gt 0) {
    $start = $tachyonbeams.Dequeue()
    [int]$xn,[int]$yn = $start -split ','
    
    if ($beamnodes.containskey("$xn,$yn")) {
        continue
    }

    if ($yn -eq $tree.count) {
        $beamAtEnd++
    }
    switch ($grid2["$xn,$yn"]) {
        '^' {
            #$visited["$xn,$yn"]++
            $left = "$($xn+$splitcords.left.x),$($yn+$splitcords.left.y)"
            $right = "$($xn+$splitcords.right.x),$($yn+$splitcords.right.y)"
            $tachyonbeams.Enqueue($left)
            $tachyonbeams.Enqueue($right)
            break
        }
        '.' {$grid2["$xn,$yn"] = '|'
            $beamnodes["$xn,$yn"]++
            $down = "$xn,$($yn+$splitcords.down.y)"
            $tachyonbeams.Enqueue($down)
            break
        }
        'S' {
            $down = "$xn,$($yn+$splitcords.down.y)"
            $tachyonbeams.Enqueue($down)
            break
        }
        default {}
    }
}

[pscustomobject]@{
    Part1 = $visited.Keys.count
    Part2 = $beamAtEnd
}
drawgrid2