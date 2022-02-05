:: ====================================================================================================
:: Step 3: Install not allowed
:: ====================================================================================================
::
:: Run the installer and look into the "install-not-allowed.log" file.
:: Find thge execution of th e"LaunchConditions" custom action. It returns the error code 3. Also,the
:: error message is logged there.
::
:: install.bat

msiexec /i StartCondition.msi /l*vx install-not-allowed.log ALLOW_TO_INSTALL=no