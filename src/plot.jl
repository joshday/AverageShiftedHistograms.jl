@doc md"Plot an `Ash1`density estimate" ->
function Gadfly.plot(obj::Ash1, args...)
    Gadfly.plot(x = obj.x, y=obj.y, Gadfly.Geom.line, args...)
end

function Gadfly.plot(obj::Ash1, data::Vector, args...)
    Gadfly.plot(Gadfly.layer(x = obj.x, y=obj.y, Gadfly.Geom.line, order=2,
                             Gadfly.Theme(default_color=Gadfly.color("black"))),
                Gadfly.layer(x=data, Gadfly.Geom.histogram(density=true), order=1),
                args...)
end





@doc md"Plot an `Ash2`density estimate" ->
function Gadfly.plot(obj::Ash2; levels=10, args...)
    Gadfly.plot(x = obj.x, y=obj.y, z=obj.z, Gadfly.Geom.contour(levels=levels),
                args...)
end



