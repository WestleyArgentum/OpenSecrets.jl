
# Loading OpenSecrets OpenData

Unfortunately it's not practicle to bundle all the OpenSecrets data along with this package. The bundles can be huge, which causes problems with git, and they're will always be more and more released.

So! This package works by recognizing and loading the [official bulk data bundles](http://www.opensecrets.org/resources/create/data.php). 


## Automatic detection

To have your data automatically detected by this package, simply unzip the bundles into this `data` directory. Depending on how you installed this package, this will be something like `~/.julia/v0.X/OpenSecrets/data` or `OpenSecrets.jl/data`.


## Load data from an external source

To load data stored somewhere else on your system, use `OpenSecrets.detect_data_sources(dir::String)`. After that (for the life of your session), OpenSecrets.jl will remember any data sets it found.

For example:

```julia
julia> using OpenSecrets

julia> OpenSecrets.detect_data_sources("/path/to/your/data/")
Dict{Any,Any} with 4 entries:
  0  => "/path/to/your/data/CampaignFin00"
  10 => "/path/to/your/data/CampaignFin10"
  98 => "/path/to/your/data/CampaignFin98"
  12 => "/path/to/your/data/CampaignFin12"
```
