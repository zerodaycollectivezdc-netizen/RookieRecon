#!/bin/bash

# -----------------------------------------------------------------------------------
# COLOR PALETTE
# -----------------------------------------------------------------------------------
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

NEON_GREEN='\033[1;92m'
CYAN='\033[1;96m'
MAGENTA='\033[1;95m'
YELLOW='\033[1;93m'
RED='\033[1;91m'
BLUE='\033[1;94m'
GREY='\033[0;90m'

ok()     { echo -e "${NEON_GREEN}[+]${RESET} $1"; }
info()   { echo -e "${CYAN}[*]${RESET} $1"; }
warn()   { echo -e "${YELLOW}[!]${RESET} $1"; }
err()    { echo -e "${RED}[-]${RESET} $1"; }
prompt() { read -p "$(echo -e "${MAGENTA}[?]${RESET} ${BOLD}$1${RESET}")" "$2"; }

clear

# -----------------------------------------------------------------------------------
# BANNER
# -----------------------------------------------------------------------------------
echo -e "${NEON_GREEN}"
cat << "EOF"
  ____             _    _      ____                     
 |  _ \ ___   ___ | | _(_) ___|  _ \ ___  ___ ___  _ __  
 | |_) / _ \ / _ \| |/ / |/ _ \ |_) / _ \/ __/ _ \| '_ \ 
 |  _ < (_) | (_) |   <| |  __/  _ <  __/ (_| (_) | | | |
 |_| \_\___/ \___/|_|\_\_|\___|_| \_\___|\___\___/|_| |_|
EOF
echo -e "${RESET}"

echo -e "${CYAN}${BOLD}===================================================================================================="
echo -e "              ${YELLOW}⚡ RECON AUTOMATION FRAMEWORK ⚡${CYAN}   |   Gobuster · Ffuf · Nikto"
echo -e "===================================================================================================="
echo -e "${GREY}                       Developed by Zero Day Collective"
echo -e "                 Follow Us On YouTube: ${BLUE}https://www.youtube.com/@zerodaycollective"
echo -e "${CYAN}====================================================================================================${RESET}"
echo ""
warn "For authorized security testing / CTF use only. Scan targets you own or have written permission to test."
echo ""

info "Checking recommended wordlists & tools...."
sudo apt update && sudo apt install -y dirb seclists gobuster ffuf nikto
echo ""

prompt "Enter the Target URL Or Host:- " target
clean_target=$(echo "$target" | sed -e 's/[^A-Za-z0-9.]/\_/g')

# -----------------------------------------------------------------------------------
# Shared wordlist picker (used by the "manual" branches of gobuster/ffuf)
# Sets the global WORDLIST variable, or returns 1 on invalid choice.
# -----------------------------------------------------------------------------------
pick_wordlist() {
    echo ""
    echo -e "${CYAN}${BOLD}====================================================================================================${RESET}"
    echo -e "${YELLOW}${BOLD}                                   AVAILABLE KALI LINUX WORDLISTS${RESET}"
    echo -e "${CYAN}${BOLD}====================================================================================================${RESET}"
    echo ""

    echo -e "${MAGENTA}--- DIRB WORDLISTS (for dir mode)---${RESET}"
    echo -e "${YELLOW}1)${RESET} common.txt                      -> /usr/share/wordlists/dirb/common.txt"
    echo -e "${YELLOW}2)${RESET} big.txt                         -> /usr/share/wordlists/dirb/big.txt"
    echo -e "${YELLOW}3)${RESET} small.txt                       -> /usr/share/wordlists/dirb/small.txt"
    echo -e "${YELLOW}4)${RESET} extensions_common.txt           -> /usr/share/wordlists/dirb/extensions_common.txt"
    echo -e "${YELLOW}5)${RESET} mutates.txt                     -> /usr/share/wordlists/dirb/mutates.txt"
    echo -e "${YELLOW}6)${RESET} ews.txt                         -> /usr/share/wordlists/dirb/others/ews.txt"
    echo -e "${YELLOW}7)${RESET} vulnhub.txt                     -> /usr/share/wordlists/dirb/others/vulnhub.txt"
    echo ""

    echo -e "${MAGENTA}--- DIRBUSTER WORDLISTS (for dir mode)---${RESET}"
    echo -e "${YELLOW}8)${RESET} directory-list-2.3-small.txt    -> /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt"
    echo -e "${YELLOW}9)${RESET} directory-list-2.3-medium.txt   -> /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
    echo -e "${YELLOW}10)${RESET} directory-list-2.3-big.txt     -> /usr/share/wordlists/dirbuster/directory-list-2.3-big.txt"
    echo -e "${YELLOW}11)${RESET} directory-list-1.0.txt         -> /usr/share/wordlists/dirbuster/directory-list-1.0.txt"
    echo -e "${YELLOW}12)${RESET} apache-user-enum-1.0.txt       -> /usr/share/wordlists/dirbuster/apache-user-enum-1.0.txt"
    echo -e "${YELLOW}13)${RESET} apache-user-enum-2.0.txt       -> /usr/share/wordlists/dirbuster/apache-user-enum-2.0.txt"
    echo ""

    echo -e "${MAGENTA}--- SECLISTS: WEB CONTENT (for dir mode)---${RESET}"
    echo -e "${YELLOW}14)${RESET} raft-small-directories.txt     -> /usr/share/seclists/Discovery/Web-Content/raft-small-directories.txt"
    echo -e "${YELLOW}15)${RESET} raft-medium-directories.txt    -> /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt"
    echo -e "${YELLOW}16)${RESET} raft-large-directories.txt     -> /usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt"
    echo -e "${YELLOW}17)${RESET} raft-small-files.txt           -> /usr/share/seclists/Discovery/Web-Content/raft-small-files.txt"
    echo -e "${YELLOW}18)${RESET} raft-medium-files.txt          -> /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt"
    echo -e "${YELLOW}19)${RESET} raft-large-files.txt           -> /usr/share/seclists/Discovery/Web-Content/raft-large-files.txt"
    echo -e "${YELLOW}20)${RESET} api-endpoints.txt              -> /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt"
    echo -e "${YELLOW}21)${RESET} combined_directories.txt       -> /usr/share/seclists/Discovery/Web-Content/combined_directories.txt"
    echo -e "${YELLOW}22)${RESET} common-backdoors.txt           -> /usr/share/seclists/Discovery/Web-Content/common-backdoors.txt"
    echo ""

    echo -e "${MAGENTA}--- SECLISTS: DNS & SUBDOMAINS (for dns/vhost mode)---${RESET}"
    echo -e "${YELLOW}23)${RESET} subdomains-top1million-5000.txt   -> /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt"
    echo -e "${YELLOW}24)${RESET} subdomains-top1million-20000.txt  -> /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt"
    echo -e "${YELLOW}25)${RESET} subdomains-top1million-110000.txt -> /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
    echo -e "${YELLOW}26)${RESET} bitquark-subdomains-top100000.txt -> /usr/share/seclists/Discovery/DNS/bitquark-subdomains-top100000.txt"
    echo -e "${YELLOW}27)${RESET} deepmagic.com-top50k-prefixes.txt -> /usr/share/seclists/Discovery/DNS/deepmagic.com-top50k-prefixes.txt"
    echo -e "${YELLOW}28)${RESET} namelist.txt                      -> /usr/share/seclists/Discovery/DNS/namelist.txt"
    echo ""

    echo -e "${MAGENTA}--- SECLISTS: PASSWORDS & FUZZING ---${RESET}"
    echo -e "${YELLOW}29)${RESET} rockyou.txt                       -> /usr/share/wordlists/rockyou.txt"
    echo -e "${YELLOW}30)${RESET} 10k-most-common.txt               -> /usr/share/seclists/Passwords/Common-Credentials/10k-most-common.txt"
    echo -e "${YELLOW}31)${RESET} xss-attacks.txt                   -> /usr/share/seclists/Fuzzing/XSS/xss-attacks.txt"
    echo -e "${YELLOW}32)${RESET} sqli.txt                          -> /usr/share/seclists/Fuzzing/SQLi/sqli.txt"
    echo -e "${CYAN}${BOLD}====================================================================================================${RESET}"

    prompt "Select a wordlist number [1-32]: " choice

    case "$choice" in
        1)  WORDLIST="/usr/share/wordlists/dirb/common.txt" ;;
        2)  WORDLIST="/usr/share/wordlists/dirb/big.txt" ;;
        3)  WORDLIST="/usr/share/wordlists/dirb/small.txt" ;;
        4)  WORDLIST="/usr/share/wordlists/dirb/extensions_common.txt" ;;
        5)  WORDLIST="/usr/share/wordlists/dirb/mutates.txt" ;;
        6)  WORDLIST="/usr/share/wordlists/dirb/others/ews.txt" ;;
        7)  WORDLIST="/usr/share/wordlists/dirb/others/vulnhub.txt" ;;
        8)  WORDLIST="/usr/share/wordlists/dirbuster/directory-list-2.3-small.txt" ;;
        9)  WORDLIST="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ;;
        10) WORDLIST="/usr/share/wordlists/dirbuster/directory-list-2.3-big.txt" ;;
        11) WORDLIST="/usr/share/wordlists/dirbuster/directory-list-1.0.txt" ;;
        12) WORDLIST="/usr/share/wordlists/dirbuster/apache-user-enum-1.0.txt" ;;
        13) WORDLIST="/usr/share/wordlists/dirbuster/apache-user-enum-2.0.txt" ;;
        14) WORDLIST="/usr/share/seclists/Discovery/Web-Content/raft-small-directories.txt" ;;
        15) WORDLIST="/usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt" ;;
        16) WORDLIST="/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt" ;;
        17) WORDLIST="/usr/share/seclists/Discovery/Web-Content/raft-small-files.txt" ;;
        18) WORDLIST="/usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt" ;;
        19) WORDLIST="/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt" ;;
        20) WORDLIST="/usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt" ;;
        21) WORDLIST="/usr/share/seclists/Discovery/Web-Content/combined_directories.txt" ;;
        22) WORDLIST="/usr/share/seclists/Discovery/Web-Content/common-backdoors.txt" ;;
        23) WORDLIST="/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt" ;;
        24) WORDLIST="/usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt" ;;
        25) WORDLIST="/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt" ;;
        26) WORDLIST="/usr/share/seclists/Discovery/DNS/bitquark-subdomains-top100000.txt" ;;
        27) WORDLIST="/usr/share/seclists/Discovery/DNS/deepmagic.com-top50k-prefixes.txt" ;;
        28) WORDLIST="/usr/share/seclists/Discovery/DNS/namelist.txt" ;;
        29) WORDLIST="/usr/share/wordlists/rockyou.txt" ;;
        30) WORDLIST="/usr/share/seclists/Passwords/Common-Credentials/10k-most-common.txt" ;;
        31) WORDLIST="/usr/share/seclists/Fuzzing/XSS/xss-attacks.txt" ;;
        32) WORDLIST="/usr/share/seclists/Fuzzing/SQLi/sqli.txt" ;;
        *)  err "Invalid option selected."; return 1 ;;
    esac
    return 0
}

