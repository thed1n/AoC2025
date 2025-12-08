$data = (gcb)
function drawgrid {
for ($y = 0 ; $y -lt $data.count; $y++) {

    for ($x=0;$x -lt $data[0].Length ; $x++) {
        write-host $($nodes["$x,$y"].type) -NoNewline
    }
    write-host
}
}
#x,y
$cords = @(
    "-1,-1"
    "0,-1"
    "1,-1"
    "-1,0"
    "1,0"
    "-1,1"
    "0,1"
    "1,1"
)
$nodes = @{}
for ($y = 0 ; $y -lt $data.count; $y++) {

    for ($x=0;$x -lt $data[0].Length ; $x++) {

        $nodes["$x,$y"] = @{
            Neigh = [system.collections.generic.list[object]]::new()
            Rolls = 0
            Type = $data[$y][$x]
        }

        foreach ($c in $cords) {
            [int]$xx,[int]$yy = $c -split ','
            $xn = $x + $xx
            $yn = $y + $yy
            if (($xn -ge 0 -and $xn -lt $data[0].length) -and ($yn -ge 0 -and $yn -lt $data.count)) {
                $nodes["$x,$y"]['Neigh'].add([pscustomobject]@{
                    Cord = "$xn,$yn"    
                    Type = $data[$yn][$xn]
                })
            }
        }
        if ($nodes["$x,$y"].Type -eq '@') {
            $nodes["$x,$y"].Rolls = ($nodes["$x,$y"].neigh | ? {$_.type -eq '@'}).count
        }
    }
}

$part1 = 0
[System.Collections.Generic.HashSet[string]]$removedRolls = @{}
[System.Collections.Generic.HashSet[string]]$checkRolls = @{}
#[void]$removedRolls.add('spacethefinalfrontier')
#[void]$checkRolls.add('birdofpray')
$round = 0
$rolls = 0

while($true) {
$nodes.keys | % {
    if ($nodes[$_].type -eq '@' -and $nodes[$_].Rolls -le 3) {
        $rolls++
        [void]$removedRolls.add($_)
    }
}

$removedRolls.GetEnumerator() | % {$nodes["$_"].Type = '.'}
$nodes.keys | % {
    $k = $_
    $nodes["$k"].Rolls = ($nodes["$k"].neigh | ? {$nodes[$_.cord].type -eq '@'}).count # -and !$removedRolls.Contains($_.cord)}).count
}
# drawgrid
if ($round -eq $rolls) {
    $rolls
    break
}
if ($round -eq 0) {$part1 = $rolls}
$round = $rolls
$rolls
}
