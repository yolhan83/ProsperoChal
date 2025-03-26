## ProsperoChal is an attempt to the Prospero Challenge (https://www.mattkeeter.com/projects/prospero/) in julia.

### Prerequisites
1. Having Julia installed.
2. Having an Nvidia GPU compatible with CUDA.
3. Care a little about the Prospero Challenge ...

### Usage
Clone the repo

You may need to instantiate (install deps with `julia --project -e "using Pkg; Pkg.instantiate" `)

They are three ways to run this benchmark, 
1. run the app `julia --project -e "using ProsperoChal"  1024` and time it on your operating system. This will include the startup time of julia, the kernel compilations and the julia JIT time.
2. run `julia --project -e "using ProsperoChal; bench_proper(ARGS)"  1024`. This won't include the startup time of julia, the kernel compilations and the julia JIT time and will show you the best and worse times together with the mean and median times.
3. run `julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  1024`. This will profile the cuda kernels and show you the time it took to launch and run each kernel.

It should give you something like this,
```julia

-> Measure-Command { julia --project -e "using ProsperoChal"  1024}

Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 13
Milliseconds      : 958
Ticks             : 139582152
TotalDays         : 0,000161553416666667
TotalHours        : 0,003877282
TotalMinutes      : 0,23263692
TotalSeconds      : 13,9582152
TotalMilliseconds : 13958,2152
```
```julia
-> julia --project -e "using ProsperoChal; bench_proper(ARGS)"  1024
BenchmarkTools.Trial: 460 samples with 1 evaluation per sample.
 Range (min … max):   5.047 ms … 20.850 ms  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     11.164 ms              ┊ GC (median):    0.00%
 Time  (mean ± σ):   10.844 ms ±  3.217 ms  ┊ GC (mean ± σ):  1.78% ± 4.94%

   ▂             ▂ ▅   ▃▂▂▄ ▄▆▇▆█ ▁
  ▇█████▇█▃▃▃▃▃▅▅███▇██████████████▇▅▃▅▄▄▁▄▄▄▃▁▃▃▄▁▃▃▁▁▁▁▄▄▃▃ ▄
  5.05 ms         Histogram: frequency by time          20 ms <

 Memory estimate: 2.01 MiB, allocs estimate: 139.
```
```julia
-> julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  1024
Profiler ran for 23.74 ms, capturing 869 events.

Host-side activity: calling CUDA APIs took 19.75 ms (83.17% of the trace)
┌──────────┬────────────┬───────┬─────────────────────────────────────┬─────────────────────────┐
│ Time (%) │ Total time │ Calls │ Time distribution                   │ Name                    │
├──────────┼────────────┼───────┼─────────────────────────────────────┼─────────────────────────┤
│   83.18% │   19.75 ms │     3 │   6.58 ms ± 11.4   (   0.0 ‥ 19.75) │ cuStreamSynchronize     │
│    4.28% │    1.02 ms │     1 │                                     │ cuMemcpyDtoHAsync       │
│    0.25% │    60.0 µs │     1 │                                     │ cuMemsetD8Async         │
│    0.12% │    28.3 µs │     1 │                                     │ cuLaunchKernel          │
│    0.10% │    23.1 µs │     1 │                                     │ cuMemcpyHtoDAsync       │
│    0.02% │     5.5 µs │     2 │   2.75 µs ± 0.92   (   2.1 ‥ 3.4)   │ cuMemAllocFromPoolAsync │
│    0.00% │   900.0 ns │     1 │                                     │ cuCtxSetCurrent         │
│    0.00% │   100.0 ns │     1 │                                     │ cuDeviceGetCount        │
│    0.00% │   100.0 ns │     1 │                                     │ cuCtxGetDevice          │
└──────────┴────────────┴───────┴─────────────────────────────────────┴─────────────────────────┘

Device-side activity: GPU was busy for 21.29 ms (89.68% of the trace)
┌──────────┬────────────┬───────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ Time (%) │ Total time │ Calls │ Name                                                                                                                                                                                                                                                              ⋯
├──────────┼────────────┼───────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│   86.90% │   20.63 ms │     1 │ gpu_fkernel_(CompilerMetadata<DynamicSize, DynamicCheck, void, CartesianIndices<2, Tuple<OneTo<Int64>, OneTo<Int64>>>, NDRange<2, DynamicSize, DynamicSize, CartesianIndices<2, Tuple<OneTo<Int64>, OneTo<Int64>>>, CartesianIndices<2, Tuple<OneTo<Int64>, OneTo ⋯
│    2.67% │  635.06 µs │     1 │ [copy device to pageable memory]                                                                                                                                                                                                                                  ⋯
│    0.10% │   24.16 µs │     1 │ [set device memory]                                                                                                                                                                                                                                               ⋯
│    0.01% │    1.95 µs │     1 │ [copy pageable to device memory]                                                                                                                                                                                                                                  ⋯
└──────────┴────────────┴───────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                                                                                                                                                                                                                                                                                     1 column omitted
```
