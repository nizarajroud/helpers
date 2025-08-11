#!/bin/bash

# YouTube Downloader Setup and Interactive Script for WSL Ubuntu 22 with ZSH
# This script handles installation, setup, and provides fuzzy selection for downloads

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running in WSL
check_wsl() {
    if grep -qE "(Microsoft|WSL)" /proc/version 2>/dev/null; then
        log_success "Running in WSL environment"
        return 0
    else
        log_warning "Not running in WSL, but continuing anyway"
        return 1
    fi
}

# Step 1: Update system
update_system() {
    log_info "Step 1: Updating system packages..."
    if sudo apt update && sudo apt upgrade -y; then
        log_success "System updated successfully"
        return 0
    else
        log_error "Failed to update system"
        return 1
    fi
}

# Step 2: Install Python and pip
install_python() {
    log_info "Step 2: Installing Python and pip..."
    
    if command_exists python3 && command_exists pip3; then
        log_success "Python3 and pip3 already installed"
        python3 --version
        pip3 --version
        return 0
    fi
    
    if sudo apt install python3 python3-pip -y; then
        log_success "Python3 and pip3 installed successfully"
        python3 --version
        pip3 --version
        return 0
    else
        log_error "Failed to install Python3 and pip3"
        return 1
    fi
}

# Step 3: Install yt-dlp
install_ytdlp() {
    log_info "Step 3: Installing yt-dlp..."
    
    if command_exists yt-dlp; then
        log_success "yt-dlp already installed"
        yt-dlp --version
        return 0
    fi
    
    # Try pip3 installation first
    if pip3 install --user yt-dlp; then
        log_success "yt-dlp installed via pip3"
        # Add ~/.local/bin to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
            export PATH="$HOME/.local/bin:$PATH"
            log_info "Added ~/.local/bin to PATH"
        fi
        yt-dlp --version
        return 0
    else
        # Fallback to apt installation
        log_warning "pip3 installation failed, trying apt..."
        if sudo apt install yt-dlp -y; then
            log_success "yt-dlp installed via apt"
            yt-dlp --version
            return 0
        else
            log_error "Failed to install yt-dlp"
            return 1
        fi
    fi
}

# Step 4: Install ffmpeg
install_ffmpeg() {
    log_info "Step 4: Installing ffmpeg..."
    
    if command_exists ffmpeg; then
        log_success "ffmpeg already installed"
        ffmpeg -version | head -1
        return 0
    fi
    
    if sudo apt install ffmpeg -y; then
        log_success "ffmpeg installed successfully"
        ffmpeg -version | head -1
        return 0
    else
        log_error "Failed to install ffmpeg"
        return 1
    fi
}

# Step 5: Install fzf for fuzzy selection
install_fzf() {
    log_info "Step 5: Installing fzf for fuzzy selection..."
    
    if command_exists fzf; then
        log_success "fzf already installed"
        return 0
    fi
    
    if sudo apt install fzf -y; then
        log_success "fzf installed successfully"
        return 0
    else
        log_error "Failed to install fzf"
        return 1
    fi
}

# Step 6: Setup alias
setup_alias() {
    log_info "Step 6: Setting up convenient alias..."
    
    if grep -q "alias ytdl=" ~/.zshrc 2>/dev/null; then
        log_success "ytdl alias already exists in ~/.zshrc"
    else
        echo 'alias ytdl="yt-dlp"' >> ~/.zshrc
        log_success "Added ytdl alias to ~/.zshrc"
    fi
    
    # Create alias for current session
    alias ytdl="yt-dlp"
}

