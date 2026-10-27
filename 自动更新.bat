@echo off
chcp 65001 >nul
title 全网热榜 - 数据更新器
setlocal enabledelayedexpansion

REM ===== 可修改区 =====
REM 若本机 python 不在 PATH 中，把下面一行改成完整路径，例如：
REM set PY=C:/Users/Administrator/.workbuddy/binaries/python/versions/3.13.12/python.exe
set PY=python

REM 常驻模式的更新间隔（分钟）
set INTERVAL=30
REM ===================

cd /d "%~dp0"

echo ============================================
echo   全网热榜 · 数据更新器
echo   当前目录：%CD%
echo ============================================
echo.
echo   请选择运行方式：
echo     [1] 只更新一次（更新完自动退出）
echo     [2] 常驻自动更新，每 %INTERVAL% 分钟抓一次（推荐挂着）
echo     [3] 只更新一次并同时导出 hot-data.json
echo.
set /p CHOICE=请输入 1 / 2 / 3 后回车：

if "%CHOICE%"=="2" goto loop
if "%CHOICE%"=="3" goto oncejson

echo.
echo 正在更新一次...
"%PY%" update.py
if errorlevel 1 (
    echo.
    echo [失败] 没跑起来。请确认已安装 Python 3，或修改本文件里的 PY 变量为 python.exe 完整路径。
) else (
    echo.
    echo [完成] 数据已写入 hot-data.js，刷新浏览器即可看到最新热榜。
)
echo.
pause
goto :eof

:oncejson
echo.
echo 正在更新一次（并导出 JSON）...
"%PY%" update.py --json
if errorlevel 1 echo [失败] 请检查 Python 环境。
echo.
pause
goto :eof

:loop
echo.
echo 已进入常驻模式：每 %INTERVAL% 分钟自动更新一次。
echo 保持本窗口开启即可，按 Ctrl+C 或直接关闭窗口结束。
echo.
"%PY%" update.py --loop %INTERVAL%
pause
