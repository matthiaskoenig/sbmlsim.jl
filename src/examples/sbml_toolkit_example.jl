# Loading the model with the latest version of the SBMLToolkit
# To install use
# using Pkg
# Pkg.add("SBMLToolkit")
# SBMLToolkit ─ v0.1.30
# import works with the latest version, but required to test that the numerical results are identical

using SBMLToolkit, OrdinaryDiffEq

path_sbml = joinpath(@__DIR__, "dapagliflozin_body_flat.xml")
println(path_sbml)
odesys = readSBML(path_sbml, ODESystemImporter())