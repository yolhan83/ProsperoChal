## ProsperoChal is an attempt to the Prospero Challenge (https://www.mattkeeter.com/projects/prospero/) in julia.

### Prerequisites
1. Having Julia installed.
2. Having an Nvidia GPU compatible with CUDA.
3. Care a little about the Prospero Challenge ...

### Usage

They are three ways to run this benchmark, 
1. run the app `julia --project -e "using ProsperoChal"  prospero.vm 1024` and time it on your operating system. This will include the startup time of julia, the kernel compiltions and the julia JIT time.
2. run `julia --project -e "using ProsperoChal; bench_proper(ARGS)"  prospero.vm 1024`. This won't include the startup time of julia, the kernel compiltions and the julia JIT time and will show you the best and worse times together with the mean and median times.
3. run `julia --project -e "using ProsperoChal; profile_cuda(ARGS)"  prospero.vm 1024`. This will profile the cuda kernels and show you the time it took to launch and run each kernel.
