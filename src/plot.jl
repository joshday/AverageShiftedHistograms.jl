@doc md"Plot an `Ash1`density estimate" ->
function Gadfly.plot(obj::Ash1)
    Gadfly.plot(x = obj.x, y=obj.y, Gadfly.Geom.line)
end

function Gadfly.plot(obj::Ash1, data::Vector)
    Gadfly.plot(Gadfly.layer(x = obj.x, y=obj.y, Gadfly.Geom.line, order=2,
                             Gadfly.Theme(default_color=Gadfly.color("black"))),
                Gadfly.layer(x=data, Gadfly.Geom.histogram(density=true), order=1))
end





@doc md"Plot an `Ash2`density estimate" ->
function Gadfly.plot(obj::Ash2; levels=10)
    Gadfly.plot(x = obj.x, y=obj.y, z=obj.z, Gadfly.Geom.contour(levels=levels))
end



