using Test, Jos

# ---- Complex Numbers Example ----
const ComplexNumber = Jos._new_default_class(:ComplexNumber, [:real, :imag], [Jos.Object])
# Create some instances of complex numbers
const c1 = Jos.new(ComplexNumber, real=1, imag=2)
const c2 = Jos.new(ComplexNumber, real=3, imag=4)
# Create a new generic function
add = Jos.MGenericFunction(:add, [:x, :y], [])
# Specialize Generic Function for ComplexNumber
Jos._add_method(add, [ComplexNumber, ComplexNumber], (a, b) -> Jos.new(ComplexNumber, real=a.real + b.real, imag=a.imag + b.imag))
# Specialize Jos.print_object for ComplexNumber
Jos._add_method(Jos.print_object, [ComplexNumber, Jos.Top], (obj, io) -> print(io, "$(c.real)$(c.imag < 0 ? "-" : "+")$(abs(c.imag))i"))

# ---- Circle Example ----
const ColorMixin = Jos._new_default_class(:ColorMixin, [:color], [Jos.Object])
const Shape = Jos._new_default_class(:Shape, Symbol[], [Jos.Object])
const Circle = Jos._new_default_class(:Circle, [:center, :radius], [Shape])
const ColoredCircle = Jos._new_default_class(:ColoredCircle, Symbol[], [Circle, ColorMixin])

# ---- Tests Start ----
@testset "2.1 Classes" begin
    # -- Test Jos.Top -- 
    @test Jos.Top.name === :Top

    @test Jos.Top.cpl == [Jos.Top]
    @test Jos.Top.direct_superclasses == []

    @test Jos.Top.slots == []
    @test Jos.Top.direct_slots == []

    @test Jos.Top.defaulted == Dict{Symbol,Any}()

    @test Jos.class_of(Jos.Top) === Jos.Class

    # -- Test Jos.Object --
    @test Jos.Object.name === :Object

    @test Jos.Object.cpl == [Jos.Object, Jos.Top]
    @test Jos.Object.direct_superclasses == [Jos.Top]

    @test Jos.Object.slots == []
    @test Jos.Object.direct_slots == []

    @test Jos.Object.defaulted == Dict{Symbol,Any}()

    @test Jos.class_of(Jos.Object) === Jos.Class

    # -- Test Jos.Class --
    @test Jos.Class.name === :Class

    @test Jos.Class.cpl == [Jos.Class, Jos.Object, Jos.Top]
    @test Jos.Class.direct_superclasses == [Jos.Object]

    @test Jos.Class.slots == collect(fieldnames(Jos.MClass))
    @test Jos.Class.direct_slots == collect(fieldnames(Jos.MClass))

    @test Jos.Class.defaulted == Dict{Symbol,Any}()

    @test Jos.class_of(Jos.Class) === Jos.Class

    # -- Test Jos.MultiMethod --
    @test Jos.MultiMethod.name === :MultiMethod

    @test Jos.MultiMethod.cpl == [Jos.MultiMethod, Jos.Object, Jos.Top]
    @test Jos.MultiMethod.direct_superclasses == [Jos.Object]

    @test Jos.MultiMethod.slots == collect(fieldnames(Jos.MMultiMethod))
    @test Jos.MultiMethod.direct_slots == collect(fieldnames(Jos.MMultiMethod))

    @test Jos.MultiMethod.defaulted == Dict{Symbol,Any}()

    @test Jos.class_of(Jos.MultiMethod) === Jos.Class

    # -- Test Jos.GenericFunction --
    @test Jos.GenericFunction.name === :GenericFunction

    @test Jos.GenericFunction.cpl == [Jos.GenericFunction, Jos.Object, Jos.Top]
    @test Jos.GenericFunction.direct_superclasses == [Jos.Object]

    @test Jos.GenericFunction.slots == collect(fieldnames(Jos.MGenericFunction))
    @test Jos.GenericFunction.direct_slots == collect(fieldnames(Jos.MGenericFunction))

    @test Jos.GenericFunction.defaulted == Dict{Symbol,Any}()

    @test Jos.class_of(Jos.GenericFunction) === Jos.Class

    # -- Test Jos.BuiltInClass --
    @test Jos.BuiltInClass.name === :BuiltInClass

    @test Jos.BuiltInClass.cpl == [Jos.BuiltInClass, Jos.Class, Jos.Object, Jos.Top]
    @test Jos.BuiltInClass.direct_superclasses == [Jos.Class]

    @test Jos.BuiltInClass.slots == collect(fieldnames(Jos.MClass))
    @test Jos.BuiltInClass.direct_slots == []

    @test Jos.BuiltInClass.defaulted == Dict{Symbol,Any}()

    @test Jos.class_of(Jos.BuiltInClass) === Jos.Class

    # -- Test Jos._Int64 --
    @test Jos._Int64.name === :_Int64

    @test Jos._Int64.cpl == [Jos._Int64, Jos.Object, Jos.Top]
    @test Jos._Int64.direct_superclasses == [Jos.Object]

    @test Jos._Int64.slots == [:value]
    @test Jos._Int64.direct_slots == [:value]

    @test Jos._Int64.defaulted == Dict{Symbol,Any}()

    @test Jos.class_of(Jos._Int64) === Jos.BuiltInClass

    # -- Test Jos._String -
    @test Jos._String.name === :_String

    @test Jos._String.cpl == [Jos._String, Jos.Object, Jos.Top]
    @test Jos._String.direct_superclasses == [Jos.Object]

    @test Jos._String.slots == [:value]
    @test Jos._String.direct_slots == [:value]

    @test Jos._String.defaulted == Dict{Symbol,Any}()

    @test Jos.class_of(Jos._String) === Jos.BuiltInClass

    # -- TODO: Test @defclass -- 
