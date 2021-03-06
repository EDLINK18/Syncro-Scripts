### All parameters that need to be updates to make script work are in the parameters section at the top of the script. XXXXX are placeholders for what needs to be changed.
### These functions, options, etc have been put together from multiple sources. Please feel free to optomize and submit changes back if there is a better way.
### Note: Background image should be 375x67
### Thanks, EDLINK18 - Region 18 Education Service Center Technology Consortium
#-------------------------------------------------------
#Script parameters to edit
#-------------------------------------------------------
$TempFolder = "c:\temp\XXXXX"
$Favicon = "c:\temp\XXXXX\XXXXX.ico"
$FaviconURL = "https://www.XXXXX.net/imgs/favicon.ico"
$Background = "c:\temp\XXXXX\XXXXX_Background.jpg"
$BackgroundURL = "https://www.XXXXX.net/imgs/XXXXX_background.jpg"
$CompanyName = "XXXXX"
$CheckDays = "30"
#-------------------------------------------------------
#Should not have to edit anything below this line.
#-------------------------------------------------------
$LastRebootTime = Get-WmiObject win32_operatingsystem | 
Select-Object csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}

$Today = Get-Date
$DiffDays = $Today.Date - $LastRebootTime.LastBootUpTime.Date

Write-Host "Days since boot: $($DiffDays.TotalDays)" 


