#Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n=allowGlobalConfirmation

$base_programms = "dropbox",
	"googlechrome",
	"adobereader",
	"firefox",
	"winrar",
	"notepadplusplus.install",
	"vlc",
	"ccleaner",
	"googledrive",
	"qbittorrent",
	"teamviewer",
	"anki",
	"virtualbox",
	"adwcleaner",
	"autohotkey",
	"spotify",
	"lightshot",
	"everything",
	"notion",
	"wox",
	"brave"


$programming = "python3",
	"pypy3",
	"pyenv-win",
	"nodejs",
	"yarn",
	"vscode",
	"jdk8",
	"filezilla",
	"slack" ,
	"git",
	"composer",
	"curl",
	"sqlite",
	"mysql",
	"docker-desktop",
	"microsoft-build-tools",
	"postman",
	"mingw",
	"openssl.light",
	"firacode",
	"vscode-settingssync",
	"make",
	"jetbrainstoolbox"


for ($i=0; $i -lt $programming.length; $i++) {
	echo Y | choco install + $programming_related[$i]
}

# Update python pip, setuptools
python -m pip install --upgrade pip
pip install --upgrade setuptools
pip install virtualenv

# Add pyenv to path
# [System.Environment]::SetEnvironmentVariable('PYENV',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
# [System.Environment]::SetEnvironmentVariable('PYENV_HOME',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
# [System.Environment]::SetEnvironmentVariable('path', $HOME + "\.pyenv\pyenv-win\bin;" + $HOME + "\.pyenv\pyenv-win\shims;" + $env:Path,"User")
