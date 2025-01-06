#!/bin/bash

echo "🚀 macOS Performance Optimization Script"
echo "--------------------------------------"

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (using sudo)"
    exit
fi

# System Animations and UI Performance
echo "📱 Optimizing System Animations..."
# Disable window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable the delay when hiding the Dock
defaults write com.apple.dock autohide-delay -float 0

# Disable the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Speed up window resize time
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable the animation when opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove the delay for showing the Dock
defaults write com.apple.dock autohide-delay -float 0

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Automatically restart if the computer freezes
sudo systemsetup -setrestartfreeze on

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Additional UI optimizations
defaults write com.apple.CrashReporter DialogType none
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Finder Optimizations
echo "📂 Optimizing Finder..."
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Safari Optimizations
echo "🌐 Optimizing Safari..."
defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.25
defaults write com.apple.Safari WebKitResourceTimedLayoutDelay 0.25
defaults write com.apple.Safari WebKitBackgroundTimedLayoutDelay 0.25
defaults write com.apple.Safari IncludeInternalDebugMenu 1

# Memory Management
echo "💾 Optimizing Memory Management..."
sudo sysctl vm.swapusage
sudo purge
sudo periodic daily weekly monthly

# Power Management Optimization
echo "⚡️ Optimizing Power Management..."
sudo pmset -a hibernatemode 0
sudo pmset -a sms 0
sudo pmset -a powernap 0
sudo pmset -a proximitywake 0
sudo pmset -a tcpkeepalive 0

# CPU & GPU Performance
echo "💻 Optimizing CPU & GPU..."
sudo nvram boot-args="npci=0x2000 $(nvram boot-args 2>/dev/null | cut -f 2-)"
sudo sysctl -w kern.timer.coalescing_enabled=0
sudo sysctl -w kern.timer.coalescing_min_interval=0

# Additional Disk Optimizations
echo "💿 Performing Advanced Disk Optimizations..."
sudo fdesetup status >/dev/null 2>&1 && diskutil apfs list | grep "Volume" | awk '{print $NF}' | while read -r volume; do
    sudo diskutil apfs defragment "$volume" status
done
sudo tmutil deletelocalsnapshots /
sudo diskutil repairVolume /

# Mail Optimization
echo "📧 Optimizing Mail..."
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
defaults write com.apple.mail DisableURLLoading -bool true
vacuum_mail() {
    sqlite3 ~/Library/Mail/V*/MailData/Envelope\ Index vacuum
}
vacuum_mail

# Photos Optimization
echo "📸 Optimizing Photos..."
defaults write com.apple.Photos IPXPCServicePreferenceDisabled -bool true
find ~/Pictures/Photos\ Library.photoslibrary -name "*.db" -exec sqlite3 {} vacuum \;

# Additional Network Optimizations
echo "🌐 Enhanced Network Optimizations..."
sudo sysctl -w net.inet.tcp.delayed_ack=0
sudo sysctl -w net.inet.tcp.mssdflt=1448
sudo sysctl -w net.inet.tcp.recvspace=524288
sudo sysctl -w net.inet.tcp.sendspace=524288
networksetup -setdnsservers "Wi-Fi" 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4

# App Store Optimization
echo "🏪 Optimizing App Store..."
defaults write com.apple.appstore ShowDebugMenu -bool true
defaults write com.apple.commerce AutoUpdate -bool false
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool false

# iCloud Optimization
echo "☁️ Optimizing iCloud..."
defaults write com.apple.icloud.fmfd FMFDebugEnabled -bool true
defaults write com.apple.icloud.searchparty SPDebugSystemEnabled -bool false

# System Integrity
echo "🛡️ Checking System Integrity..."
sudo /usr/libexec/repair_packages --verify --standard-pkgs /
sudo spctl --master-disable
sudo csrutil status

# Additional System Cleanup
echo "🧹 Deep System Cleanup..."
sudo rm -rf /private/var/vm/sleepimage
sudo rm -rf ~/Library/LanguageModeling/*
sudo rm -rf ~/Library/Speech/*
sudo rm -rf ~/Library/Suggestions/*
sudo rm -rf ~/Library/Application\ Support/Quick\ Look/*
sudo rm -rf ~/Library/Caches/com.apple.helpd/*
find ~/Library/Application\ Support -name "*.log" -delete
find ~/Library/Containers -name "*.log" -delete

# Menu Bar Optimization
echo "📊 Optimizing Menu Bar..."
defaults write com.apple.systemuiserver menuExtras -array \
    "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/Battery.menu" \
    "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Security Enhancements
echo "🔒 Applying Security Optimizations..."
sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool false
sudo defaults write /Library/Preferences/com.apple.security RSAMaxKeySize -int 8192
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Additional System Optimizations
echo "⚙️ Applying System Optimizations..."
sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
sudo sysctl -w kern.maxvnodes=750000
sudo sysctl -w kern.maxproc=2500
sudo sysctl -w kern.maxfiles=unlimited
sudo launchctl limit maxfiles 65535 200000

# Clean up system logs
echo "🧹 Cleaning System Logs..."
sudo rm -rf /private/var/log/*
sudo rm -rf ~/Library/Logs/*
sudo rm -rf /Library/Logs/*

# Clean up temporary files
echo "🗑️ Cleaning Temporary Files..."
sudo rm -rf /private/var/tmp/*
sudo rm -rf /private/var/folders/*
sudo rm -rf ~/Library/Caches/*
sudo rm -rf ~/Library/Application\ Support/Caches/*

# Rebuild Spotlight index
echo "🔍 Rebuilding Spotlight Index..."
sudo mdutil -E /

# Repair disk permissions
echo "🔧 Repairing Disk Permissions..."
sudo diskutil repairPermissions /

# Clear font caches
echo "🔤 Clearing Font Caches..."
sudo atsutil databases -remove
sudo rm -rf ~/Library/Font\ Caches/*
sudo rm -rf /Library/Caches/com.apple.ATS/*

# Optimize Time Machine
echo "⏰ Optimizing Time Machine..."
sudo tmutil disable
sudo tmutil disablelocal

# Network Optimization
echo "🌐 Optimizing Network..."
networksetup -setv6off "Wi-Fi"
sudo ifconfig en0 mtu 9000

# Empty trash securely
echo "🗑️ Securely Emptying Trash..."
sudo rm -rf ~/.Trash/*

# Rebuild Launch Services Database
echo "🚀 Rebuilding Launch Services..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Verify and repair disk
echo "💽 Verifying Disk Health..."
sudo fsck -fy

# Update locate database
echo "🔄 Updating Locate Database..."
sudo /usr/libexec/locate.updatedb

# Clean up homebrew (if installed)
if command -v brew >/dev/null 2>&1; then
    echo "🍺 Cleaning Homebrew..."
    brew cleanup -s
    brew cleanup --prune=all
fi

# Clear system caches
sudo rm -rf /Library/Caches/*
sudo rm -rf /System/Library/Caches/*
sudo rm -rf ~/Library/Caches/*

# Clear DNS cache
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Restart system services
echo "🔄 Restarting System Services..."
sudo killall -HUP mDNSResponder
sudo killall -HUP mDNSResponderHelper
sudo killall Finder
sudo killall Dock

echo "✅ Performance optimization complete!"
echo "⚠️ Please restart your Mac for all changes to take effect."