# -----------------------------------------------------------------------------------
# GOBUSTER
# -----------------------------------------------------------------------------------
gobuster_function() {

    prompt "would you like to run our recommended command (Y/N):- " command_choice
    echo ""

    if [[ "${command_choice,,}" == "y" ]]; then

        echo -e "${CYAN}Which command would you like to choose?${RESET}"
        echo ""
        echo -e "${YELLOW}1)${RESET} gobuster dir -u <target> -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 40 -x php,txt,bak,html"
        echo -e "${YELLOW}2)${RESET} gobuster dir -u <target> -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -t 40 -x php,txt,bak,html"
        echo -e "${YELLOW}3)${RESET} gobuster dir -u <target> -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 30 -x aspx,asmx,config,zip,bak"
        echo -e "${YELLOW}4)${RESET} gobuster dns -d <domain> -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -t 50"
        echo -e "${YELLOW}5)${RESET} gobuster dir -u <target> -w /usr/share/wordlists/dirb/common.txt -t 30 -x php,txt,html"
        echo -e "${YELLOW}6)${RESET} gobuster vhost -u <target> -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt --append-domain"
        echo ""
        prompt "Enter Choice From 1-6:- " command_choice2

        case $command_choice2 in
            1)
                ok "Output saving to: dir_scan_${clean_target}.txt"
                gobuster dir -u "$target" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 40 -x php,txt,bak,html -o "dir_scan_${clean_target}.txt"
                ;;
            2)
                ok "Output saving to: raft_scan_${clean_target}.txt"
                gobuster dir -u "$target" -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -t 40 -x php,txt,bak,html -o "raft_scan_${clean_target}.txt"
                ;;
            3)
                ok "Output saving to: IIS_scan_${clean_target}.txt"
                gobuster dir -u "$target" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 30 -x aspx,asmx,config,zip,bak -o "IIS_scan_${clean_target}.txt"
                ;;
            4)
                prompt "Enter The Domain:- " target2
                clean_target2=$(echo "$target2" | sed -e 's/[^A-Za-z0-9.]/\_/g')
                ok "Output saving to: dns_scan_${clean_target2}.txt"
                gobuster dns --domain "$target2" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -t 50 -o "dns_scan_${clean_target2}.txt"
                ;;
            5)
                ok "Output saving to: common_scan_${clean_target}.txt"
                gobuster dir -u "$target" -w /usr/share/wordlists/dirb/common.txt -t 30 -x php,txt,html -o "common_scan_${clean_target}.txt"
                ;;
            6)
                ok "Output saving to: vhost_scan_${clean_target}.txt"
                gobuster vhost -u "$target" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt --append-domain -o "vhost_scan_${clean_target}.txt"
                ;;
            *)
                err "Invalid choice. Exiting function."
                return 1
                ;;
        esac
        return 0

    elif [[ "${command_choice,,}" == "n" ]]; then

        clear
        info "${BOLD}Let's craft the command manually...${RESET}"
        echo ""

        prompt "Enter The Target Hostname/URL/IP:- " manual_command
        prompt "Which Enumeration Mode Would You Like To Choose? (dir,dns,vhost):- " mode_enum
        echo ""

        pick_wordlist || return 1

        prompt "Enter threading (1-50):- " threading_manual

        if [[ "$mode_enum" == "dir" ]]; then
            prompt "Enter Extensions, no spaces (php,txt,html,json,bak,env,css,config,yaml,yml,log):- " extension_manual
            ok "Output saving to: gobuster_dir_${clean_target}.txt"
            gobuster dir -u "$manual_command" -w "$WORDLIST" -t "$threading_manual" -x "$extension_manual" -o "gobuster_dir_${clean_target}.txt"

        elif [[ "$mode_enum" == "dns" ]]; then
            ok "Output saving to: gobuster_dns_${clean_target}.txt"
            gobuster dns --domain "$manual_command" -w "$WORDLIST" -t "$threading_manual" -o "gobuster_dns_${clean_target}.txt"

        elif [[ "$mode_enum" == "vhost" ]]; then
            ok "Output saving to: gobuster_vhost_${clean_target}.txt"
            gobuster vhost -u "$manual_command" -w "$WORDLIST" -t "$threading_manual" --append-domain -o "gobuster_vhost_${clean_target}.txt"

        else
            err "Invalid enumeration mode. Exiting function."
            return 1
        fi
        return 0

    else
        err "Invalid choice (Y/N only). Exiting function."
        return 1
    fi
}

