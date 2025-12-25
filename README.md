# tmux-aria2-cli

A minimalist, "fire-and-forget" torrent downloader for the command line.

It wraps **aria2** inside detached **tmux** sessions, allowing you to close your terminal, disconnect SSH, or sleep your machine without stopping your downloads. It is designed for a headless workflow (e.g., dropping files via SFTP and running the command).

## Features

* **Background Downloading:** Runs in a detached tmux session. Safe to close terminal/SSH.
* **Auto-Cleanup:** Automatically deletes the source `.torrent` file upon successful download.
* **Hit & Run:** Configured to stop seeding immediately after completion (`--seed-time=0`).
* **Status Dashboard:** Monitor all active downloads with a single command.
* **Zero Config:** Works out of the box with Zsh.

## Prerequisites

You need `tmux` and `aria2` installed.

**macOS (Homebrew):**
```bash
brew install tmux aria2
```

**Debian/Ubuntu:**
```bash
sudo apt install tmux aria2
```

## Installation

1.  Clone this repository or download the `torrent.zsh` file.
2.  Source it in your shell configuration (e.g., `~/.zshrc`).

Add this line to your `.zshrc`:

```bash
source /path/to/your/repo/torrent.zsh
```

3.  Reload your shell:
```bash
source ~/.zshrc
```

## Configuration

By default, downloads go to `~/Downloads`.
To change this, edit the `DEFAULT_DOWNLOAD_DIR` variable at the top of the `torrent.zsh` file:

```bash
# Inside torrent.zsh
DEFAULT_DOWNLOAD_DIR="/Volumes/SSD/Movies"
```

## Usage

### 1. Download a Torrent
Accepts `.torrent` files or Magnet links.

```bash
torrent my-movie.torrent
# or
torrent "magnet:?xt=urn:btih:..."
```
*The download starts in the background. The source `.torrent` file will be deleted automatically when finished.*

### 2. Check Status
See a snapshot of all active downloads (progress, speed, ETA).

```bash
torrent_status
```

### 3. Live Monitor
To create a real-time dashboard that updates every second:

```bash
watch -n 1 torrent_status
```
*(Press `Ctrl + C` to exit).*

## Contributing

Feel free to submit Pull Requests to improve the script!
