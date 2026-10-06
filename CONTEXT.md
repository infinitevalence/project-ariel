belicose:~/project-ariel/arieltune/crates/apu$ doas ./alpine-patch-script/bc250-enable-40cu-alpine.sh build
doas (infinitevalence@belicose.endlessdelve.com) password:
[+] Missing dependencies detected. Installing via apk: linux-lts-dev linux-headers build-base pahole elfutils-dev openssl-dev flex bison bc perl zstd-dev syslinux...
v3.24.2-85-g9af82541ae6 [http://mirrors.gigenet.com/alpinelinux/v3.24/main]
v3.24.2-85-g9af82541ae6 [http://mirrors.gigenet.com/alpinelinux/v3.24/community]
OK: 28650 distinct packages available
OK: 1088.5 MiB in 163 packages
[+] BC-250 (PCI ID 13fe) successfully verified.
[+] Found .config.
[+] Source already patched.
[+] Configuring kernel configuration...
[+] Kernel sources found, but .config or Module.symvers missing - finding locally...
[+] Supplemented .config + Module.symvers from system.
[+] Preparing kernel source tree...
[+] Building full kernel to generate Module.symvers...
[+] Compiling amdgpu module with 12 jobs (log: /tmp/bc250-40cu-build.log)...
[E] Compilation failed. Check build log at: /tmp/bc250-40cu-build.log
belicose:~/project-ariel/arieltune/crates/apu$ tail -n 100 /tmp/bc250-40cu-build.log
CC [M]  sdma_v4_4_2.o
CC [M]  sdma_v5_0.o
CC [M]  sdma_v5_2.o
CC [M]  sdma_v6_0.o
CC [M]  sdma_v7_0.o
CC [M]  amdgpu_mes.o
CC [M]  mes_v11_0.o
CC [M]  mes_v12_0.o
CC [M]  mes_userqueue.o
CC [M]  amdgpu_uvd.o
CC [M]  uvd_v5_0.o
CC [M]  uvd_v6_0.o
CC [M]  uvd_v7_0.o
CC [M]  amdgpu_vce.o
CC [M]  vce_v3_0.o
CC [M]  vce_v4_0.o
CC [M]  amdgpu_vcn.o
CC [M]  vcn_sw_ring.o
CC [M]  vcn_v1_0.o
CC [M]  vcn_v2_0.o
CC [M]  vcn_v2_5.o
CC [M]  vcn_v3_0.o
CC [M]  vcn_v4_0.o
CC [M]  vcn_v4_0_3.o
CC [M]  vcn_v4_0_5.o
CC [M]  vcn_v5_0_0.o
CC [M]  vcn_v5_0_1.o
CC [M]  amdgpu_jpeg.o
CC [M]  jpeg_v1_0.o
CC [M]  jpeg_v2_0.o
CC [M]  jpeg_v2_5.o
CC [M]  jpeg_v3_0.o
CC [M]  jpeg_v4_0.o
CC [M]  jpeg_v4_0_3.o
CC [M]  jpeg_v4_0_5.o
CC [M]  jpeg_v5_0_0.o
CC [M]  jpeg_v5_0_1.o
CC [M]  amdgpu_vpe.o
CC [M]  vpe_v6_1.o
CC [M]  amdgpu_umsch_mm.o
CC [M]  umsch_mm_v4_0.o
CC [M]  athub_v1_0.o
CC [M]  athub_v2_0.o
CC [M]  athub_v2_1.o
CC [M]  athub_v3_0.o
CC [M]  athub_v4_1_0.o
CC [M]  smuio_v9_0.o
CC [M]  smuio_v11_0.o
CC [M]  smuio_v11_0_6.o
CC [M]  smuio_v13_0.o
CC [M]  smuio_v13_0_3.o
CC [M]  smuio_v13_0_6.o
CC [M]  smuio_v14_0_2.o
CC [M]  amdgpu_reset.o
CC [M]  mca_v3_0.o
CC [M]  amdgpu_amdkfd.o
CC [M]  amdgpu_userq.o
CC [M]  amdgpu_amdkfd_fence.o
CC [M]  amdgpu_amdkfd_gpuvm.o
CC [M]  amdgpu_amdkfd_gfx_v8.o
CC [M]  amdgpu_amdkfd_gfx_v9.o
CC [M]  amdgpu_amdkfd_arcturus.o
CC [M]  amdgpu_amdkfd_aldebaran.o
CC [M]  amdgpu_amdkfd_gc_9_4_3.o
CC [M]  amdgpu_amdkfd_gfx_v10.o
CC [M]  amdgpu_amdkfd_gfx_v10_3.o
CC [M]  amdgpu_amdkfd_gfx_v11.o
CC [M]  amdgpu_amdkfd_gfx_v12.o
CC [M]  amdgpu_amdkfd_gfx_v7.o
CC [M]  amdgpu_cgs.o
CC [M]  amdgpu_job.o
CC [M]  amdgpu_acp.o
CC [M]  amdgpu_ioc32.o
CC [M]  amdgpu_atpx_handler.o
CC [M]  amdgpu_acpi.o
CC [M]  amdgpu_hmm.o
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