end

@testset "2.2 Instances" begin
    # -- Test Jos.new with Too Many Arguments --
    @test_throws ErrorException Jos.new(ComplexNumber, real=1, imag=2, wrong=3)

    # -- Test Jos.new with Too Few Arguments --
    @test_throws ErrorException Jos.new(ComplexNumber, real=1)

    # -- Test Jos.new with Invalid Slot Name --
    @test_throws ErrorException Jos.new(ComplexNumber, real=1, wrong=3)

    # -- TODO: Test Jos.new with Missing Not Defaulted Slot --
end

@testset "2.3 Slot Access" begin
    # -- Test getproperty --
    @test getproperty(c1, :real) === 1
    @test c1.real === 1

    @test getproperty(c1, :imag) === 2
    @test c1.imag === 2

    @test_throws ErrorException c1.wrong

    # -- Test setproperty! --
    c1_copy = c1
    @test setproperty!(c1_copy, :imag, -1) === -1

    c1_copy.imag += 3
    @test c1.imag === 2

    @test_throws ErrorException c1_copy.wrong = 3
end

@testset "2.4 Generic Functions and Methods" begin
    # TODO: @defgeneric
    # TODO: @defmethod
end

@testset "2.5 Pre-defined Generic Functions and Methods" begin
    # -- Test Jos.print_object --
    @test Jos.class_of(Jos.print_object) === Jos.GenericFunction

    @test length(Jos.print_object.methods) != 0
    @test Jos.print_object.params == [:obj, :io]
    @test Jos.print_object.name === :print_object

    # TODO: Fix call_next_method
end

@testset "2.6 MetaObjects" begin
    # -- Test Jos.class_of --
    @test Jos.class_of(Jos.Top) === Jos.Class
    @test Jos.class_of(Jos.Object) === Jos.Class
    @test Jos.class_of(Jos.Class) === Jos.Class
    @test Jos.class_of(Jos.MultiMethod) === Jos.Class
    @test Jos.class_of(Jos.GenericFunction) === Jos.Class
    @test Jos.class_of(Jos.BuiltInClass) === Jos.Class

    @test Jos.class_of(Jos._Int64) === Jos.BuiltInClass
    @test Jos.class_of(Jos._String) === Jos.BuiltInClass

    @test Jos.class_of(ComplexNumber) === Jos.Class

    @test Jos.class_of(Jos.print_object) === Jos.GenericFunction
    @test Jos.class_of(Jos.print_object.methods[1]) === Jos.MultiMethod

    @test Jos.class_of(c1) === ComplexNumber

    # DUVIDA: Isto deve ser assim?
    @test Jos.class_of(1) === Jos.Top

    # -- Test ComplexNumber --
    @test ComplexNumber.name === :ComplexNumber

    @test ComplexNumber.cpl == [ComplexNumber, Jos.Object, Jos.Top]
    @test ComplexNumber.direct_superclasses == [Jos.Object]

    @test ComplexNumber.direct_slots == [:real, :imag]
    @test ComplexNumber.slots == [:real, :imag]

    @test ComplexNumber.defaulted == Dict{Symbol,Any}()

    # -- Test add Generic Function --    
    @test add.name === :add
    @test add.params == [:x, :y]
    @test length(add.methods) != 0
    @test add.methods[1].generic_function === add
    @test Jos.class_of(add) === Jos.GenericFunction
    @test Jos.class_of(add.methods[1]) === Jos.MultiMethod
