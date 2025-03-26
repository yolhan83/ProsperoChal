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
Seconds           : 17
Milliseconds      : 707
Ticks             : 177074956
TotalDays         : 0,000204947865740741
TotalHours        : 0,00491874877777778
TotalMinutes      : 0,295124926666667
TotalSeconds      : 17,7074956
TotalMilliseconds : 17707,4956
```
```julia
-> julia --project -e "using ProsperoChal; bench_proper(ARGS)"  1024
BenchmarkTools.Trial: 58 samples with 1 evaluation per sample.
 Range (min … max):  83.723 ms … 91.002 ms  ┊ GC (min … max): 0.00% … 7.05%
 Time  (median):     85.885 ms              ┊ GC (median):    1.56%
 Time  (mean ± σ):   86.199 ms ±  1.635 ms  ┊ GC (mean ± σ):  1.45% ± 1.28%

        ▃    ▃      ▁▆     █▁
  ▇▁▄▁▁▁█▇▄▇▄█▄▁▁▇▁▇██▄▇▄▁▄██▄▁▁▇▁▁▄▁▁▄▄▄▄▁▁▁▁▁▁▁▁▄▁▁▁▁▄▁▇▁▁▄ ▁
  83.7 ms         Histogram: frequency by time        90.2 ms <

 Memory estimate: 16.01 MiB, allocs estimate: 159.
```
```julia
-> julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  1024
Profiler ran for 101.67 ms, capturing 883 events.

Host-side activity: calling CUDA APIs took 92.43 ms (90.91% of the trace)
┌──────────┬────────────┬───────┬─────────────────────────────────────┬─────────────────────────┐
│ Time (%) │ Total time │ Calls │ Time distribution                   │ Name                    │
├──────────┼────────────┼───────┼─────────────────────────────────────┼─────────────────────────┤
│   90.91% │   92.43 ms │     2 │  46.21 ms ± 65.35  (   0.0 ‥ 92.43) │ cuStreamSynchronize     │
│    1.97% │     2.0 ms │     1 │                                     │ cuMemcpyDtoHAsync       │
│    0.05% │    48.9 µs │     1 │                                     │ cuLaunchKernel          │
│    0.03% │    33.3 µs │     2 │  16.65 µs ± 17.04  (   4.6 ‥ 28.7)  │ cuMemAllocFromPoolAsync │
│    0.02% │    17.1 µs │     1 │                                     │ cuMemcpyHtoDAsync       │
│    0.00% │     1.3 µs │     1 │                                     │ cuCtxSetCurrent         │
│    0.00% │   200.0 ns │     1 │                                     │ cuCtxGetDevice          │
│    0.00% │   100.0 ns │     1 │                                     │ cuDeviceGetCount        │
└──────────┴────────────┴───────┴─────────────────────────────────────┴─────────────────────────┘

Device-side activity: GPU was busy for 96.09 ms (94.52% of the trace)
┌──────────┬────────────┬───────┬───────────────────────────────────────────────────────────────────────────────────────────────
│ Time (%) │ Total time │ Calls │ Name                                                                                         ⋯
├──────────┼────────────┼───────┼───────────────────────────────────────────────────────────────────────────────────────────────
│   92.92% │   94.47 ms │     1 │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIn ⋯
│    1.60% │    1.62 ms │     1 │ [copy device to pageable memory]                                                             ⋯
│    0.00% │    1.06 µs │     1 │ [copy pageable to device memory]                                                             ⋯
└──────────┴────────────┴───────┴───────────────────────────────────────────────────────────────────────────────────────────────
                                                                                                                1 column omitted
```