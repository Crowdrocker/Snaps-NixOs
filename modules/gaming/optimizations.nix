# Gaming Optimizations
# System-wide performance tweaks for gaming

{ config, pkgs, lib, ... }:

{
  # ============================================================================
  # KERNEL PARAMETERS
  # ============================================================================
  
  boot.kernelParams = [
    # AMD GPU optimizations
    "amd_pstate=active"
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.gpu_recovery=1"
    
    # Disable CPU mitigations for performance (optional, less secure)
    # "mitigations=off"
    
    # Transparent Huge Pages
    "transparent_hugepage=always"
  ];

  # ============================================================================
  # SYSCTL OPTIMIZATIONS
  # ============================================================================
  
  boot.kernel.sysctl = {
    # File system optimizations
    "fs.inotify.max_user_watches" = 524288;
    "fs.file-max" = 2097152;
    
    # Network optimizations for online gaming
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.core.rmem_default" = 1048576;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 1048576;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
    
    # Memory management
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    
    # Reduce latency
    "kernel.sched_latency_ns" = 4000000;
    "kernel.sched_min_granularity_ns" = 500000;
    "kernel.sched_wakeup_granularity_ns" = 50000;
  };

  # ============================================================================
  # ZRAM SWAP
  # ============================================================================
  
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  # ============================================================================
  # HARDWARE OPTIMIZATIONS
  # ============================================================================
  
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      
      extraPackages = with pkgs; [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      
      extraPackages32 = with pkgs.pkgsi686Linux; [
        amdvlk
      ];
    };
  };

  # ============================================================================
  # ENVIRONMENT VARIABLES
  # ============================================================================
  
  environment.sessionVariables = {
    # AMD GPU
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "gpl,nggc";
    
    # Mesa optimizations
    mesa_glthread = "true";
    
    # DXVK
    DXVK_ASYNC = "1";
    DXVK_STATE_CACHE_PATH = "/run/media/wehttamsnaps/LINUXDRIVE-1/.dxvk-cache";
    
    # VKD3D
    VKD3D_CONFIG = "dxr11,dxr";
    
    # Enable FreeSync/VRR
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
  };

  # ============================================================================
  # CPU FREQUENCY SCALING
  # ============================================================================
  
  powerManagement = {
    cpuFreqGovernor = "performance";
    
    # Enable powertop auto-tune (optional, for laptops)
    # powertop.enable = true;
  };

  # ============================================================================
  # UDEV RULES
  # ============================================================================
  
  services.udev.extraRules = ''
    # Set I/O scheduler for SSDs
    ACTION=="add|change", KERNEL=="sd[a-z]|nvme[0-9]n[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
    
    # Set I/O scheduler for HDDs
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    
    # Increase USB polling rate for gaming mice
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="*", ATTR{idProduct}=="*", ATTR{bInterfaceClass}=="03", ATTR{bInterfaceSubClass}=="01", ATTR{bInterfaceProtocol}=="02", ATTR{power/autosuspend}="-1"
  '';

  # ============================================================================
  # SYSTEMD OPTIMIZATIONS
  # ============================================================================
  
  systemd = {
    # Reduce shutdown timeout
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    
    # User service optimizations
    user.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };

  # ============================================================================
  # ENABLE CORECTRL FOR GPU CONTROL
  # ============================================================================
  
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  # ============================================================================
  # LACT (Linux AMDGPU Controller)
  # ============================================================================
  
  # LACT provides GUI for AMD GPU control
  # Install via: nix-shell -p lact
  # Then run: sudo systemctl enable --now lactd
  
  systemd.packages = [ pkgs.lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
}