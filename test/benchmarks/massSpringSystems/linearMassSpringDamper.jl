using ControlBenchmarks
using ControlSystems
using SparseArrays


# Test the constructor with 1 mass and all values equal to 1
msd = LinearMassSpringDamperChain( 1, 1, 1, 1 )
sys = controlbenchmark( msd )

@test ControlSystems.nstates( sys ) == 2
@test ControlSystems.ninputs( sys ) == 1
@test ControlSystems.noutputs( sys ) == 2

@test issparse( sys.A )
@test issparse( sys.B )
@test issparse( sys.C )
@test issparse( sys.D )


# Test the non-damper constructor with 1 mass and all values equal to 1
ms = LinearMassSpringChain( 1, 1, 1 )
sys = controlbenchmark( ms )

@test ControlSystems.nstates( sys ) == 2
@test ControlSystems.ninputs( sys ) == 1
@test ControlSystems.noutputs( sys ) == 2

@test issparse( sys.A )
@test issparse( sys.B )
@test issparse( sys.C )
@test issparse( sys.D )


######################################################
# Test the validity checks in the constructor
######################################################

# Give more values than are needed
@test_throws ErrorException LinearMassSpringDamperChain( 1, [1 1 1], 1, 1 )
@test_throws ErrorException LinearMassSpringDamperChain( 1, 1, [1 1 1], 1 )
@test_throws ErrorException LinearMassSpringDamperChain( 1, 1, 1, [1 1] )

# More inputs than masses
@test_throws ErrorException LinearMassSpringDamperChain( 2, 1, 1, 1, inputs = [1 2 3] )

# Input requested on a mass that doesn't exist
@test_throws DomainError LinearMassSpringDamperChain( 2, 1, 1, 1, inputs = [1 3] )


# Give more values than are needed
@test_throws ErrorException LinearMassSpringChain( 1, [1 1 1], 1 )
@test_throws ErrorException LinearMassSpringChain( 1, 1, [1 1] )

# More inputs than masses
@test_throws ErrorException LinearMassSpringChain( 2, 1, 1, inputs = [1 2 3] )

# Input requested on a mass that doesn't exist
@test_throws DomainError LinearMassSpringChain( 2, 1, 1, inputs = [1 3] )


######################################################
# Construct a 5 chain and see if it matches with a computed example from the literature
######################################################

m = 1000
k = 1000
β = 200

sys = controlbenchmark( LinearMassSpringDamperChain( 5, k, β, m ) )

A = sys.A

# Test values for mass 1
@test A[6, 1] == ( -2 * k / m)
@test A[6, 2] == ( k / m)
@test A[6, 6] == ( -2 * β / m)
@test A[6, 7] == ( β / m)

# Test values for mass 2, 3, 4
for i = 2:4
    @test A[i+5, i-1] == ( k / m)
    @test A[i+5,   i] == ( -2 * k / m)
    @test A[i+5, i+1] == ( k / m)

    @test A[i+5, 5+i-1] == ( β / m)
    @test A[i+5,   5+i] == ( -2 * β / m)
    @test A[i+5, 5+i+1] == ( β / m)
end

# Test values for mass 5
@test A[10,  4] == ( k / m)
@test A[10,  5] == ( -2 * k / m)
@test A[10,  9] == ( β / m)
@test A[10, 10] == ( -2 * β / m)

# There should be only 2 inputs
@test nnz( sys.B ) == 2
@test sys.B[6,  1] == ( -1 / m )
@test sys.B[10, 2] == ( -1 / m )


######################################################
# Do some slight tweaks to the chain
######################################################

m = 1000
k = 1000
β = 200

# No damping and 3 inputs
sys = controlbenchmark( LinearMassSpringDamperChain( 5, k, 0, m; inputs = [1, 3, 5] ) )

A = sys.A

# No damping was requested

# Test values for mass 1
@test A[6, 6] == 0
@test A[6, 7] == 0

# Test values for mass 2, 3, 4
for i = 2:4
    @test A[i+5, 5+i-1] == 0
    @test A[i+5,   5+i] == 0
    @test A[i+5, 5+i+1] == 0
end

# Test values for mass 5
@test A[10,  9] == 0
@test A[10, 10] == 0

# We should have 3 inputs now
@test nnz( sys.B ) == 3
