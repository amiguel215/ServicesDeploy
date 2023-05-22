# ServicesDeploy

This PowerShell script allows you to sign in to the Azure Portal, check, create, and manage Resource Groups and the associated resources.

Please make sure to set the desired environment where you want to create, search, or manage the resources. "Dev or Prod".

## Instructions:
1. Clone the repository or directly download the script file (".ps1" extension)
2. located the file in your preferred folder, open your favorite terminal and navigate into the file location
3. Run the script as follow:  .\ServicesDeploy.ps1

## Additional notes:
* The Script will automatically change the execution policy "Set-ExecutionPolicy RemoteSigned"
* The script checks the current environment selection (Dev or Prod) and creates or manages resources accordingly.
* Please make sure to review and update the resource names and settings in the script according to your requirements before running it.
* If you encounter any issues during script execution or have any questions, please reach out to the script author or refer to the documentation of the Azure PowerShell modules used in the script.