if($DiffDays.TotalDays -gt $CheckDays)
{
#Check that temp folder exists, if not create folder
if (Test-Path $TempFolder) {
}
else
{
    New-Item $TempFolder -ItemType Directory
}
#Download ICO file for application window
if (Test-Path $Favicon) {
}
else
{
Invoke-WebRequest -Uri "$FaviconURL" -OutFile "$Favicon"
}
#Download background image for application window
if (Test-Path $Background) {
}
else
{
Invoke-WebRequest -Uri "$BackgroundURL" -OutFile "$Background"
}

#---------------------------------------------- 
#region Import Assemblies 
#---------------------------------------------- 
[void][Reflection.Assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089') 
[void][Reflection.Assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089') 
[void][Reflection.Assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a') 
#endregion Import Assemblies 
 
 
#Define a Param block to use custom parameters in the project 
#Param ($CustomParameter) 
 
function Main { 
<# 
    .SYNOPSIS 
        The Main function starts the project application. 
     
    .PARAMETER Commandline 
        $Commandline contains the complete argument string passed to the script packager executable. 
     
    .NOTES 
        Use this function to initialize your script and to call GUI forms. 
         
    .NOTES 
        To get the console output in the Packager (Forms Engine) use:  
        $ConsoleOutput (Type: System.Collections.ArrayList) 
#> 
    Param ([String]$Commandline) 
         
    #-------------------------------------------------------------------------- 
    #TODO: Add initialization script here (Load modules and check requirements) 
     
     
    #-------------------------------------------------------------------------- 
     
    if((Call-MainForm_psf) -eq 'OK') 
    { 
         
    } 
     
    $global:ExitCode = 0 #Set the exit code for the Packager 
} 
 
#endregion Source: Startup.pss 
 
#region Source: MainForm.psf 
function Call-MainForm_psf 
{ 
 
    #---------------------------------------------- 
    #region Import the Assemblies 
    #---------------------------------------------- 
    [void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089') 
    [void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089') 
    [void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a') 
    #endregion Import Assemblies 
 
    #---------------------------------------------- 
    #region Generated Form Objects 
    #---------------------------------------------- 
    [System.Windows.Forms.Application]::EnableVisualStyles() 
    $MainForm = New-Object 'System.Windows.Forms.Form' 
    $panel2 = New-Object 'System.Windows.Forms.Panel' 
    $ButtonSchedule2 = New-Object 'System.Windows.Forms.Button' 
    $ButtonSchedule = New-Object 'System.Windows.Forms.Button' 
    $ButtonRestartNow = New-Object 'System.Windows.Forms.Button' 
    $panel1 = New-Object 'System.Windows.Forms.Panel' 
    $labelITSystemsMaintenance = New-Object 'System.Windows.Forms.Label' 
    $labelSecondsLeftToRestart = New-Object 'System.Windows.Forms.Label' 
    $labelTime = New-Object 'System.Windows.Forms.Label' 
    $labelInOrderToApplySecuri = New-Object 'System.Windows.Forms.Label' 
    $timerUpdate = New-Object 'System.Windows.Forms.Timer' 
    $InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState' 
    #endregion Generated Form Objects 
 
    #---------------------------------------------- 
    # User Generated Script 
    #---------------------------------------------- 
    $TotalTime = 300 #in seconds 
     
    $MainForm_Load={ 
        #TODO: Initialize Form Controls here 
        $labelTime.Text = "{0:D2}" -f $TotalTime #$TotalTime 
        #Add TotalTime to current time 
        $script:StartTime = (Get-Date).AddSeconds($TotalTime) 
        #Start the timer 
        $timerUpdate.Start() 
    } 
     
     
    $timerUpdate_Tick={ 
        # Define countdown timer 
        [TimeSpan]$span = $script:StartTime - (Get-Date) 
        #Update the display 
        $labelTime.Text = "{0:N0}" -f $span.TotalSeconds 
        $timerUpdate.Start() 
        if ($span.TotalSeconds -le 0) 
        { 
            $timerUpdate.Stop() 
            Restart-Computer -Force 
        } 
         
    } 
     
    $ButtonRestartNow_Click = { 
        # Restart the computer immediately 
        Restart-Computer -Force 
    } 
     
    $ButtonSchedule_Click={ 
        # Schedule restart for 6pm 
        (schtasks /create /sc once /tn "Post Maintenance Restart" /tr "shutdown - r -f ""restart""" /st 18:00 /f) 
        $MainForm.Close() 
    } 
    
    $ButtonSchedule2_Click={ 
        # Schedule restart for 10pm 
        (schtasks /create /sc once /tn "Post Maintenance Restart" /tr "shutdown - r -f ""restart""" /st 22:00 /f) 
        $MainForm.Close() 
    }
  
    $labelITSystemsMaintenance_Click={ 
        #TODO: Place custom script here 
         
    } 
     
    $panel2_Paint=[System.Windows.Forms.PaintEventHandler]{ 
    #Event Argument: $_ = [System.Windows.Forms.PaintEventArgs] 
        #TODO: Place custom script here 
         
    } 
     
    $labelTime_Click={ 
        #TODO: Place custom script here 
         
    } 
        # --End User Generated Script-- 
    #---------------------------------------------- 
    #region Generated Events 
    #---------------------------------------------- 
     
    $Form_StateCorrection_Load= 
    { 
        #Correct the initial state of the form to prevent the .Net maximized form issue 
        $MainForm.WindowState = $InitialFormWindowState 
    } 
     
    $Form_StoreValues_Closing= 
    { 
        #Store the control values 
    } 
 
     
    $Form_Cleanup_FormClosed= 
    { 
        #Remove all event handlers from the controls 
        try 
        { 
            $ButtonSchedule2.remove_Click($buttonSchedule2_Click) 
            $ButtonSchedule.remove_Click($ButtonSchedule_Click) 
            $ButtonRestartNow.remove_Click($ButtonRestartNow_Click) 
            $panel2.remove_Paint($panel2_Paint) 
            $labelITSystemsMaintenance.remove_Click($labelITSystemsMaintenance_Click) 
            $labelTime.remove_Click($labelTime_Click) 
            $MainForm.remove_Load($MainForm_Load) 
            $timerUpdate.remove_Tick($timerUpdate_Tick) 
            $MainForm.remove_Load($Form_StateCorrection_Load) 
            $MainForm.remove_Closing($Form_StoreValues_Closing) 
            $MainForm.remove_FormClosed($Form_Cleanup_FormClosed) 
        } 
        catch [Exception] 
        { } 
    } 
    #endregion Generated Events 
 
    #---------------------------------------------- 
    #region Generated Form Code 
    #---------------------------------------------- 
    $MainForm.SuspendLayout() 
    $panel2.SuspendLayout() 
    $panel1.SuspendLayout() 
    # 
    # MainForm 
    # 
    $MainForm.Controls.Add($panel2) 
    $MainForm.Controls.Add($panel1) 
    $MainForm.Controls.Add($labelSecondsLeftToRestart) 
    $MainForm.Controls.Add($labelTime) 
    $MainForm.Controls.Add($labelInOrderToApplySecuri) 
    $MainForm.AutoScaleDimensions = '6, 13' 
    $MainForm.AutoScaleMode = 'Font' 
    $MainForm.BackColor = 'White' 
    $MainForm.ClientSize = '373, 279' 
    $MainForm.MaximizeBox = $False 
    $MainForm.MinimizeBox = $False 
    $MainForm.Name = 'MainForm' 
    $MainForm.ShowIcon = $True 
    $objIcon = New-Object system.drawing.icon ("$Favicon")
    $MainForm.Icon = $objIcon
    $MainForm.ShowInTaskbar = $False 
    $MainForm.StartPosition = 'CenterScreen' 
    $MainForm.Text = "$CompanyName Support Services" 
    $MainForm.TopMost = $True 
    $MainForm.add_Load($MainForm_Load) 
    # 
    # panel2 
    # 
    $panel2.Controls.Add($ButtonSchedule2) 
    $panel2.Controls.Add($ButtonSchedule) 
    $panel2.Controls.Add($ButtonRestartNow) 
    $panel2.BackColor = 'ScrollBar' 
    $panel2.Location = '0, 205' 
    $panel2.Name = 'panel2' 
    $panel2.Size = '378, 80' 
    $panel2.TabIndex = 9 
    $panel2.add_Paint($panel2_Paint) 
    # 
    # ButtonCancel 
    # 
    $ButtonSchedule2.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
    $ButtonSchedule2.Location = '250, 17' 
    $ButtonSchedule2.Name = 'ButtonCancel' 
    $ButtonSchedule2.Size = '105, 45' 
    $ButtonSchedule2.TabIndex = 7 
    $ButtonSchedule2.Text = 'Schedule - 10pm' 
    $ButtonSchedule2.UseVisualStyleBackColor = $True 
    $ButtonSchedule2.add_Click($ButtonSchedule2_Click) 
    # 
    # ButtonSchedule 
    # 
    $ButtonSchedule.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold' 
    $ButtonSchedule.Location = '139, 17' 
    $ButtonSchedule.Name = 'ButtonSchedule' 
    $ButtonSchedule.Size = '105, 45' 
    $ButtonSchedule.TabIndex = 6 
    $ButtonSchedule.Text = 'Schedule - 6pm' 
    $ButtonSchedule.UseVisualStyleBackColor = $True 
    $ButtonSchedule.add_Click($ButtonSchedule_Click) 
    # 
    # ButtonRestartNow 
    # 
    $ButtonRestartNow.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold' 
    $ButtonRestartNow.ForeColor = 'DarkRed' 
    $ButtonRestartNow.Location = '42, 17' 
    $ButtonRestartNow.Name = 'ButtonRestartNow' 
    $ButtonRestartNow.Size = '91, 45' 
    $ButtonRestartNow.TabIndex = 0 
    $ButtonRestartNow.Text = 'Restart Now' 
    $ButtonRestartNow.UseVisualStyleBackColor = $True 
    $ButtonRestartNow.add_Click($ButtonRestartNow_Click) 
    # 
    # panel1 
    # 
    $objImage = [system.drawing.image]::FromFile("$Background")
    $panel1.Controls.Add($labelITSystemsMaintenance) 
    $panel1.BackColor = '0, 114, 198' 
    $panel1.Location = '0, 0' 
    $panel1.Name = 'panel1' 
    $panel1.Size = '375, 67' 
    $panel1.BackgroundImage = $objImage
    $panel1.BackgroundImageLayout = "None"
    $panel1.TabIndex = 8 
    # 
    # labelITSystemsMaintenance 
    # 
    
    $labelITSystemsMaintenance.Font = 'Microsoft Sans Serif, 14.25pt' 
    $labelITSystemsMaintenance.ForeColor = 'White' 
    $labelITSystemsMaintenance.BackColor = "Transparent"
    $labelITSystemsMaintenance.Location = '11, 18' 
    $labelITSystemsMaintenance.Name = 'labelITSystemsMaintenance' 
    $labelITSystemsMaintenance.Size = '269, 23' 
    $labelITSystemsMaintenance.TabIndex = 1 
    $labelITSystemsMaintenance.Text = 'IT Systems Maintenance' 
    $labelITSystemsMaintenance.TextAlign = 'MiddleLeft' 
    $labelITSystemsMaintenance.add_Click($labelITSystemsMaintenance_Click) 
    # 
    # labelSecondsLeftToRestart 
    # 
    $labelSecondsLeftToRestart.AutoSize = $True 
    $labelSecondsLeftToRestart.Font = 'Microsoft Sans Serif, 9pt, style=Bold' 
    $labelSecondsLeftToRestart.Location = '87, 176' 
    $labelSecondsLeftToRestart.Name = 'labelSecondsLeftToRestart' 
    $labelSecondsLeftToRestart.Size = '155, 15' 
    $labelSecondsLeftToRestart.TabIndex = 5 
    $labelSecondsLeftToRestart.Text = 'Seconds left to restart :' 
    # 
    # labelTime 
    # 
    $labelTime.AutoSize = $True 
    $labelTime.Font = 'Microsoft Sans Serif, 9pt, style=Bold' 
    $labelTime.ForeColor = '192, 0, 0' 
    $labelTime.Location = '237, 176' 
    $labelTime.Name = 'labelTime' 
    $labelTime.Size = '43, 15' 
    $labelTime.TabIndex = 3 
    $labelTime.Text = '00:60' 
    $labelTime.TextAlign = 'MiddleCenter' 
    $labelTime.add_Click($labelTime_Click) 
    # 
    # labelInOrderToApplySecuri 
    # 
    $labelInOrderToApplySecuri.Font = 'Microsoft Sans Serif, 9pt' 
    $labelInOrderToApplySecuri.Location = '12, 84' 
    $labelInOrderToApplySecuri.Name = 'labelInOrderToApplySecuri' 
    $labelInOrderToApplySecuri.Size = '350, 83' 
    $labelInOrderToApplySecuri.TabIndex = 2 
    $labelInOrderToApplySecuri.Text = 'In order to apply security patches and updates for your system, your machine must be restarted.  
 
If you do not wish to restart you computer at this time please select a time to reboot below.' 
    # 
    # timerUpdate 
    # 
    $timerUpdate.add_Tick($timerUpdate_Tick) 
    $panel1.ResumeLayout() 
    $panel2.ResumeLayout() 
    $MainForm.ResumeLayout() 
    #endregion Generated Form Code 
 
    #---------------------------------------------- 
 
    #Save the initial state of the form 
    $InitialFormWindowState = $MainForm.WindowState 
    #Init the OnLoad event to correct the initial state of the form 
    $MainForm.add_Load($Form_StateCorrection_Load) 
    #Clean up the control events 
    $MainForm.add_FormClosed($Form_Cleanup_FormClosed) 
    #Store the control values when form is closing 
    $MainForm.add_Closing($Form_StoreValues_Closing) 
    #Show the Form 
    return $MainForm.ShowDialog() 
 
} 
#endregion Source: MainForm.psf 
 
#Start the application 
Main ($CommandLine) 
}
else {
    Write-Output "Reboot Not Requered"
}
