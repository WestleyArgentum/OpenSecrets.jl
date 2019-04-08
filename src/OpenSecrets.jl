
module OpenSecrets

using DataFrames

include("latin1buffer.jl")
include("opensecretsbuffer.jl")
include("data_detection.jl")
include("data_loading.jl")

global _campaign_finance_data_sources = detect_data_sources()

end
