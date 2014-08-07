
module OpenSecrets

using DataFrames

export pacs_to_candidates, committees, candidates,
       pacs_to_other, individual_contributions

include("latin1buffer.jl")
include("opensecretsbuffer.jl")
include("data_detection.jl")
include("data_loading.jl")

global _campaign_finance_data_sources = detect_data_sources()

end
