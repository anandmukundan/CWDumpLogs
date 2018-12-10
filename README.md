# CWDumpLogs
A Simple powershell script to export AWS CloudWatch Logs

This uses the AWS SDK to do this. So requires AWS SDK to be **already installed**.

## Usage

In Powershell:

~~~powershell
DumpCWLogs -LogGroupName <your Log Group Name>
~~~~

Note: AWS SDK will only by default download only the first 10,000 log entries from a log. This script does not currently track the next_token and download the next set. So for now, this restriction applies when using this script.
