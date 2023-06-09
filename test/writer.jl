using POMDPFiles
using POMDPTools
using POMDPModels
using Test
using SHA

@testset "Writing TigerPOMDP" begin
    pomdp = TigerPOMDP()
    @testset "Numeric Representation" begin
        filename = tempname()
        numericprint(filename, pomdp)
        file_sha = open(sha256, filename)
        disk_sha = open(sha256, joinpath(TEST_DATA, "tiger.numeric.pomdp"))
        @test all(file_sha .== disk_sha)
    end
    @testset "Readable Representation" begin
        filename = tempname()
        sname = (idx) -> ["tiger-left", "tiger-right"][idx + 1]
        aname = (idx) -> ["listen", "open-left", "open-right"][idx + 1]
        oname = (idx) -> ["tiger-left", "tiger-right"][idx + 1]
        symbolicprint(filename, pomdp; sname=sname, aname=aname, oname=oname)
        file_sha = open(sha256, filename)
        disk_sha = open(sha256, joinpath(TEST_DATA, "tiger.symbolic.pomdp"))
        @test all(file_sha .== disk_sha)
    end
end
