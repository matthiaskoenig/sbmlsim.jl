# Testing the import of SBML models for simulations

using SBMLImporter
using Catalyst
using OrdinaryDiffEq
using ModelingToolkit
using Sundials

# path_sbml = joinpath(@__DIR__, "dapagliflozin_intestine.xml")
path_sbml = joinpath(@__DIR__, "dapagliflozin_body_flat.xml")
prn, cb = load_SBML(path_sbml, massaction=false)


# information about system
rn = prn.rn
# species(rn)
# nonspecies(rn)

# parameters(rn)

# equations(rn)
# reactions(rn)
nonreactions(rn)
println.(nonreactions(rn))

# u0 = prn.u0
# p = prn.p
# sbml_species = species(prn.rn)
# c = getcompartment(sbml_species[1])


tspan = (0.0, 24 * 60.0)
odesys = structural_simplify(convert(ODESystem, prn.rn))
prob = ODEProblem(odesys, prn.u0, tspan, prn.p, jac=true)
tpoints = range(tspan[1], stop=tspan[2], length=1001)
integrator = Rodas5P()


@time begin
sol = solve(
    prob, 
    integrator, # CVODE_BDF(), # Rosenbrock23(), # Tsit5()
    dense=false, saveat=tpoints)
end

# changing parameters and settings
# # updating problems using remake: https://docs.sciml.ai/Catalyst/stable/model_simulation/simulation_structure_interfacing/#simulation_structure_interfacing_problems_remake

# prob_new = remake(prob; u0 = [:PODOSE_dap => 10.0])
prob_new = prob
prob[:PODOSE_dap] = 10.0   # [mg]


@time begin
    sol = solve(prob_new, integrator, dense=false, saveat=tpoints)
end