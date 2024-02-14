# Windows Copilot for European Systems
![Alt text](WindowsCopilotScreenshot.jpg)


## Overview
This repository contains a script that enables the use of Windows Copilot on European systems. Due to the EU Digital Markets Act (DMA), Windows Copilot is not available by default in Europe. This script provides a workaround by directly launching the associated UI.

- For more information on the EU Digital Markets Act (DMA), visit [EU Digital Markets Act Official Page]([https://example.com/eu-dma "EU DMA Info](https://digital-markets-act.ec.europa.eu/index_en)").
- Learn more about Windows Copilot at [Windows Copilot Official](https://www.microsoft.com/en-us/windows/copilot-ai-features).


## Prerequisites
- Windows 10 or later, tested only with Windows 23H2 Insider Preview Build 22635.3140

## Installation
1. Download the Zip file [Windows_Copilot_for_Europe.zip](Windows_Copilot_for_Europe.zip) from this repository.
2. Unblock the Zip file after the Download, Right click, Properties, Unblock, Apply
   
![Alt text](UnblockZipFile.jpg)

3. Manually create a new folder on your system, e.g., `C:\Users\Public\Copilot`.
4. Extract all files into the newly created folder
   
## Usage
To start Windows Copilot, follow these steps:
1. Navigate to the folder `C:\Users\Public\Copilot`.
2. Execute the script `Start-Copilot.ps1` by right-clicking it and selecting `Run with PowerShell`.
3. Optionally, you can pin the shortcut `Copilot.lnk` to your taskbar for quick access to Windows Copilot.

## Important Notes
- This script is merely a workaround and might be affected by future updates of Windows or changes to the EU Digital Markets Act (DMA).
- Please use this script responsibly and understand that usage is at your own risk.

## Contributing
Feedback and contributions to this project are welcome. If you wish to suggest improvements or report bugs, you can do so through the Issues or Pull Requests in this repository.

## Disclaimer
This project is not affiliated with Microsoft Corporation. Windows Copilot and all related trademarks are the property of Microsoft Corporation.
