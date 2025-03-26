## ProsperoChal is an attempt to the Prospero Challenge (https://www.mattkeeter.com/projects/prospero/) in julia.

### Prerequisites
1. Having Julia installed.
2. Having an Nvidia GPU compatible with CUDA.
3. Care a little about the Prospero Challenge ...

### Usage
Clone the repo

They are three ways to run this benchmark, 
1. run the app `julia --project -e "using ProsperoChal"  prospero.vm 1024` and time it on your operating system. This will include the startup time of julia, the kernel compiltions and the julia JIT time.
2. run `julia --project -e "using ProsperoChal; bench_proper(ARGS)"  prospero.vm 1024`. This won't include the startup time of julia, the kernel compiltions and the julia JIT time and will show you the best and worse times together with the mean and median times.
3. run `julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  prospero.vm 1024`. This will profile the cuda kernels and show you the time it took to launch and run each kernel.

It should give you something like this,
```julia

-> Measure-Command { julia --project -e "using ProsperoChal"  prospero.vm 1024}


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 17
Milliseconds      : 608
Ticks             : 176088615
TotalDays         : 0,000203806267361111
TotalHours        : 0,00489135041666667
TotalMinutes      : 0,293481025
TotalSeconds      : 17,6088615
TotalMilliseconds : 17608,8615


-> julia --project -e "using ProsperoChal; bench_proper(ARGS)"  prospero.vm 1024
BenchmarkTools.Trial: 4 samples with 1 evaluation per sample.
 Range (min … max):  1.354 s …   1.489 s  ┊ GC (min … max):  2.57% … 12.64%
 Time  (median):     1.453 s              ┊ GC (median):    12.50%
 Time  (mean ± σ):   1.437 s ± 57.925 ms  ┊ GC (mean ± σ):  10.27% ±  5.06%

  █                                      █   █            █  
  █▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█▁▁▁█▁▁▁▁▁▁▁▁▁▁▁▁█ ▁
  1.35 s         Histogram: frequency by time        1.49 s <

 Memory estimate: 209.19 MiB, allocs estimate: 10307650.
-> julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  prospero.vm 1024
Profiler ran for 12.6 s, capturing 480669 events.

Host-side activity: calling CUDA APIs took 1.24 s (9.84% of the trace)
┌──────────┬────────────┬───────┬───────────────────────────────────────┬─────────────────────────┐
│ Time (%) │ Total time │ Calls │ Time distribution                     │ Name                    │
├──────────┼────────────┼───────┼───────────────────────────────────────┼─────────────────────────┤
│    4.86% │  612.34 ms │  7872 │  77.79 µs ± 732.93 (   1.2 ‥ 39622.2) │ cuMemAllocFromPoolAsync │
│    2.28% │  287.17 ms │  6459 │  44.46 µs ± 614.6  (   3.3 ‥ 15843.0) │ cuLaunchKernel          │
│    0.92% │  116.49 ms │  1408 │  82.73 µs ± 810.99 (   2.8 ‥ 15574.8) │ cuMemcpyHtoDAsync       │
│    0.06% │    7.38 ms │     9 │ 819.48 µs ± 316.99 ( 225.3 ‥ 1095.0)  │ cuModuleLoadDataEx      │
│    0.01% │     1.7 ms │     9 │  188.8 µs ± 331.75 (  51.6 ‥ 1068.6)  │ cuModuleGetFunction     │
│    0.00% │   564.3 µs │     1 │                                       │ cuMemcpyDtoHAsync       │
│    0.00% │   501.7 µs │     1 │                                       │ cuMemHostAlloc          │
│    0.00% │   130.3 µs │     1 │                                       │ cuMemPoolTrimTo         │
│    0.00% │    62.1 µs │    12 │   5.17 µs ± 1.07   (   3.5 ‥ 8.1)     │ cuCtxSynchronize        │
│    0.00% │    53.2 µs │     6 │   8.87 µs ± 4.72   (   2.1 ‥ 15.1)    │ cuMemGetInfo            │
│    0.00% │    18.4 µs │     3 │   6.13 µs ± 5.97   (   1.6 ‥ 12.9)    │ cuStreamSynchronize     │
│    0.00% │     2.7 µs │    12 │  225.0 ns ± 213.73 (   0.0 ‥ 800.0)   │ cuMemPoolGetAttribute   │
│    0.00% │   200.0 ns │     2 │  100.0 ns ± 141.42 (   0.0 ‥ 200.0)   │ cuDeviceGetCount        │
└──────────┴────────────┴───────┴───────────────────────────────────────┴─────────────────────────┘

Device-side activity: GPU was busy for 1.4 s (11.10% of the trace)
┌──────────┬────────────┬───────┬───────────────────────────────────────┬─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ Time (%) │ Total time │ Calls │ Time distribution                     │ Name                                                                                                                       ⋯
├──────────┼────────────┼───────┼───────────────────────────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│    4.37% │  551.02 ms │  2094 │ 263.14 µs ± 331.63 ( 41.28 ‥ 2934.54) │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndices<2, Tuple<OneTo<Int64>, O ⋯
│    3.69% │  464.68 ms │  2565 │ 181.16 µs ± 283.58 ( 36.99 ‥ 2671.95) │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndices<2, Tuple<OneTo<Int64>, O ⋯
│    1.66% │  208.84 ms │   784 │ 266.37 µs ± 318.91 ( 38.43 ‥ 2912.55) │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndices<2, Tuple<OneTo<Int64>, O ⋯
│    0.51% │   63.68 ms │   383 │ 166.27 µs ± 213.52 ( 33.95 ‥ 2004.22) │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndices<2, Tuple<OneTo<Int64>, O ⋯
│    0.50% │   63.45 ms │   362 │ 175.28 µs ± 252.48 ( 33.28 ‥ 2733.58) │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndices<2, Tuple<OneTo<Int64>, O ⋯
│    0.36% │   45.02 ms │   270 │ 166.76 µs ± 172.62 ( 35.23 ‥ 1122.6)  │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndices<2, Tuple<OneTo<Int64>, O ⋯
│    0.01% │    1.74 ms │  1408 │   1.24 µs ± 8.4    (  0.29 ‥ 220.99)  │ [copy pageable to device memory]                                                                                           ⋯
│    0.00% │  293.27 µs │     1 │                                       │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndices<2, Tuple<OneTo<Int64>, O ⋯
│    0.00% │   159.2 µs │     1 │                                       │ [copy device to pageable memory]                                                                                           ⋯
└──────────┴────────────┴───────┴───────────────────────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                         
```
