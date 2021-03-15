# IFAC benchmarks
@testset "IFAC Benchmarks" begin
    @safetestset "Binary Distillation Column" begin include( "ifac/prob9001-binaryDistillationColumn.jl" ) end
    @safetestset "Drum Boiler"                begin include( "ifac/prob9002-drumBoiler.jl" )               end
    @safetestset "B767 Flutter Condition"     begin include( "ifac/prob9006-airplaneFlutter.jl" )          end
end

# Miscellaneous benchmarks
@testset "Miscellaneous Benchmarks" begin
    @safetestset "Ball on plate system" begin include( "ballOnPlate.jl" ) end
    @safetestset "Jones-Morari system"  begin include( "jonesMorari.jl" ) end
end

# Mass-Spring system benchmarks
@testset "Mass-Spring Systems" begin
    @safetestset "Linear Mass-Spring-Damper Chain"        begin include( "massSpringSystems/linearMassSpringDamper.jl" )  end
end
