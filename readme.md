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
Seconds           : 16
Milliseconds      : 686
Ticks             : 166864491
TotalDays         : 0,000193130197916667
TotalHours        : 0,00463512475
TotalMinutes      : 0,278107485
TotalSeconds      : 16,6864491
TotalMilliseconds : 16686,4491
```
```julia
-> julia --project -e "using ProsperoChal; bench_proper(ARGS)"  1024
BenchmarkTools.Trial: 436 samples with 1 evaluation per sample.
 Range (min … max):   5.825 ms … 22.607 ms  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     10.972 ms              ┊ GC (median):    0.00%
 Time  (mean ± σ):   11.428 ms ±  2.674 ms  ┊ GC (mean ± σ):  1.71% ± 4.69%

              ▅▄█ ▁         ▂
  ▃▃▁▁▂▁▁▁▁▃▄▇█████▇▆██▇▇█▇██▇▇▆▆▅▃▃▄▂▂▂▃▃▃▃▂▃▂▃▃▃▁▁▁▂▁▂▃▂▃▂▃ ▃
  5.82 ms         Histogram: frequency by time        20.6 ms <

 Memory estimate: 2.01 MiB, allocs estimate: 257.
```
```julia
-> julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  1024
Profiler ran for 12.84 ms, capturing 933 events.

Host-side activity: calling CUDA APIs took 9.17 ms (71.42% of the trace)
┌──────────┬────────────┬───────┬────────────────────────────────────┬─────────────────────────┐
│ Time (%) │ Total time │ Calls │ Time distribution                  │ Name                    │
├──────────┼────────────┼───────┼────────────────────────────────────┼─────────────────────────┤
│   71.41% │    9.17 ms │     2 │   4.58 ms ± 6.48   (   0.0 ‥ 9.17) │ cuStreamSynchronize     │
│    5.06% │   650.2 µs │     1 │                                    │ cuMemcpyDtoHAsync       │
│    0.40% │    50.8 µs │     2 │   25.4 µs ± 16.55  (  13.7 ‥ 37.1) │ cuLaunchKernel          │
│    0.10% │    13.3 µs │     1 │                                    │ cuMemcpyHtoDAsync       │
│    0.06% │     7.7 µs │     3 │   2.57 µs ± 0.7    (   1.9 ‥ 3.3)  │ cuMemAllocFromPoolAsync │
│    0.01% │     1.0 µs │     1 │                                    │ cuCtxSetCurrent         │
│    0.00% │   200.0 ns │     1 │                                    │ cuDeviceGetCount        │
│    0.00% │   200.0 ns │     1 │                                    │ cuCtxGetDevice          │
└──────────┴────────────┴───────┴────────────────────────────────────┴─────────────────────────┘

Device-side activity: GPU was busy for 10.34 ms (80.55% of the trace)
┌──────────┬────────────┬───────┬───────────────────────────────────────────────────────────────────────────────────────────────
│ Time (%) │ Total time │ Calls │ Name                                                                                         ⋯
├──────────┼────────────┼───────┼───────────────────────────────────────────────────────────────────────────────────────────────
│   78.05% │   10.02 ms │     1 │ gpu_broadcast_kernel_cartesian(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIn ⋯
│    2.44% │  313.82 µs │     1 │ [copy device to pageable memory]                                                             ⋯
│    0.05% │    5.79 µs │     1 │ gpu_broadcast_kernel_linear(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndic ⋯
│    0.01% │     1.5 µs │     1 │ [copy pageable to device memory]                                                             ⋯
└──────────┴────────────┴───────┴───────────────────────────────────────────────────────────────────────────────────────────────
                                                                                                                1 column omitted
```