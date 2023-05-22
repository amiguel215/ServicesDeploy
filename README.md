# ServicesDeploy

This PowerShell script allows you to sign in to the Azure Portal, check, create, and manage Resource Groups and the associated resources.

Please make sure to set the desired environment where you want to create, search, or manage the resources. "Dev or Prod".

## Instructions:
1. Clone the repository or directly download the script file (".ps1" extension).
2. located the file in your preferred folder, open your favorite terminal and navigate into the file location.
3. Run the script as follow:  .\ServicesDeploy.ps1
4. The script will automatically prompt you to sign in to the Azure Portal using your Azure credentials. Enter your username and password when prompted.
6. As the script executes, it will provide informative output in the terminal. You will see messages indicating the progress and status of resource group and resource operations.

## Additional notes:
* The Script will automatically change the execution policy "Set-ExecutionPolicy RemoteSigned"
* Please make sure to review and update the resource names and settings in the script according to your requirements before running it.
* The script checks for an existing Resource Group and its associated resources based on the environment selection. If the Resource Group or resources already exist, it will display their details.
* You can customize the script further to include additional resource management operations or modify the existing ones.
* If you encounter any issues during script execution or have any questions, please reach out to the script author or refer to the documentation of the Azure PowerShell modules used in the script.
