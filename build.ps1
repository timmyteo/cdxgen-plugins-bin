New-Item -ItemType Directory -Path plugins\osquery -Force
New-Item -ItemType Directory -Path plugins\dosai -Force
New-Item -ItemType Directory -Path plugins\trivy -Force

Invoke-WebRequest -Uri https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-win64.zip -UseBasicParsing -OutFile upx-4.2.4-win64.zip
Expand-Archive -Path upx-4.2.4-win64.zip -DestinationPath . -Force

Invoke-WebRequest -Uri https://github.com/osquery/osquery/releases/download/5.14.1/osquery-5.14.1.windows_x86_64.zip -UseBasicParsing -OutFile osquery-5.14.1.windows_x86_64.zip
Expand-Archive -Path osquery-5.14.1.windows_x86_64.zip -DestinationPath . -Force
copy "osquery-5.14.1.windows_x86_64\Program Files\osquery\osqueryi.exe" plugins\osquery\osqueryi-windows-amd64.exe
upx-4.2.4-win64\upx.exe -9 --lzma plugins\osquery\osqueryi-windows-amd64.exe
plugins\osquery\osqueryi-windows-amd64.exe --help

Invoke-WebRequest -Uri https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai.exe -UseBasicParsing -OutFile plugins/dosai/dosai-windows-amd64.exe

cd thirdparty\trivy
go build -ldflags "-H=windowsgui -s -w" -o build\trivy-windows-amd64.exe
..\..\upx-4.2.4-win64\upx.exe -9 --lzma build\trivy-windows-amd64.exe
copy build\* ..\..\plugins\trivy\
Remove-Item build -Recurse -Force
cd ..\..

Write-Host "Building Linux AMD64 package..."
Set-Location -Path packages/linux-amd64
Copy-Item -Path ../../plugins/* -Destination plugins/
npm install
npm pack
Set-Location -Path ../../

Remove-Item osquery-5.14.1.windows_x86_64 -Recurse -Force
Remove-Item osquery-5.14.1.windows_x86_64.zip -Recurse -Force
Remove-Item upx-4.2.4-win64 -Recurse -Force
Remove-Item upx-4.2.4-win64.zip -Recurse -Force
