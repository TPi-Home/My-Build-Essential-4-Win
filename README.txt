README
First:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Second:
Install large script.

Third:
Install software not available in chocolatey, such as vcpkg.

Fourth:
Install all other dependencies, such as Win SDK using Visual Studio Installer.

Fifth:
Set VCPKG_ROOT environment variable. Ensure it's added to path. Make sure CMAKE installer correctly added CMAKE to path. 

