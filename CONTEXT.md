LD [M]  amdgpu.o
MODPOST Module.symvers
WARNING: /tmp/bc250-40cu-build/linux-6.18.54/Module.symvers is missing.
Modules may not have dependencies or modversions.
You may get many unresolved symbol errors.
You can set KBUILD_MODPOST_WARN=1 to turn errors into warning
if you want to proceed at your own risk.
ERROR: modpost: "kobj_sysfs_ops" [amdgpu.ko] undefined!
ERROR: modpost: "drm_writeback_queue_job" [amdgpu.ko] undefined!
ERROR: modpost: "memmove" [amdgpu.ko] undefined!
ERROR: modpost: "drm_dp_atomic_find_time_slots" [amdgpu.ko] undefined!
ERROR: modpost: "drm_dsc_compute_rc_parameters" [amdgpu.ko] undefined!
ERROR: modpost: "ttm_bo_vm_close" [amdgpu.ko] undefined!
ERROR: modpost: "drm_print_memory_stats" [amdgpu.ko] undefined!
ERROR: modpost: "__drm_crtc_commit_free" [amdgpu.ko] undefined!
ERROR: modpost: "drm_syncobj_get_handle" [amdgpu.ko] undefined!
ERROR: modpost: "pm_genpd_add_device" [amdgpu.ko] undefined!
WARNING: modpost: suppressed 1054 unresolved symbol warnings because there were too many)
make[3]: *** [/tmp/bc250-40cu-build/linux-6.18.54/scripts/Makefile.modpost:147: Module.symvers] Error 1
make[2]: *** [/tmp/bc250-40cu-build/linux-6.18.54/Makefile:2000: modpost] Error 2
make[1]: *** [/tmp/bc250-40cu-build/linux-6.18.54/Makefile:248: __sub-make] Error 2
make[1]: Leaving directory '/tmp/bc250-40cu-build/linux-6.18.54/drivers/gpu/drm/amd/amdgpu'
make: *** [Makefile:248: __sub-make] Error 2
make: Leaving directory '/tmp/bc250-40cu-build/linux-6.18.54'