# -----------------------------------------------------------------------------------
# FFUF
# -----------------------------------------------------------------------------------
ffuf_function() {

    prompt "would you like to run our recommended command (Y/N):- " command_choice
    echo ""

    if [[ "${command_choice,,}" == "y" ]]; then

        echo -e "${CYAN}Which command would you like to choose?${RESET}"
        echo ""
        echo -e "${YELLOW}1)${RESET} ffuf -u <target>/FUZZ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -e .php,.txt,.bak,.html -t 40"
        echo -e "${YELLOW}2)${RESET} ffuf -u <target>/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -t 40"
        echo -e "${YELLOW}3)${RESET} ffuf -u <target>/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt -e .php,.bak,.zip,.old -t 40"
        echo -e "${YELLOW}4)${RESET} ffuf -u https://FUZZ.<domain>/ -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -t 50 (vhost/subdomain fuzzing)"
        echo -e "${YELLOW}5)${RESET} ffuf -u <target>/FUZZ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt -t 40 (API endpoint fuzzing)"
        echo -e "${YELLOW}6)${RESET} ffuf -u <target>?FUZZ=test_value -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt -t 40 (GET parameter fuzzing)"
        echo ""
        prompt "Enter Choice From 1-6:- " command_choice2

        case $command_choice2 in
            1)
                ok "Output saving to: ffuf_dir_${clean_target}.json"
                ffuf -u "${target}/FUZZ" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -e .php,.txt,.bak,.html -t 40 -o "ffuf_dir_${clean_target}.json"
                ;;
            2)
                ok "Output saving to: ffuf_raft_${clean_target}.json"
                ffuf -u "${target}/FUZZ" -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -t 40 -o "ffuf_raft_${clean_target}.json"
                ;;
            3)
                ok "Output saving to: ffuf_files_${clean_target}.json"
                ffuf -u "${target}/FUZZ" -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt -e .php,.bak,.zip,.old -t 40 -o "ffuf_files_${clean_target}.json"
                ;;
            4)
                prompt "Enter The Domain (no protocol, e.g. example.com):- " domain_manual
                clean_domain=$(echo "$domain_manual" | sed -e 's/[^A-Za-z0-9.]/\_/g')
                ok "Output saving to: ffuf_vhost_${clean_domain}.json"
                ffuf -u "https://FUZZ.${domain_manual}/" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -t 50 -o "ffuf_vhost_${clean_domain}.json"
                ;;
            5)
                ok "Output saving to: ffuf_api_${clean_target}.json"
                ffuf -u "${target}/FUZZ" -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt -t 40 -o "ffuf_api_${clean_target}.json"
                ;;
            6)
                ok "Output saving to: ffuf_param_${clean_target}.json"
                ffuf -u "${target}?FUZZ=test_value" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt -t 40 -o "ffuf_param_${clean_target}.json"
                ;;
            *)
                err "Invalid choice. Exiting function."
                return 1
                ;;
        esac
        return 0

    elif [[ "${command_choice,,}" == "n" ]]; then

        clear
        info "${BOLD}Let's craft the command manually...${RESET}"
        echo ""

        echo "Ffuf needs the literal word FUZZ in the URL to mark where the wordlist gets injected."
        echo "Examples: http://example.com/FUZZ   |   https://FUZZ.example.com/   |   http://example.com/page?FUZZ=1"
        prompt "Enter The Full URL With FUZZ In It:- " manual_url
        echo ""

        pick_wordlist || return 1

        prompt "Enter threading (1-50):- " threading_manual
        prompt "Enter Extensions, no spaces, comma separated with dots, or leave blank (.php,.txt,.bak):- " extension_manual
        prompt "Filter HTTP status codes to hide, or leave blank (e.g. 404):- " fc_manual

        FFUF_CMD=(ffuf -u "$manual_url" -w "$WORDLIST" -t "$threading_manual" -o "ffuf_manual_${clean_target}.json")

        if [[ -n "$extension_manual" ]]; then
            FFUF_CMD+=(-e "$extension_manual")
        fi
        if [[ -n "$fc_manual" ]]; then
            FFUF_CMD+=(-fc "$fc_manual")
        fi

        ok "Output saving to: ffuf_manual_${clean_target}.json"
        "${FFUF_CMD[@]}"
        return 0

    else
        err "Invalid choice (Y/N only). Exiting function."
        return 1
    fi
}

