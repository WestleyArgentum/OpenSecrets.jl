import Base.read, Base.eof, Base.close
 
type OpenSecretsBuffer <: IO
    io::IO
    peek
    add_backslash

 
    OpenSecretsBuffer(io::IO) = new(io, nothing, false)
end
 
function Base.read(os::OpenSecretsBuffer, ::Type{Uint8})
    c = Base.read(os.io, Uint8)
    c == '\\' ? ' ' : c
end

Base.eof(os::OpenSecretsBuffer) = os.peek == nothing && eof(os.io)

Base.close(os::OpenSecretsBuffer) = close(os.io)