#!/system/bin/sh
# Android Optimization Script - Refined for Available Settings

# Static variables for system settings
CPU_GOVERNOR=""
TCP_CONGESTION_ALGORITHM="bbr cubic reno bic"
DISK_SCHEDULER="none cfq bfq"

# Services to stop
SERVICES_TO_STOP="traced tombstoned statsd logd dumpstate ewlogd incidentd"

log_info() {
    echo "[$(date "+%H:%M:%S")] INFO: $1"
}

log_error() {
    echo "[$(date "+%H:%M:%S")] ERROR: $1"
}

write_value() {
    local file_path="$1"
    local value="$2"
    if [ -e "$file_path" ]; then
        if [ -w "$file_path" ]; then
            if echo "$value" > "$file_path" 2>/dev/null; then
                return 0
            else
                log_error "Failed to write '$value' to $file_path"
                return 1
            fi
        else
            log_error "File $file_path is not writable."
            return 1
        fi
    else
        return 1
    fi
}

select_first_available() {
    local file_path="$1"
    local options="$2"
    for option in $options; do
        if write_value "$file_path" "$option"; then
            log_info "Set $file_path to $option"
            return 0
        fi
    done
    log_error "No valid options available for $file_path"
    return 1
}

apply_initial_tweaks() {
    log_info "Applying initial optimizations"

    # Kernel Scheduler Tweaks
    write_value "/proc/sys/kernel/sched_schedstats" 0
    write_value "/proc/sys/kernel/sched_child_runs_first" 1
    write_value "/proc/sys/kernel/perf_cpu_time_max_percent" 5

    # Virtual Memory Tweaks
    write_value "/proc/sys/vm/vfs_cache_pressure" 50
    write_value "/proc/sys/vm/swappiness" 20
    write_value "/proc/sys/vm/dirty_ratio" 30
    write_value "/proc/sys/vm/dirty_background_ratio" 10
    write_value "/proc/sys/vm/dirty_expire_centisecs" 3000
    write_value "/proc/sys/vm/dirty_writeback_centisecs" 3000
    write_value "/proc/sys/vm/page-cluster" 0
    write_value "/proc/sys/vm/stat_interval" 10

    # Network Tweaks
    write_value "/proc/sys/net/ipv4/tcp_ecn" 1
    write_value "/proc/sys/net/ipv4/tcp_fastopen" 3
    write_value "/proc/sys/net/ipv4/tcp_syncookies" 0
    write_value "/proc/sys/net/ipv4/tcp_rmem" "4096 87380 16777216"
    write_value "/proc/sys/net/ipv4/tcp_wmem" "4096 65536 16777216"
    write_value "/proc/sys/net/core/rmem_max" 16777216
    write_value "/proc/sys/net/core/wmem_max" 16777216
    write_value "/proc/sys/net/core/rmem_default" 262144
    write_value "/proc/sys/net/core/wmem_default" 262144
    write_value "/proc/sys/net/core/netdev_max_backlog" 5000
    write_value "/proc/sys/net/ipv4/tcp_window_scaling" 1

    # Disable unnecessary printk logging
    write_value "/proc/sys/kernel/printk_devkmsg" "off"
    write_value "/proc/sys/kernel/printk" "0 0 0 0"

    log_info "Initial optimizations applied"
}

set_cpu_governor() {
    if [ -z "$CPU_GOVERNOR" ]; then
        log_info "CPU governor is not set as CPU_GOVERNOR is empty."
        return
    fi
    log_info "Setting CPU governor"
    for governor_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        select_first_available "$governor_path" "$CPU_GOVERNOR"
    done
}

set_tcp_congestion_algorithm() {
    log_info "Setting TCP congestion control algorithm"
    select_first_available "/proc/sys/net/ipv4/tcp_congestion_control" "$TCP_CONGESTION_ALGORITHM"
}

set_disk_parameters() {
    log_info "Setting disk scheduler and additional disk parameters"
    for device_path in /sys/block/*; do
        device_name=$(basename "$device_path")
        if [[ "$device_name" == loop* ]] || [[ "$device_name" == ram* ]] || [[ "$device_name" == zram* ]] || [[ "$device_name" == dm-* ]]; then
            continue
        fi

        # Set disk scheduler
        scheduler_path="$device_path/queue/scheduler"
        if [ -e "$scheduler_path" ]; then
            select_first_available "$scheduler_path" "$DISK_SCHEDULER"
        fi

        # Set additional disk settings
        queue_path="$device_path/queue"
        if [ -d "$queue_path" ]; then
            write_value "$queue_path/add_random" 0
            write_value "$queue_path/iostats" 0
            write_value "$queue_path/read_ahead_kb" 128
        fi
    done
}

stop_services() {
    log_info "Stopping unnecessary services"
    for service in $SERVICES_TO_STOP; do
        stop "$service" 2>/dev/null || log_error "Unable to stop $service"
    done
}

log_final_states() {
    log_info "Final CPU governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)"
    log_info "Final TCP congestion control: $(cat /proc/sys/net/ipv4/tcp_congestion_control 2>/dev/null)"
}

# Main script execution
log_info "Starting Android Optimization Script"
apply_initial_tweaks
set_cpu_governor
set_tcp_congestion_algorithm
set_disk_parameters
stop_services
log_final_states
log_info "Android Optimization Script Execution Complete"
