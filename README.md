# Safe Recon Toolkit

A lightweight, menu-driven PowerShell toolkit designed for rapid, read-only reconnaissance on Windows systems.

## Overview

The Safe Recon Toolkit enables security consultants and IT professionals to quickly gather key system and security-related information within a 60-second scan window. It exports detailed, timestamped reports to a dedicated folder (`C:\ReconReport` by default). This toolkit is ideal for baseline audits, diagnostics, and initial client assessments without modifying any system settings.

## Features

- Collects system info, local users, running services, and processes  
- Enumerates scheduled tasks, listening network ports, and installed software  
- Runs tasks in parallel using background jobs for efficiency  
- Outputs plain-text reports in timestamped folders  
- Simple interactive menu-driven UI for ease of use  
- Fully read-only and safe to run in production environments  

## Prerequisites

- Windows PowerShell 5.1 or later (PowerShell Core not required)  
- Recommended: Run as Administrator for fullest data collection (optional)  
- Execution Policy set to allow script running:  
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

## Usage

1. Download or clone the repository  
2. Open PowerShell and navigate to the script location  
3. Run the script:  
   ```powershell
   .\safe-recon-toolkit.ps1
   ```  
4. Use the menu to run the 60-second reconnaissance or exit  
5. Find generated reports in `C:\ReconReport\Recon-YYYYMMDD-HHMMSS\`

## Configuration

- To change the output folder, edit the `$OutputFolder` variable near the top of the script  

## Planned Features

- Extended recon for Active Directory and domain info  
- Event log summaries focused on security events  
- Firewall and policy audit reports  
- Enhanced output formats (CSV, JSON)  
- Configurable scan duration and output paths  
- Automated report emailing or uploading  

## Contribution Guidelines

Contributions, bug reports, and feature requests are welcome!  

To contribute:

1. Fork the repo  
2. Create a feature branch (`git checkout -b feature/my-feature`)  
3. Commit your changes (`git commit -m 'Add my feature'`)  
4. Push to the branch (`git push origin feature/my-feature`)  
5. Open a pull request  

Please ensure your code is well-documented and tested.

---

*Developed by Low Country Cyber — Empowering SMBs with accessible cybersecurity tools.*
