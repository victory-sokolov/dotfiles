#!/bin/bash
################################################################################
# Spotify Playlist Downloader using spotDL
# Simple wrapper around spotDL with authentication guidance
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check dependencies
check_dependencies() {
    if ! command -v spotdl &> /dev/null; then
        echo -e "${RED}✗ spotdl not found${NC}"
        echo ""
        echo "Install it with:"
        echo "  pipx install spotdl"
        exit 1
    fi
}

# Get playlist URL
get_playlist_url() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║          SPOTIFY PLAYLIST DOWNLOADER                                       ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Enter Spotify playlist URL:"
    echo -e "${YELLOW}Example: https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M${NC}"
    echo ""
    read -r -p "Playlist URL: " playlist_url
    
    if [ -z "$playlist_url" ]; then
        echo -e "${RED}✗ No URL provided${NC}"
        exit 1
    fi
    
    echo "$playlist_url"
}

# Main
main() {
    # Check dependencies
    check_dependencies
    
    # Get playlist URL
    local playlist_url
    playlist_url=$(get_playlist_url)
    
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ DOWNLOADING PLAYLIST                                                       ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Try downloading with Python wrapper to fix asyncio event loop issues
    if ! python3 "$(dirname "$0")/spotdl-wrapper.py" "$playlist_url" 2>&1 | tee /tmp/spotdl_output.txt; then
        echo ""
        echo -e "${RED}✗ Download failed${NC}"
        
        # Check if it's an auth issue
        if grep -qi "authentication\|unauthorized\|couldn't get\|invalid" /tmp/spotdl_output.txt; then
            echo ""
            echo -e "${YELLOW}⚠ Authentication may be required${NC}"
            echo ""
            echo "Please authenticate with Spotify:"
            echo -e "${YELLOW}  spotdl --user-auth${NC}"
            echo ""
            echo "Then run this script again."
        fi
        
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ Download complete!                                                        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════════════╝${NC}"
}

# Run
main
