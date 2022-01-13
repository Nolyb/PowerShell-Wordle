#
# PS Wordle clone by Kevin Doran, with help from Josh Heinze
# Original concept by Josh Wardle @ https://www.powerlanguage.co.uk/wordle/
#

function wordcheck ($word) {
    if ($word.Length -ne 5 -or $word -notmatch "[a-z]") {write-host "Guess must be 5 letters." -BackgroundColor red; return $false}
    else {return $true}
}

function wordvalid ($valid) {
    if ($wordarr.Contains($valid) -eq $False) {write-host "Not a valid word." -BackgroundColor red; return $false}
    else {return $true}
}

function wordle ($guess) {
    for ($i=0;$i -lt $guess.length;$i++) {
    if ($guess[$i] -match $answer[$i])
            {write-host $guess[$i].ToString().ToUpper() -nonewline -BackgroundColor green; $green = $guess[$i]}
            else {
                for ($j=0;$j -lt $answer.length;$j++) {
                        if ($guess[$i] -match $answer[$j] -or $guess[$i] -notmatch $green) 
                            {write-host $guess[$i].ToString().ToUpper() -nonewline -BackgroundColor yellow; $yellow = $guess[$i]}
                }
            }
    if ($green -eq $null -and $yellow -eq $null) {write-host $guess[$i].ToString().ToUpper() -nonewline}
    clear-variable green -ErrorAction ignore
    clear-variable yellow -ErrorAction ignore
    }
}

$wordlisturl = "https://raw.githubusercontent.com/charlesreid1/five-letter-words/master/sgb-words.txt"
$wordlist = Invoke-WebRequest $wordlisturl | select -ExpandProperty content
$wordarr = $wordlist.Split()
$answer = get-random $wordarr

clear

write-host "Welcome to the Powershell Wordle clone. Check out the real Wordle here: https://www.powerlanguage.co.uk/wordle/"
write-host "================="
write-host "Instructions: Guess the 5 letter word, you have 6 tries."
write-host "- If the background of a letter is " -nonewline; write-host "yellow" -foregroundcolor black -BackgroundColor yellow -nonewline; write-host " then that letter is in the word, but the incorrect spot."
write-host "- If the background of a letter is " -nonewline; write-host "green" -foregroundcolor black -BackgroundColor green -nonewline; write-host " then that letter is in the word in the correct spot."
write-host "- If there is no background color, the letter is in the word."
$n = 1
$g =@()
while ($n -lt 7) {
        for ($i=0;$i -lt $g.length; $i++) {wordle $g[$i]; write-host}
        do {$guess = read-host "`nGuess #$n"; $check = wordcheck $guess; $valid = wordvalid $guess}
        until ($check -eq $true -and $valid -eq $true)
        wordle $guess
        $g += $guess
        if ($guess -match $answer) {clear; for ($i=0;$i -lt $g.length; $i++) {wordle $g[$i]; write-host}; write-host "`n`nWINNNNNNER!" -BackgroundColor blue; exit}
        $n += 1
        clear
        }
clear

for ($i=0;$i -lt $g.length; $i++) {wordle $g[$i]; write-host}
write-host "`n`nThe answer is: " -nonewline; write-host "$($answer.ToUpper())" -BackgroundColor blue
