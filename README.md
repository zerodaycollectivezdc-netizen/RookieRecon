# RookieRecon

A beginner-friendly Bash wrapper around **Gobuster**, **Ffuf**, and **Nikto** —
built for rookies who know *what* these tools do but don't yet have the
muscle memory for flags, wordlist paths, and syntax.

RookieRecon walks you through each tool with a guided menu: pick a
battle-tested recommended command, or get prompted step-by-step to build
your own. Run as many tools as you like against the same target in one
session — no need to restart the script between Gobuster, Ffuf, and Nikto.

## Features

- 🎯 **Three tools, one script** — Gobuster (dir/dns/vhost), Ffuf (fuzzing), Nikto (vuln scanning)
- ⚡ **Recommended mode** — curated, ready-to-run commands for common scan types
- 🛠️ **Manual mode** — interactive prompts for wordlist, threads, extensions, filters, etc.
- 🔁 **Chainable scans** — run Gobuster, then Ffuf, then Nikto against the same target without re-launching
- 📋 **32 built-in wordlist shortcuts** — dirb, dirbuster, and SecLists paths, picked by number instead of typed by hand
- 💾 **Auto-saved output** — every scan writes its results to a named file in the working directory
- 🎨 **Colorized terminal UI** — clear success/info/warning/error styling so output is easy to scan

## Requirements

- Linux (tested on Kali Linux)
- [gobuster](https://github.com/OJ/gobuster)
- [ffuf](https://github.com/ffuf/ffuf)
- [nikto](https://github.com/sullo/nikto)
- `dirb` wordlists and [SecLists](https://github.com/danielmiessler/SecLists) installed at their default Kali paths

## Usage

chmod +x RookieRecon.sh

./RookieRecon.sh


1. Enter your target URL/host.
2. Pick a tool from the menu (Gobuster, Ffuf, Nikto).
3. Choose **recommended** (Y) for a preset command, or **manual** (N) to build your own.
4. After the scan finishes, choose whether to run another tool against the same target.

## ⚠️ Authorized Use Only

RookieRecon automates real scanning traffic against real hosts. Only run it
against targets you **own** or have **explicit written permission** to test
(CTF boxes, your own lab, or an authorized pentest engagement). Unauthorized
scanning may be illegal in your jurisdiction.

## Credits

Developed by **Zero Day Collective**
📺 [YouTube: @zerodaycollective](https://www.youtube.com/@zerodaycollective)

## License

Add your license of choice here (MIT is a common pick for tools like this).
