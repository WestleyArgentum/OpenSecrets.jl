import Base.read, Base.eof, Base.close

# the conversion never returns 0x00 as a continuation character
const EMPTY = 0x00
 
type Latin1Buffer <: IO
    io::IO
    padding::Uint8
 
    Latin1Buffer(io::IO) = new(io, EMPTY)
end
 
function Base.read(l1::Latin1Buffer, ::Type{Uint8})
    if l1.padding == EMPTY
        c = read(l1.io, Uint8)
        if c >= 0x80
            c, l1.padding = c < 0xc0 ? (0xc2, c) : (0xc3, uint8(c - 0x40))
        end
        c
    else
        tmp = l1.padding
        l1.padding = EMPTY
        tmp
    end
end

Base.eof(l1::Latin1Buffer) = l1.padding == EMPTY && eof(l1.io)

Base.close(l1::Latin1Buffer) = close(l1.io)