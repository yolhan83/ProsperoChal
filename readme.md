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
Milliseconds      : 637
Ticks             : 176377838
TotalDays         : 0,000204141016203704
TotalHours        : 0,00489938438888889
TotalMinutes      : 0,293963063333333
TotalSeconds      : 17,6377838
TotalMilliseconds : 17637,7838
```
```julia
-> julia --project -e "using ProsperoChal; bench_proper(ARGS)"  1024
BenchmarkTools.Trial: 17 samples with 1 evaluation per sample.
 Range (min … max):  279.231 ms … 436.716 ms  ┊ GC (min … max):  5.62% … 35.08%
 Time  (median):     286.940 ms               ┊ GC (median):     5.92%
 Time  (mean ± σ):   305.793 ms ±  49.401 ms  ┊ GC (mean ± σ):  10.66% ±  9.86%

  █▂
  ██▅█▅▁▁▁▅▁▅▁▁▅▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▅▅ ▁
  279 ms           Histogram: frequency by time          437 ms <

 Memory estimate: 183.15 MiB, allocs estimate: 9444645.
```
```julia
-> julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  1024
Profiler ran for 11.12 s, capturing 239 events.

Host-side activity: calling CUDA APIs took 5.56 ms (0.05% of the trace)
┌──────────┬────────────┬───────┬─────────────────────────────────────┬─────────────────────────┐
│ Time (%) │ Total time │ Calls │ Time distribution                   │ Name                    │    
├──────────┼────────────┼───────┼─────────────────────────────────────┼─────────────────────────┤    
│    0.03% │    2.88 ms │     2 │   1.44 ms ± 1.96   (  0.05 ‥ 2.83)  │ cuModuleGetFunction     │    
│    0.01% │   791.4 µs │     2 │  395.7 µs ± 155.42 ( 285.8 ‥ 505.6) │ cuMemcpyHtoDAsync       │    
│    0.01% │   663.3 µs │     2 │ 331.65 µs ± 211.21 ( 182.3 ‥ 481.0) │ cuModuleLoadDataEx      │    
│    0.00% │   513.2 µs │     1 │                                     │ cuMemcpyDtoHAsync       │    
│    0.00% │   380.8 µs │     1 │                                     │ cuMemHostAlloc          │    
│    0.00% │   162.7 µs │     2 │  81.35 µs ± 19.87  (  67.3 ‥ 95.4)  │ cuLaunchKernel          │    
│    0.00% │    69.7 µs │     4 │  17.42 µs ± 1.46   (  16.0 ‥ 19.3)  │ cuMemAllocFromPoolAsync │    
│    0.00% │    13.8 µs │     1 │                                     │ cuMemGetInfo            │    
│    0.00% │    11.0 µs │     2 │    5.5 µs ± 1.13   (   4.7 ‥ 6.3)   │ cuCtxSynchronize        │    
│    0.00% │     8.7 µs │     2 │   4.35 µs ± 3.89   (   1.6 ‥ 7.1)   │ cuStreamSynchronize     │    
│    0.00% │   900.0 ns │     2 │  450.0 ns ± 636.4  (   0.0 ‥ 900.0) │ cuMemPoolGetAttribute   │    
└──────────┴────────────┴───────┴─────────────────────────────────────┴─────────────────────────┘    

Device-side activity: GPU was busy for 91.98 ms (0.83% of the trace)
┌──────────┬────────────┬───────┬──────────────────────────────────────┬─────────────────────────────
│ Time (%) │ Total time │ Calls │ Time distribution                    │ Name                       ⋯
├──────────┼────────────┼───────┼──────────────────────────────────────┼─────────────────────────────
│    0.82% │   91.46 ms │     1 │                                      │ gpu_broadcast_kernel_carte ⋯
│    0.00% │  374.33 µs │     2 │ 187.17 µs ± 27.92  (167.42 ‥ 206.91) │ [copy pageable to device m ⋯
│    0.00% │   80.83 µs │     1 │                                      │ [copy device to pageable m ⋯
│    0.00% │   61.09 µs │     1 │                                      │ gpu_broadcast_kernel_carte ⋯
└──────────┴────────────┴───────┴──────────────────────────────────────┴─────────────────────────────
                                                                                     1 column omitted
      
```