end

@testset "2.7 Class Options" begin
    # TODO: @defclass with options
    # DUVIDA: meter missing é o mesmo que nao inicializar com nada?
end

@testset "2.8 Readers and Writers" begin
    # TODO: @defclass using @defmethod for getters and setters
end

@testset "2.9 Generic Function Calls" begin
    # -- TODO: Test no_applicable_method --    
end

@testset "2.10 Multiple Dispatch" begin
    # TODO: Shapes and Device example
    # @defclass(Shape, [], [])
    # @defclass(Device, [], [])
    # @defgeneric draw(shape, device)
    # @defclass(Line, [Shape], [from, to])
    # @defclass(Circle, [Shape], [center, radius])
    # @defclass(Screen, [Device], [])
    # @defclass(Printer, [Device], [])
    # @defmethod draw(shape::Line, device::Screen) = println("Drawing a Line on Screen")
    # @defmethod draw(shape::Circle, device::Screen) = println("Drawing a Circle on Screen")
    # @defmethod draw(shape::Line, device::Printer) = println("Drawing a Line on Printer")
    # @defmethod draw(shape::Circle, device::Printer) = println("Drawing a Circle on Printer")
    # let devices = [new(Screen), new(Printer)],
    # shapes = [new(Line), new(Circle)]
    # for device in devices
    # for shape in shapes
    # draw(shape, device)
    # end
    # end
    # end
    # end
end

@testset "2.11 Multiple Inheritance" begin
    # TODO
    # @defclass(ColorMixin, [],
    # [[color, reader=get_color, writer=set_color!]])
    # @defmethod draw(s::ColorMixin, d::Device) =
    # let previous_color = get_device_color(d)
    # set_device_color!(d, get_color(s))
    # call_next_method()
    # set_device_color!(d, previous_color)
    # end
    # @defclass(ColoredLine, [ColorMixin, Line], [])
    # @defclass(ColoredCircle, [ColorMixin, Circle], [])
    # @defclass(ColoredPrinter, [Printer],
    # [[ink=:black, reader=get_device_color, writer=_set_device_color!]])
    # @defmethod set_device_color!(d::ColoredPrinter, color) = begin
    # println("Changing printer ink color to $color")
    # _set_device_color!(d, color)
    # end
    # let shapes = [new(Line), new(ColoredCircle, color=:red), new(ColoredLine, color=:blue)],
    # printer = new(ColoredPrinter, ink=:black)
    # for shape in shapes
    # draw(shape, printer)
    # end
    # end
end

@testset "2.12 Class Hierarchy" begin
    # -- Test that Class Hierarchy is finite --
    # julia> ColoredCircle.direct_superclasses
    # [<Class ColorMixin>, <Class Circle>]
    # > ans[1].direct_superclasses
    # [<Class Object>]
    # > ans[1].direct_superclasses
    # [<Class Top>]
    # > ans[1].direct_superclasses
    # []

    # -- Test that Outer Objects are Top --
    # DUVIDA: Vale a pena ter uma classe que representa
    # objetos externos ao Jos e que herda de Top?
end

@testset "2.13 Class Precedence List" begin
    A = Jos.MClass(:A, Symbol[], Jos.MClass[])
    B = Jos.MClass(:B, Symbol[], Jos.MClass[])
    C = Jos.MClass(:C, Symbol[], Jos.MClass[])
    D = Jos.MClass(:D, Symbol[], Jos.MClass[A, B])
    E = Jos.MClass(:E, Symbol[], Jos.MClass[A, C])
    F = Jos.MClass(:F, Symbol[], Jos.MClass[D, E])

    # -- Test Class Precedence List --
    @test Jos._compute_cpl(F) == Vector{Jos.MClass}([F, D, E, A, B, C])