# Validate URL
validate_url() {
    local url="$1"
    if [[ $url =~ ^https?://(www\.)?(youtube\.com|youtu\.be) ]]; then
        return 0
    else
        return 1
    fi
}

# Get video info
get_video_info() {
    local url="$1"
    log_info "Getting video information..."
    yt-dlp --get-title --get-duration --get-filename "$url" 2>/dev/null || {
        log_error "Failed to get video information"
        return 1
    }
}

# Interactive download menu
download_menu() {
    local url="$1"
    local options=(
        "best_quality:Download best quality video"
        "720p:Download 720p video"
        "480p:Download 480p video"
        "audio_mp3:Download audio as MP3"
        "audio_best:Download best quality audio"
        "playlist:Download entire playlist"
        "subtitles:Download with subtitles"
        "thumbnail:Download with thumbnail"
        "custom_dir:Download to custom directory"
        "list_formats:List available formats"
    )
    
    log_info "Select download option:"
    printf '%s\n' "${options[@]}" | fzf --delimiter=':' --with-nth=2 --prompt="Select option: " | cut -d':' -f1
}

# Download functions
download_best_quality() {
    local url="$1"
    log_info "Downloading best quality video..."
    yt-dlp "$url"
}

download_720p() {
    local url="$1"
    log_info "Downloading 720p video..."
    yt-dlp -f "best[height<=720]" "$url"
}

download_480p() {
    local url="$1"
    log_info "Downloading 480p video..."
    yt-dlp -f "best[height<=480]" "$url"
}

download_audio_mp3() {
    local url="$1"
    log_info "Downloading audio as MP3..."
    yt-dlp -x --audio-format mp3 "$url"
}

download_audio_best() {
    local url="$1"
    log_info "Downloading best quality audio..."
    yt-dlp -x "$url"
}

download_playlist() {
    local url="$1"
    log_info "Downloading entire playlist..."
    yt-dlp "$url"
}

download_with_subtitles() {
    local url="$1"
    log_info "Downloading with subtitles..."
    yt-dlp --write-subs --sub-lang en "$url"
}

download_with_thumbnail() {
    local url="$1"
    log_info "Downloading with thumbnail..."
    yt-dlp --write-thumbnail "$url"
}

download_custom_dir() {
    local url="$1"
    echo -n "Enter download directory (default: ~/Downloads): "
    read -r custom_dir
    custom_dir="${custom_dir:-$HOME/Downloads}"
    
    # Create directory if it doesn't exist
    mkdir -p "$custom_dir"
    
    log_info "Downloading to $custom_dir..."
    yt-dlp -o "$custom_dir/%(title)s.%(ext)s" "$url"
}

list_formats() {
    local url="$1"
    log_info "Available formats:"
    yt-dlp -F "$url"
}

# Main download function
perform_download() {
    local url="$1"
    local choice="$2"
    
    case $choice in
        "best_quality") download_best_quality "$url" ;;
        "720p") download_720p "$url" ;;
        "480p") download_480p "$url" ;;
        "audio_mp3") download_audio_mp3 "$url" ;;
        "audio_best") download_audio_best "$url" ;;
        "playlist") download_playlist "$url" ;;
        "subtitles") download_with_subtitles "$url" ;;
        "thumbnail") download_with_thumbnail "$url" ;;
        "custom_dir") download_custom_dir "$url" ;;
        "list_formats") list_formats "$url" ;;
        *) log_error "Invalid choice" ;;
    esac
}

# Main setup function
setup_environment() {
    log_info "Starting YouTube downloader setup..."
    
    check_wsl
    
    # Run setup steps
    update_system || { log_error "Setup failed at system update"; exit 1; }
    install_python || { log_error "Setup failed at Python installation"; exit 1; }
    install_ytdlp || { log_error "Setup failed at yt-dlp installation"; exit 1; }
    install_ffmpeg || { log_error "Setup failed at ffmpeg installation"; exit 1; }
    install_fzf || { log_error "Setup failed at fzf installation"; exit 1; }
    setup_alias
    
    log_success "All components installed successfully!"
    log_info "Please run 'source ~/.zshrc' or restart your terminal to use the ytdl alias"
}

# Main interactive function
interactive_mode() {
    while true; do
        echo
        log_info "YouTube Downloader - Interactive Mode"
        echo "1. Download from URL"
        echo "2. Check installation status"
        echo "3. Update yt-dlp"
        echo "4. Exit"
        echo
        echo -n "Select option [1-4]: "
        read -r main_choice
        
        case $main_choice in
            1)
                echo -n "Enter YouTube URL: "
                read -r url
                
                if validate_url "$url"; then
                    log_success "Valid YouTube URL detected"
                    
                    # Show video info
                    if get_video_info "$url"; then
                        echo
                        # Get user choice via fzf
                        choice=$(download_menu "$url")
                        
                        if [[ -n "$choice" ]]; then
                            perform_download "$url" "$choice"
                        else
                            log_warning "No option selected"
                        fi
                    fi
                else
                    log_error "Invalid YouTube URL"
                fi
                ;;
            2)
                log_info "Checking installation status..."
                command_exists yt-dlp && log_success "yt-dlp: $(yt-dlp --version)" || log_error "yt-dlp: Not installed"
                command_exists ffmpeg && log_success "ffmpeg: Installed" || log_error "ffmpeg: Not installed"
                command_exists fzf && log_success "fzf: Installed" || log_error "fzf: Not installed"
                ;;
            3)
                log_info "Updating yt-dlp..."
                pip3 install --upgrade yt-dlp --user && log_success "yt-dlp updated" || log_error "Failed to update yt-dlp"
                ;;
            4)
                log_info "Goodbye!"
                exit 0
                ;;
            *)
                log_warning "Invalid option"
                ;;
        esac
    done
}

# Main script logic
main() {
    # Check if setup is needed
    if ! command_exists yt-dlp || ! command_exists ffmpeg || ! command_exists fzf; then
        log_warning "Some components are missing. Running setup..."
        setup_environment
        echo
        log_info "Setup complete! Starting interactive mode..."
        echo
    fi
    
    # If URL provided as argument, use it directly
    if [[ $# -gt 0 ]]; then
        url="$1"
        if validate_url "$url"; then
            get_video_info "$url"
            choice=$(download_menu "$url")
            [[ -n "$choice" ]] && perform_download "$url" "$choice"
        else
            log_error "Invalid YouTube URL provided"
            exit 1
        fi
    else
        # Run interactive mode
        interactive_mode
    fi
}

# Run main function with all arguments
main "$@"
