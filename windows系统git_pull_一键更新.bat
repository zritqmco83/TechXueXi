@echo off
goto start




:color_red
echo [31m[*] %1[0m
exit /b 0

:color_green
echo [32m[*] %1[0m
exit /b 0

:color_yellow
echo [33m[*] %1[0m
exit /b 0

:color_blue
echo [34m[*] %1[0m
exit /b 0

:replace_dir
call :color_yellow 重要信息：
echo 此目录已作废，请转到 TechXuexi-master-clone 目录
echo 已自动为您复制 user 文件夹和 chrome 文件夹，此为用户数据，
echo 为保证无误您可再确认一下目录内是否已经有这两个文件夹
echo 您可将 TechXuexi-master-clone 里的所有内容（含.git文件夹）替换此文件夹的所有内容
exit /b 0


:start
set repo_url1=https://hub.fastgit.xyz/TechXueXi/TechXueXi.git
set repo_url2=https://hub.fastgit.org/TechXueXi/TechXueXi.git
set push_url=git@github.com:TechXueXi/TechXueXi.git

if exist "_unavailable_dir" (
	call :replace_dir
	goto end
)

:enter_file_path
set file_path=%~dp0
%file_path:~0,1%:
cd "%file_path%"

:test_have_git
call :color_green 检查此电脑有无安装git
git --version
if %ERRORLEVEL% equ 0 (
    goto have_git
) else (
    goto not_have_git
)

:have_git
:test_is_git_repo
call :color_green 检查此文件夹是否是git库
git remote -v
if %ERRORLEVEL% equ 0 (
    goto is_a_repo
) else (
    goto git_init
)

:is_a_repo
call :color_green 现在检查remote地址设置
git remote -v >nul 2>nul
git config remote.origin.url %repo_url1%
git config remote.origin.pushurl %push_url%
git remote -v
call :color_green 拉取远程代码（如在此卡住10秒以上可关闭重新打开）
git fetch
call :color_green 暂存修改
git stash save "pull_auto_stash"
call :color_green 更新...（如在此卡住10秒以上可关闭重新打开）
git pull --rebase
call :color_green 恢复修改
git stash pop
git checkout windows系统git_pull_一键更新.bat
call :color_green 完成
goto end


:git_init
call :color_green 下载最新代码到TechXuexi-master-clone文件夹
git clone -b master %repo_url1% TechXuexi-master-clone
if %ERRORLEVEL% equ 0 (
	call :color_green 复制用户数据文件...
	xcopy /E /V /K /I /Y /Q SourcePackages\user TechXuexi-master-clone\SourcePackages\user
	xcopy /E /V /K /I /Y /Q SourcePackages\chrome TechXuexi-master-clone\SourcePackages\chrome
	echo. >_unavailable_dir
	call :color_green 完成.
	call :replace_dir
	goto end
) else (
	call :color_red 出现错误！请反馈此问题：git_clone_出错
	goto end
)

:not_have_git
call :color_yellow 找不到git，请自行搜索安装git后再打开运行。
goto end




:end
set/p=按回车键退出程序...