end

@testset "2.14 Built-In Classes" begin
    # DUVIDA: Como implementar? class_of(1) == Jos._Int64
    # DUVIDA: Como implementar? class_of("a") == Jos._String

    # -- Test Built-In Classes --
    @test Jos.class_of(Jos._Int64) == Jos.BuiltInClass
    @test Jos.class_of(Jos._String) == Jos.BuiltInClass
end

@testset "2.15 Introspection" begin
    @test Jos.class_name(Circle) === :Circle
    @test Jos.class_direct_slots(Circle) == [:center, :radius]

    @test Jos.class_slots(ColoredCircle) == [:center, :radius, :color]
    @test Jos.class_direct_slots(ColoredCircle) == []

    @test Jos.class_cpl(ColoredCircle) == [ColoredCircle, Circle, ColorMixin, Shape, Jos.Object, Jos.Top]
    @test Jos.class_direct_superclasses(ColoredCircle) == [Circle, ColorMixin]

    # @test length(Jos.generic_methods(draw)) == 2

    # @test length(Jos.method_specializers(Jos.generic_methods(draw)[1])) == 2
end

@testset "2.16.1 Class Instantiation Protocol" begin
    # TODO
    # @defclass(CountingClass, [Class], [counter=0])
    # @defmethod allocate_instance(class::CountingClass) = begin
    #   class.counter += 1
    #   call_next_method()
    # end
    # @defclass(Foo, [], [], metaclass=CountingClass) == <CountingClass Foo>
    # @defclass(Bar, [], [], metaclass=CountingClass) == <CountingClass Bar>
    # new(Foo)
    # new(Foo)
    # new(Bar)
    # Foo.counter == 2
    # Bar.counter == 1
end

@testset "2.16.2 The Compute Slots Protocol" begin
    # TODO
    # @defmethod compute_slots(class::Class) = 
    #  vcat(map(class_direct_slots, class_cpl(class))...)
    # @defclass(Foo, [], [a=1, b=2])
    # @defclass(Bar, [Foo], [b=3, c=4])
    # @defclass(FooBar, [Foo, Bar], [a=5, d=6])
    # class_slots(Bar) == [:a, :d, :a, :b, :b, :c]
    # foobar1 = new(FooBar)
    # foobar1.a == 1
    # foobar1.b == 3
    # foobar1.c == 4
    # foobar1.d == 6

    # Collision Detection metaclass
    # @defclass(AvoidCollisionsClass, [Class], [])
    # @defmethod compute_slots(class::AvoidCollisionsClass) = 
    # let slots = call_next_method(),
    #   duplicates = symdiff(slots, unique(slots))
    #   isempty(duplicates) ? slots :
    #   error("Multiple occurrences of slots: $(join(map(string, duplicates), ", "))")
    # end
end

@testset "2.16.3 Slot Access Protocol" begin
    # TODO: Understand how to implement this
    # test with undoclass example
end

@testset "2.16.4 Class Precedence List Protocol" begin
    # @defclass(FlavorsClass, [Class], [])
    # @defmethod compute_cpl(class::FlavorsClass) = 
    #   let depth_first_cpl(class) =
    #       [class, foldl(vcat, map(depth_first_cpl, class_direct_superclasses(class)), init=[])...],
    #       base_cpl = [Object, Top]
    #       vcat(unique(filter(!in(base_cpl), depth_first_cpl(class))), base_cpl)
    #   end

    # @defclass(A, [], [], metaclass=FlavorsClass)
    # @defclass(B, [], [], metaclass=FlavorsClass)
    # @defclass(C, [], [], metaclass=FlavorsClass)
    # @defclass(D, [A, B], [], metaclass=FlavorsClass)
    # @defclass(E, [A, C], [], metaclass=FlavorsClass)
    # @defclass(F, [D, E], [], metaclass=FlavorsClass)

    # compute_cpl(F) == [F, D, A, B, E, C, Object, Top]
end

@testset "2.17 Multiple Meta-Class Inheritance" begin
    # TODO: undoable, collision-avoiding, counting class example
end

@testset "2.18 Extensions" begin
    # TODO
end