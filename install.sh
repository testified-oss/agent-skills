#!/usr/bin/env bash
#
# Agent Skills Installer
# Installs skills, rules, and commands to Cursor, OpenCode, and VSCode/Copilot
#
# Usage:
#   ./install.sh                    # Interactive mode
#   ./install.sh --cursor --symlink # Install to Cursor with symlinks
#   ./install.sh --all --copy       # Install to all IDEs with copies
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script directory (where the repo is)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup directory
BACKUP_BASE="${HOME}/.agent-skills-backup"

# Target directories
CURSOR_SKILLS="${HOME}/.cursor/skills"
CURSOR_RULES="${HOME}/.cursor/rules"
CURSOR_AGENTS="${HOME}/.cursor/agents"
OPENCODE_DIR="${HOME}/.config/opencode"
OPENCODE_AGENTS="${OPENCODE_DIR}/agents"
VSCODE_DIR="${HOME}/.vscode"

# Installation options (set via args or prompts)
INSTALL_CURSOR=false
INSTALL_OPENCODE=false
INSTALL_VSCODE=false
INSTALL_MODE=""  # "symlink" or "copy"
INSTALL_SKILLS=true
INSTALL_RULES=true
INSTALL_COMMANDS=true
INTERACTIVE=true

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

print_header() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}           Agent Skills Installer v1.0.0                     ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

