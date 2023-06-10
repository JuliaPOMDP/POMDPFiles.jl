using POMDPs
using POMDPFiles
using POMDPTools
using POMDPModels
using Test

pomdpfiles = filter(endswith(".pomdp"), readdir(TEST_SOURCES; join=true))

@testset "Reading \"Litmann's 1D POMDP\"" begin
    file = first(filter(endswith("1d.pomdp"), pomdpfiles))
    pomdp = read_pomdp(file)

    @test has_consistent_distributions(pomdp; atol=1e-5)

    @test discount(pomdp) == 0.75
    @test length(states(pomdp)) == 4
    @test length(actions(pomdp)) == 2
    @test length(observations(pomdp)) == 2

    @test POMDPTools.has_consistent_distributions(pomdp, atol=1e-5)

    T = transition(pomdp, 1, 1)
    @test pdf(T, 1) == 1.0 && rand(T) == 1
    O = observation(pomdp, 1, 1)
    @test pdf(O, 1) == 1.0 && rand(O) == 1
    @test reward(pomdp, 1, 1) == 1.0
end

@testset "Reading \"Parr & Russell's POMDP\"" begin
    file = first(filter(endswith("parr95.95.pomdp"), pomdpfiles))
    pomdp = read_pomdp(file)

    @test has_consistent_distributions(pomdp; atol=1e-5)

    @test discount(pomdp) == 0.95
    @test length(actions(pomdp)) == 3
    @test length(observations(pomdp)) == 6
    @test length(states(pomdp)) == 7

    T = transition(pomdp, 1, 1)
    @test pdf(T, 2) == 0.5 && in(rand(T), [2, 3])
    O = observation(pomdp, 1, 1)
    @test pdf(O, 1) == 1.0 && rand(O) == 1
    @test reward(pomdp, 6, 1) == 2.0
end