# -----------------------------------------------------------------------------------
# NIKTO
# -----------------------------------------------------------------------------------
nikto_function() {

    prompt "would you like to run our recommended command (Y/N):- " command_choice
    echo ""

    if [[ "${command_choice,,}" == "y" ]]; then

        echo -e "${CYAN}Which command would you like to choose?${RESET}"
        echo ""
        echo -e "${YELLOW}1)${RESET} nikto -h <target>                               (standard full scan)"
        echo -e "${YELLOW}2)${RESET} nikto -h <target> -ssl                          (force SSL/TLS)"
        echo -e "${YELLOW}3)${RESET} nikto -h <target> -Tuning 1,2,3,4,5,6,7,8,9,0   (all tuning categories)"
        echo -e "${YELLOW}4)${RESET} nikto -h <target> -evasion 1                    (basic IDS evasion encoding)"
        echo -e "${YELLOW}5)${RESET} nikto -h <target> -Plugins @@ALL                (run every available plugin)"
        echo ""
        prompt "Enter Choice From 1-5:- " command_choice2

        case $command_choice2 in
            1)
                ok "Output saving to: nikto_scan_${clean_target}.txt"
                nikto -h "$target" -o "nikto_scan_${clean_target}.txt"
                ;;
            2)
                ok "Output saving to: nikto_ssl_${clean_target}.txt"
                nikto -h "$target" -ssl -o "nikto_ssl_${clean_target}.txt"
                ;;
            3)
                ok "Output saving to: nikto_tuning_${clean_target}.txt"
                nikto -h "$target" -Tuning 1,2,3,4,5,6,7,8,9,0 -o "nikto_tuning_${clean_target}.txt"
                ;;
            4)
                ok "Output saving to: nikto_evasion_${clean_target}.txt"
                nikto -h "$target" -evasion 1 -o "nikto_evasion_${clean_target}.txt"
                ;;
            5)
                ok "Output saving to: nikto_allplugins_${clean_target}.txt"
                nikto -h "$target" -Plugins @@ALL -o "nikto_allplugins_${clean_target}.txt"
                ;;
            *)
                err "Invalid choice. Exiting function."
                return 1
                ;;
        esac
        return 0

    elif [[ "${command_choice,,}" == "n" ]]; then

        clear
        info "${BOLD}Let's craft the command manually...${RESET}"
        echo ""

        prompt "Enter The Target Hostname/URL/IP:- " manual_host
        prompt "Use SSL? (Y/N):- " ssl_manual
        prompt "Enter Tuning categories, or leave blank (e.g. 1,2,3,9):- " tuning_manual
        prompt "Enter a port, or leave blank for default:- " port_manual

        NIKTO_CMD=(nikto -h "$manual_host" -o "nikto_manual_${clean_target}.txt")

        if [[ "${ssl_manual,,}" == "y" ]]; then
            NIKTO_CMD+=(-ssl)
        fi
        if [[ -n "$tuning_manual" ]]; then
            NIKTO_CMD+=(-Tuning "$tuning_manual")
        fi
        if [[ -n "$port_manual" ]]; then
            NIKTO_CMD+=(-p "$port_manual")
        fi

        ok "Output saving to: nikto_manual_${clean_target}.txt"
        "${NIKTO_CMD[@]}"
        return 0

    else
        err "Invalid choice (Y/N only). Exiting function."
        return 1
    fi
}

