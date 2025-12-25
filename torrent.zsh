#!/bin/zsh

# ==========================================
#  TMUX-ARIA2 TORRENT DOWNLOADER
#  A simple CLI wrapper for headless torrenting on macOS
# ==========================================

# --- CONFIGURATION ---
# Set your preferred download directory here
DEFAULT_DOWNLOAD_DIR="${HOME}/Downloads"
# ---------------------

function torrent() {
    # 1. Check dependencies
    if ! command -v tmux &> /dev/null || ! command -v aria2c &> /dev/null; then
        echo "❌ Error: This script requires 'tmux' and 'aria2'."
        echo "   Install them with: brew install tmux aria2"
        return 1
    fi

    # 2. Check input
    if [ -z "$1" ]; then
        echo "Usage: torrent <magnet-link|torrent-file>"
        return 1
    fi

    local INPUT_FILE="$1"
    local TARGET_DIR="$DEFAULT_DOWNLOAD_DIR"

    # Ensure download directory exists
    if [ ! -d "$TARGET_DIR" ]; then
        mkdir -p "$TARGET_DIR"
    fi
    
    # Resolve absolute path for .torrent files so tmux can find them
    if [[ -f "$INPUT_FILE" ]]; then
        INPUT_FILE="$(realpath "$INPUT_FILE")"
    fi

    local SESSION_NAME="dl_$(date +%s)"

    # 3. Launch download
    # -d: Detached (background)
    # --seed-time=0: Stop seeding immediately after download finishes
    # && rm: Delete source .torrent file only upon success
    # The session closes automatically when finished thanks to the command structure
    tmux new-session -d -s "$SESSION_NAME" "aria2c -d '$TARGET_DIR' --seed-time=0 '$INPUT_FILE' && rm -f '$INPUT_FILE'"

    echo "🚀 Download started in background session: $SESSION_NAME"
    echo "📂 Destination: $TARGET_DIR"
    echo "🗑️  Source .torrent file will be deleted upon completion."
}

function torrent_status() {
    # Find sessions starting with "dl_"
    local sessions=$(tmux ls 2>/dev/null | grep '^dl_' | cut -d: -f1)

    if [ -z "$sessions" ]; then
        echo "✅ No active downloads."
        return
    fi

    echo "📊 -- ACTIVE DOWNLOADS --"
    
    echo "$sessions" | while read -r session; do
        echo ""
        echo "🔹 Session: $session"
        # Capture the pane output to show progress bar (aria2 usually prints at the bottom)
        tmux capture-pane -t "$session" -p | grep -v "^$" | tail -n 2
    done
    echo ""
    echo "-------------------------"
}
