cat > code-examples/logging.sh << 'EOF'
#!/bin/bash
# Logging Example
# Demonstrates logging with different severity levels

LOG_LEVEL=${LOG_LEVEL:-INFO}
LOG_FILE="/tmp/library_$$.log"

# Logging functions
log_debug() {
    [ "$LOG_LEVEL" = "DEBUG" ] && {
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] [DEBUG] $*" | tee -a "$LOG_FILE"
    }
}

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $*" | tee -a "$LOG_FILE"
}

log_warn() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [WARN] $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $*" | tee -a "$LOG_FILE"
}

# Example usage
main() {
    log_info "Application started (LOG_LEVEL=$LOG_LEVEL)"
    log_debug "Debug information"
    log_info "Processing request"
    log_warn "Book not found in local catalog"
    log_error "Failed to connect to library"
    
    echo ""
    echo "Log file: $LOG_FILE"
}

main "$@"
EOF
chmod +x code-examples/logging.sh