die() {
    log_error "$1"
    exit 1
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Prompt user for yes/no
prompt_yn() {
    local prompt="$1"
    local default="${2:-y}"
    local answer
    
    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi
    
    read -rp "$prompt" answer
    answer="${answer:-$default}"
    
    [[ "${answer,,}" == "y" || "${answer,,}" == "yes" ]]
}

# Prompt user to select from options
prompt_select() {
    local prompt="$1"
    shift
    local options=("$@")
    local selection
    
    echo -e "${BOLD}$prompt${NC}"
    for i in "${!options[@]}"; do
        echo "  $((i+1)). ${options[$i]}"
    done
    
    while true; do
        read -rp "Enter choice (1-${#options[@]}): " selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && ((selection >= 1 && selection <= ${#options[@]})); then
            return $((selection - 1))
        fi
        echo "Invalid selection. Please try again."
    done
}

# -----------------------------------------------------------------------------
# Detection Functions
# -----------------------------------------------------------------------------

detect_cursor() {
    [[ -d "${HOME}/.cursor" ]]
}

detect_opencode() {
    [[ -d "${HOME}/.config/opencode" ]] || command_exists opencode
}

detect_vscode() {
    [[ -d "${HOME}/.vscode" ]] || command_exists code
}

# -----------------------------------------------------------------------------
# Backup Functions
# -----------------------------------------------------------------------------

create_backup() {
    local timestamp
    timestamp=$(date +"%Y-%m-%dT%H-%M-%S")
    local backup_dir="${BACKUP_BASE}/${timestamp}"
    
    log_info "Creating backup at ${backup_dir}"
    mkdir -p "$backup_dir"
    
    # Backup Cursor
    if [[ "$INSTALL_CURSOR" == true ]]; then
        if [[ -d "$CURSOR_SKILLS" ]]; then
            mkdir -p "${backup_dir}/cursor"
            cp -rL "$CURSOR_SKILLS" "${backup_dir}/cursor/skills" 2>/dev/null || true
        fi
        if [[ -d "$CURSOR_RULES" ]]; then
            mkdir -p "${backup_dir}/cursor"
            cp -rL "$CURSOR_RULES" "${backup_dir}/cursor/rules" 2>/dev/null || true
        fi
    fi
    
    # Backup OpenCode
    if [[ "$INSTALL_OPENCODE" == true ]]; then
        if [[ -f "${OPENCODE_DIR}/AGENTS.md" ]]; then
            mkdir -p "${backup_dir}/opencode"
            cp "${OPENCODE_DIR}/AGENTS.md" "${backup_dir}/opencode/" 2>/dev/null || true
        fi
        if [[ -d "$OPENCODE_AGENTS" ]]; then
            mkdir -p "${backup_dir}/opencode"
            cp -rL "$OPENCODE_AGENTS" "${backup_dir}/opencode/agents" 2>/dev/null || true
        fi
    fi
    
    log_success "Backup created"
}

# -----------------------------------------------------------------------------
# Installation Functions
# -----------------------------------------------------------------------------

link_or_copy() {
    local src="$1"
    local dest="$2"
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    
    # Remove existing (file, symlink, or directory)
    if [[ -e "$dest" || -L "$dest" ]]; then
        rm -rf "$dest"
    fi
    
    if [[ "$INSTALL_MODE" == "symlink" ]]; then
        ln -s "$src" "$dest"
    else
        cp -r "$src" "$dest"
    fi
}

install_to_cursor() {
    log_info "Installing to Cursor..."
    
    mkdir -p "$CURSOR_SKILLS"
    mkdir -p "$CURSOR_RULES"
    
    # Install skills
    if [[ "$INSTALL_SKILLS" == true ]]; then
        for skill_dir in "${SCRIPT_DIR}"/skills/*/; do
            if [[ -d "$skill_dir" ]]; then
                local skill_name
                skill_name=$(basename "$skill_dir")
                # Skip if it's just a README
                if [[ -f "${skill_dir}SKILL.md" ]]; then
                    link_or_copy "$skill_dir" "${CURSOR_SKILLS}/${skill_name}"
                    log_success "Installed skill: ${skill_name}"
                fi
            fi
        done
    fi
    
    # Install rules
    if [[ "$INSTALL_RULES" == true ]]; then
        for rule_file in "${SCRIPT_DIR}"/rules/*.mdc; do
            if [[ -f "$rule_file" ]]; then
                local rule_name
                rule_name=$(basename "$rule_file")
                link_or_copy "$rule_file" "${CURSOR_RULES}/${rule_name}"
                log_success "Installed rule: ${rule_name}"
            fi
        done
    fi
    
    # Install commands/agents
    if [[ "$INSTALL_COMMANDS" == true ]]; then
        mkdir -p "$CURSOR_AGENTS"
        for cmd_file in "${SCRIPT_DIR}"/commands/*.md; do
            if [[ -f "$cmd_file" ]]; then
                local cmd_name
                cmd_name=$(basename "$cmd_file")
                # Skip README
                if [[ "$cmd_name" != "README.md" ]]; then
                    link_or_copy "$cmd_file" "${CURSOR_AGENTS}/${cmd_name}"
                    log_success "Installed command: ${cmd_name}"
                fi
            fi
        done
    fi
    
    log_success "Cursor installation complete"
}

install_to_opencode() {
    log_info "Installing to OpenCode..."
    
    mkdir -p "$OPENCODE_DIR"
    mkdir -p "$OPENCODE_AGENTS"
    
    # Aggregate rules into AGENTS.md
    if [[ "$INSTALL_RULES" == true ]]; then
        local agents_md="${OPENCODE_DIR}/AGENTS.md"
        
        cat > "$agents_md" << 'EOF'
# Project Rules

This file contains aggregated rules from agent-skills repository.
Auto-generated by install.sh - do not edit directly.

EOF
        
        for rule_file in "${SCRIPT_DIR}"/rules/*.mdc; do
            if [[ -f "$rule_file" ]]; then
                local rule_name
                rule_name=$(basename "$rule_file" .mdc)
                echo "## ${rule_name}" >> "$agents_md"
                echo "" >> "$agents_md"
                # Extract content after frontmatter
                sed -n '/^---$/,/^---$/d; p' "$rule_file" >> "$agents_md"
                echo "" >> "$agents_md"
            fi
        done
        
        log_success "Created AGENTS.md with aggregated rules"
    fi
    
    # Install commands/agents
    if [[ "$INSTALL_COMMANDS" == true ]]; then
        for cmd_file in "${SCRIPT_DIR}"/commands/*.md; do
            if [[ -f "$cmd_file" ]]; then
                local cmd_name
                cmd_name=$(basename "$cmd_file")
                if [[ "$cmd_name" != "README.md" ]]; then
                    link_or_copy "$cmd_file" "${OPENCODE_AGENTS}/${cmd_name}"
                    log_success "Installed agent: ${cmd_name}"
                fi
            fi
        done
    fi
    
    log_success "OpenCode installation complete"
}

install_to_vscode() {
    log_info "Installing to VSCode/Copilot..."
    
    # VSCode/Copilot uses .github/copilot-instructions.md per-project
    # For user-global, we create a reference file
    mkdir -p "$VSCODE_DIR"
    
    if [[ "$INSTALL_RULES" == true ]]; then
        local instructions_file="${VSCODE_DIR}/copilot-instructions.md"
        
        cat > "$instructions_file" << 'EOF'
# Copilot Custom Instructions

This file contains aggregated instructions from agent-skills repository.
Copy relevant sections to your project's .github/copilot-instructions.md

EOF
        
        for rule_file in "${SCRIPT_DIR}"/rules/*.mdc; do
            if [[ -f "$rule_file" ]]; then
                local rule_name
                rule_name=$(basename "$rule_file" .mdc)
                echo "## ${rule_name}" >> "$instructions_file"
                echo "" >> "$instructions_file"
                sed -n '/^---$/,/^---$/d; p' "$rule_file" >> "$instructions_file"
                echo "" >> "$instructions_file"
            fi
        done
        
        log_success "Created reference instructions at ${instructions_file}"
        log_warn "Note: Copy to .github/copilot-instructions.md in your projects"
    fi
    
    log_success "VSCode/Copilot installation complete"
}

# -----------------------------------------------------------------------------
# Interactive Setup
# -----------------------------------------------------------------------------

interactive_setup() {
    print_header
    
    echo -e "${BOLD}Detected IDEs:${NC}"
    detect_cursor && echo -e "  ${GREEN}✓${NC} Cursor" || echo -e "  ${RED}✗${NC} Cursor"
    detect_opencode && echo -e "  ${GREEN}✓${NC} OpenCode" || echo -e "  ${RED}✗${NC} OpenCode"
    detect_vscode && echo -e "  ${GREEN}✓${NC} VSCode" || echo -e "  ${RED}✗${NC} VSCode"
    echo ""
    
    # Select IDEs
    echo -e "${BOLD}Select IDEs to install to:${NC}"
    if detect_cursor; then
        prompt_yn "  Install to Cursor?" "y" && INSTALL_CURSOR=true
    fi
    if detect_opencode; then
        prompt_yn "  Install to OpenCode?" "y" && INSTALL_OPENCODE=true
    fi
    if detect_vscode; then
        prompt_yn "  Install to VSCode/Copilot?" "y" && INSTALL_VSCODE=true
    fi
    
    if [[ "$INSTALL_CURSOR" == false && "$INSTALL_OPENCODE" == false && "$INSTALL_VSCODE" == false ]]; then
        die "No IDEs selected. Exiting."
    fi
    
    echo ""
    
    # Select installation mode
    echo -e "${BOLD}Installation mode:${NC}"
    echo "  1. Symlink (recommended) - Changes in repo auto-update everywhere"
    echo "  2. Copy - Static snapshot, manual updates required"
    local mode_choice
    read -rp "Enter choice (1-2) [1]: " mode_choice
    mode_choice="${mode_choice:-1}"
    
    if [[ "$mode_choice" == "1" ]]; then
        INSTALL_MODE="symlink"
    else
        INSTALL_MODE="copy"
    fi
    
    echo ""
    
    # Select components
    echo -e "${BOLD}Select components to install:${NC}"
    prompt_yn "  Install skills?" "y" && INSTALL_SKILLS=true || INSTALL_SKILLS=false
    prompt_yn "  Install rules?" "y" && INSTALL_RULES=true || INSTALL_RULES=false
    prompt_yn "  Install commands?" "y" && INSTALL_COMMANDS=true || INSTALL_COMMANDS=false
    
    echo ""
    
    # Confirm
    echo -e "${BOLD}Installation Summary:${NC}"
    echo "  Mode: ${INSTALL_MODE}"
    echo "  IDEs: $([ "$INSTALL_CURSOR" == true ] && echo "Cursor ")$([ "$INSTALL_OPENCODE" == true ] && echo "OpenCode ")$([ "$INSTALL_VSCODE" == true ] && echo "VSCode")"
    echo "  Components: $([ "$INSTALL_SKILLS" == true ] && echo "skills ")$([ "$INSTALL_RULES" == true ] && echo "rules ")$([ "$INSTALL_COMMANDS" == true ] && echo "commands")"
    echo ""
    
    prompt_yn "Proceed with installation?" "y" || die "Installation cancelled."
}

# -----------------------------------------------------------------------------
# Argument Parsing
# -----------------------------------------------------------------------------

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --cursor)
                INSTALL_CURSOR=true
                INTERACTIVE=false
                ;;
            --opencode)
                INSTALL_OPENCODE=true
                INTERACTIVE=false
                ;;
            --vscode|--copilot)
                INSTALL_VSCODE=true
                INTERACTIVE=false
                ;;
            --all)
                INSTALL_CURSOR=true
                INSTALL_OPENCODE=true
                INSTALL_VSCODE=true
                INTERACTIVE=false
                ;;
            --symlink)
                INSTALL_MODE="symlink"
                ;;
            --copy)
                INSTALL_MODE="copy"
                ;;
            --skills-only)
                INSTALL_SKILLS=true
                INSTALL_RULES=false
                INSTALL_COMMANDS=false
                ;;
            --rules-only)
                INSTALL_SKILLS=false
                INSTALL_RULES=true
                INSTALL_COMMANDS=false
                ;;
            --commands-only)
                INSTALL_SKILLS=false
                INSTALL_RULES=false
                INSTALL_COMMANDS=true
                ;;
            --no-backup)
                NO_BACKUP=true
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                die "Unknown option: $1"
                ;;
        esac
        shift
    done
    
    # If non-interactive and no mode specified, default to symlink
    if [[ "$INTERACTIVE" == false && -z "$INSTALL_MODE" ]]; then
        INSTALL_MODE="symlink"
    fi
}

show_help() {
    cat << EOF
Agent Skills Installer

Usage: ./install.sh [OPTIONS]

IDE Selection:
  --cursor          Install to Cursor
  --opencode        Install to OpenCode
  --vscode          Install to VSCode/Copilot
  --all             Install to all detected IDEs

Installation Mode:
  --symlink         Use symlinks (auto-updates from repo)
  --copy            Copy files (static snapshot)

Component Selection:
  --skills-only     Only install skills
  --rules-only      Only install rules
  --commands-only   Only install commands

Other:
  --no-backup       Skip backup of existing configs
  -h, --help        Show this help message

Examples:
  ./install.sh                          # Interactive mode
  ./install.sh --cursor --symlink       # Cursor with symlinks
  ./install.sh --all --copy             # All IDEs with copies
  ./install.sh --opencode --rules-only  # OpenCode, rules only

EOF
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    parse_args "$@"
    
    # Verify we're in the right directory
    if [[ ! -d "${SCRIPT_DIR}/skills" || ! -d "${SCRIPT_DIR}/rules" ]]; then
        die "Cannot find skills/ or rules/ directory. Are you running from the repo root?"
    fi
    
    if [[ "$INTERACTIVE" == true ]]; then
        interactive_setup
    else
        print_header
    fi
    
    # Create backup unless disabled
    if [[ "${NO_BACKUP:-false}" != true ]]; then
        create_backup
    fi
    
    # Run installations
    [[ "$INSTALL_CURSOR" == true ]] && install_to_cursor
    [[ "$INSTALL_OPENCODE" == true ]] && install_to_opencode
    [[ "$INSTALL_VSCODE" == true ]] && install_to_vscode
    
    echo ""
    echo -e "${GREEN}${BOLD}Installation complete!${NC}"
    echo ""
    echo "Next steps:"
    [[ "$INSTALL_CURSOR" == true ]] && echo "  - Restart Cursor to load new configurations"
    [[ "$INSTALL_OPENCODE" == true ]] && echo "  - Restart OpenCode to load new configurations"
    [[ "$INSTALL_VSCODE" == true ]] && echo "  - Copy ${VSCODE_DIR}/copilot-instructions.md to your projects"
    echo ""
    if [[ "$INSTALL_MODE" == "symlink" ]]; then
        echo "You're using symlink mode. Run 'git pull' in this repo to update everywhere."
    else
        echo "You're using copy mode. Re-run this script to apply updates."
    fi
}

main "$@"