# -----------------------------------------------------------------------------------
# MAIN MENU (loops so you can chain gobuster -> ffuf -> nikto without re-running)
# -----------------------------------------------------------------------------------
ran_gobuster=false
ran_ffuf=false
ran_nikto=false

main_menu() {
    echo ""
    echo -e "${CYAN}${BOLD}====================================================================================================${RESET}"
    echo -e "${NEON_GREEN}${BOLD}                                   SELECT YOUR WEAPON${RESET}"
    echo -e "${CYAN}${BOLD}====================================================================================================${RESET}"

    if [[ "$ran_gobuster" == false ]]; then
        echo -e "  ${YELLOW}1)${RESET} Gobuster   ${GREY}- fast Go-based directory / DNS / vhost brute forcer${RESET}"
    else
        echo -e "  ${GREY}1) Gobuster   - already run on this target ✓${RESET}"
    fi

    if [[ "$ran_ffuf" == false ]]; then
        echo -e "  ${YELLOW}2)${RESET} Ffuf       ${GREY}- flexible web fuzzer (dirs, files, vhosts, params)${RESET}"
    else
        echo -e "  ${GREY}2) Ffuf       - already run on this target ✓${RESET}"
    fi

    if [[ "$ran_nikto" == false ]]; then
        echo -e "  ${YELLOW}3)${RESET} Nikto      ${GREY}- web server vulnerability & misconfig scanner${RESET}"
    else
        echo -e "  ${GREY}3) Nikto      - already run on this target ✓${RESET}"
    fi

    echo -e "  ${YELLOW}4)${RESET} Quit       ${GREY}- all done, exit RookieRecon${RESET}"
    echo -e "${CYAN}${BOLD}====================================================================================================${RESET}"
    prompt "Enter Choice (1-4):- " user_choice

    case "$user_choice" in
        1)
            if [[ "$ran_gobuster" == true ]]; then
                warn "Gobuster already run. Re-running anyway..."
            fi
            gobuster_function && { ran_gobuster=true; echo -e "\n${NEON_GREEN}${BOLD}[✓] Gobuster scan complete.${RESET}"; }
            ;;
        2)
            if [[ "$ran_ffuf" == true ]]; then
                warn "Ffuf already run. Re-running anyway..."
            fi
            ffuf_function && { ran_ffuf=true; echo -e "\n${NEON_GREEN}${BOLD}[✓] Ffuf scan complete.${RESET}"; }
            ;;
        3)
            if [[ "$ran_nikto" == true ]]; then
                warn "Nikto already run. Re-running anyway..."
            fi
            nikto_function && { ran_nikto=true; echo -e "\n${NEON_GREEN}${BOLD}[✓] Nikto scan complete.${RESET}"; }
            ;;
        4)
            echo -e "\n${NEON_GREEN}${BOLD}[✓] Recon finished. Happy hacking, stay legal.${RESET}"
            return 1
            ;;
        *)
            err "Invalid choice. Pick 1-4."
            ;;
    esac

    echo ""
    prompt "Run another tool against the same target? (Y/N):- " again_choice
    if [[ "${again_choice,,}" != "y" ]]; then
        echo -e "\n${NEON_GREEN}${BOLD}[✓] Recon finished. Happy hacking, stay legal.${RESET}"
        return 1
    fi
    return 0
}

while main_menu; do
    :
done
