## ProsperoChal is an attempt to the Prospero Challenge (https://www.mattkeeter.com/projects/prospero/) in julia.

### Prerequisites
1. Having Julia installed.
2. Having an Nvidia GPU compatible with CUDA.
3. Care a little about the Prospero Challenge ...

### Usage
Clone the repo

You may need to instantiate (install deps with `julia --project -e "using Pkg; Pkg.instantiate" `)

They are three ways to run this benchmark, 
1. run the app `julia --project -e "using ProsperoChal"  1024` and time it on your operating system. This will include the startup time of julia, the kernel compiltions and the julia JIT time.
2. run `julia --project -e "using ProsperoChal; bench_proper(ARGS)"  1024`. This won't include the startup time of julia, the kernel compiltions and the julia JIT time and will show you the best and worse times together with the mean and median times.
3. run `julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  1024`. This will profile the cuda kernels and show you the time it took to launch and run each kernel.

It should give you something like this,
```julia

-> Measure-Command { julia --project -e "using ProsperoChal"  1024}


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 24
Milliseconds      : 784
Ticks             : 247847050
TotalDays         : 0,000286860011574074
TotalHours        : 0,00688464027777778
TotalMinutes      : 0,413078416666667
TotalSeconds      : 24,784705
TotalMilliseconds : 24784,705
```
```julia
-> julia --project -e "using ProsperoChal; bench_proper(ARGS)"  1024
BenchmarkTools.Trial: 63 samples with 1 evaluation per sample.
 Range (min … max):  78.232 ms … 138.553 ms  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     78.918 ms               ┊ GC (median):    0.00%
 Time  (mean ± σ):   80.246 ms ±   7.569 ms  ┊ GC (mean ± σ):  0.21% ± 1.12%

   █▄▃▁▆▁▃
  ▆███████▇▆▆▇▇▁▁▁▁▁▁▁▁▁▁▁▄▄▁▄▄▄▁▄▁▁▁▁▁▁▁▁▁▁▁▁▄▁▁▁▁▁▁▁▁▁▁▁▁▁▁▄ ▁
  78.2 ms         Histogram: frequency by time         85.2 ms <

 Memory estimate: 2.01 MiB, allocs estimate: 250.
```
```julia
-> julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  1024
Profiler ran for 83.05 ms, capturing 933 events.

Host-side activity: calling CUDA APIs took 79.64 ms (95.88% of the trace)
┌──────────┬────────────┬───────┬─────────────────────────────────────┬─────────────────────────┐
│ Time (%) │ Total time │ Calls │ Time distribution                   │ Name                    │
├──────────┼────────────┼───────┼─────────────────────────────────────┼─────────────────────────┤
│   95.88% │   79.63 ms │     2 │  39.82 ms ± 56.31  (   0.0 ‥ 79.63) │ cuStreamSynchronize     │
│    0.72% │   599.3 µs │     1 │                                     │ cuMemcpyDtoHAsync       │
│    0.06% │    51.1 µs │     2 │  25.55 µs ± 14.92  (  15.0 ‥ 36.1)  │ cuLaunchKernel          │
│    0.04% │    32.6 µs │     3 │  10.87 µs ± 11.92  (   3.2 ‥ 24.6)  │ cuMemAllocFromPoolAsync │
│    0.02% │    14.6 µs │     1 │                                     │ cuMemcpyHtoDAsync       │
│    0.00% │     1.1 µs │     1 │                                     │ cuCtxSetCurrent         │
│    0.00% │   200.0 ns │     1 │                                     │ cuCtxGetDevice          │
│    0.00% │   200.0 ns │     1 │                                     │ cuDeviceGetCount        │
└──────────┴────────────┴───────┴─────────────────────────────────────┴─────────────────────────┘

Device-side activity: GPU was busy for 80.88 ms (97.39% of the trace)
┌──────────┬────────────┬───────┬───────────────────────────────────────────────────────────────────────────────────────────────
│ Time (%) │ Total time │ Calls │ Name                                                                                         ⋯
├──────────┼────────────┼───────┼───────────────────────────────────────────────────────────────────────────────────────────────
│   97.27% │   80.79 ms │     1 │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIn ⋯
│    0.11% │   92.86 µs │     1 │ [copy device to pageable memory]                                                             ⋯
│    0.00% │    1.34 µs │     1 │ gpu_broadcast_kernel_linear(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndic ⋯
│    0.00% │    1.02 µs │     1 │ [copy pageable to device memory]                                                             ⋯
└──────────┴────────────┴───────┴───────────────────────────────────────────────────────────────────────────────────────────────
                                                                                                                1 column omitted
```