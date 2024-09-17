README
These are my personal scripts to make doing a clean installation of Windows easier. It keeps my work environment in one place that is easy to keep track of and manage. I kept it public as it may be useful to other people.
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

