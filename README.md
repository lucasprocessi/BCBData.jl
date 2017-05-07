# BCBData

[![Build Status](https://travis-ci.org/lucasprocessi/BCBData.jl.svg?branch=master)](https://travis-ci.org/lucasprocessi/BCBData.jl)

A Julia package to read Brazilian Central Bank (BCB) time series data. 
Gets data from SGS database <[https://www3.bcb.gov.br/sgspub/](https://www3.bcb.gov.br/sgspub/)> by consuming its web service.


**Installation**: 
```julia
julia> Pkg.clone("https://github.com/lucasprocessi/BCBData.jl.git")
```

**Requires**:

curl needs to be installed before using the package. 
For installation instructions, please see <[https://curl.haxx.se/download.html](https://curl.haxx.se/download.html)>. 

## Usage

To use `BCBData` we must first get a time series ID in [SGS](https://www3.bcb.gov.br/sgspub/). 
For instance, Brazilian Broad National Consumer Price Index (IPCA) has an internal ID of 433.
`readData()` returns two arrays: the first has strings that represent dates, the second holds its corresponding values.

```julia

julia> using BCBData

julia> d,v = readData(433,              # time series ID 
					  Date(2016,1,1),   # start date
					  Date(2017,1,1))   # end date
(String["1/2016","2/2016","3/2016","4/2016","5/2016","6/2016","7/2016","8/2016","9/2016","10/2016","11/2016","12/2016","1/2017"],[1.27,0.9,0.43,0.61,0.78,0.35,0.52,0.44,0.08,0.26,0.18,0.3,0.38])

julia> d
13-element Array{String,1}:
 "1/2016"
 "2/2016"
 "3/2016"
 "4/2016"
 "5/2016"
 "6/2016"
 "7/2016"
 "8/2016"
 "9/2016"
 "10/2016"
 "11/2016"
 "12/2016"
 "1/2017"

julia> v
13-element Array{Float64,1}:
 1.27
 0.9
 0.43
 0.61
 0.78
 0.35
 0.52
 0.44
 0.08
 0.26
 0.18
 0.3
 0.38

```

If you are behind a proxy, proxy configurations can be set by passing a `ProxyConfig` instance to `readData()`:

```julia
	
	julia> using BCBData

	julia> config = ProxyConfig("http://yourproxy.com", # host 
						8080,                    # port
						"myuser",                # user
						"mypwd")                 # password

	julia> d,v = readData(433, Date(2016,1,1), Date(2017,1,1), config)
	(String["1/2016","2/2016","3/2016","4/2016","5/2016","6/2016","7/2016","8/2016","9/2016","10/2016","11/2016","12/2016","1/2017"],[1.27,0.9,0.43,0.61,0.78,0.35,0.52,0.44,0.08,0.26,0.18,0.3,0.38])

``` 